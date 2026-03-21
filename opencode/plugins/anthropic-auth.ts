/**
 * Anthropic OAuth authentication plugin for OpenCode.
 *
 * Enables Claude Pro/Max OAuth login and adds required beta headers:
 * - claude-code-20250219: Claude Code identity (all models except haiku)
 * - oauth-2025-04-20: OAuth authentication
 * - interleaved-thinking-2025-05-14: Native reasoning between tool calls
 * - context-1m-2025-08-07: 1 million token context window (opus/sonnet)
 * - prompt-caching-scope-2026-01-05: Prompt caching
 *
 * Also handles:
 * - Token refresh when expired
 * - System prompt identity prefix injection
 * - Tool name prefixing (mcp_) for compatibility
 * - Zero cost display for OAuth users (Pro/Max plan)
 * - Fingerprint alignment with Claude Code v2.1.80
 */

import { createHash, randomBytes } from "node:crypto";
import type { Plugin } from "@opencode-ai/plugin";

const CLIENT_ID = "9d1c250a-e61b-44d9-88ed-5944d1962f5e";
const SYSTEM_IDENTITY_PREFIX =
  "You are Claude Code, Anthropic's official CLI for Claude.";
const TOOL_PREFIX = "mcp_";
const CC_VERSION = "2.1.80";
const CREDENTIAL_CACHE_TTL_MS = 30_000;

const REQUIRED_BETAS = [
  "claude-code-20250219",
  "oauth-2025-04-20",
  "interleaved-thinking-2025-05-14",
  "prompt-caching-scope-2026-01-05",
];

let cachedAuth: OAuthStored | null = null;
let cachedAuthAt = 0;

function toBase64Url(input: Buffer | string): string {
  return Buffer.from(input)
    .toString("base64")
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/g, "");
}

function generatePKCE(): { verifier: string; challenge: string } {
  const verifier = toBase64Url(randomBytes(32));
  const challenge = toBase64Url(
    createHash("sha256").update(verifier).digest(),
  );
  return { verifier, challenge };
}

function isCredentialUsable(creds: OAuthStored): boolean {
  return creds.expires > Date.now() + 60_000;
}

function getCachedAuth(): OAuthStored | null {
  if (
    cachedAuth &&
    Date.now() - cachedAuthAt < CREDENTIAL_CACHE_TTL_MS &&
    isCredentialUsable(cachedAuth)
  ) {
    return cachedAuth;
  }
  return null;
}

function setCachedAuth(auth: OAuthStored): void {
  cachedAuth = auth;
  cachedAuthAt = Date.now();
}

type OAuthStored = {
  type: "oauth";
  refresh: string;
  access: string;
  expires: number;
};

type OAuthSuccess = {
  type: "success";
  provider?: string;
  refresh: string;
  access: string;
  expires: number;
};

type ApiKeySuccess = {
  type: "success";
  provider?: string;
  key: string;
};

type FailedResult = {
  type: "failed";
};

type AuthResult = OAuthSuccess | ApiKeySuccess | FailedResult;

async function authorize(mode: "max" | "console") {
  const pkce = generatePKCE();

  const url = new URL(
    `https://${mode === "console" ? "console.anthropic.com" : "claude.ai"}/oauth/authorize`,
  );
  url.searchParams.set("code", "true");
  url.searchParams.set("client_id", CLIENT_ID);
  url.searchParams.set("response_type", "code");
  url.searchParams.set(
    "redirect_uri",
    "https://console.anthropic.com/oauth/code/callback",
  );
  url.searchParams.set(
    "scope",
    "org:create_api_key user:profile user:inference user:sessions:claude_code user:mcp_servers user:file_upload",
  );
  url.searchParams.set("code_challenge", pkce.challenge);
  url.searchParams.set("code_challenge_method", "S256");
  url.searchParams.set("state", pkce.verifier);
  return {
    url: url.toString(),
    verifier: pkce.verifier,
  };
}

async function exchange(
  code: string,
  verifier: string,
): Promise<OAuthSuccess | FailedResult> {
  const splits = code.split("#");
  const result = await fetch("https://console.anthropic.com/v1/oauth/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      code: splits[0],
      state: splits[1],
      grant_type: "authorization_code",
      client_id: CLIENT_ID,
      redirect_uri: "https://console.anthropic.com/oauth/code/callback",
      code_verifier: verifier,
    }),
  });
  if (!result.ok) {
    const errorBody = await result.text().catch(() => "no body");
    console.error(`[anthropic-auth] exchange failed: ${result.status} ${errorBody}`);
    return { type: "failed" };
  }
  const json = (await result.json()) as {
    refresh_token: string;
    access_token: string;
    expires_in: number;
  };
  return {
    type: "success",
    refresh: json.refresh_token,
    access: json.access_token,
    expires: Date.now() + json.expires_in * 1000 - 5 * 60 * 1000,
  };
}

function getModelBetas(modelId: string): string[] {
  const betas = [...REQUIRED_BETAS];
  const lower = modelId.toLowerCase();

  if (lower.includes("opus") || lower.includes("sonnet")) {
    betas.push("context-1m-2025-08-07");
  }

  if (lower.includes("haiku")) {
    const idx = betas.indexOf("claude-code-20250219");
    if (idx !== -1) betas.splice(idx, 1);
  }

  return betas;
}

function getBillingHeader(modelId: string): string {
  return `cc_version=${CC_VERSION}.${modelId}; cc_entrypoint=cli; cch=00000;`;
}

function stripToolPrefix(text: string): string {
  return text.replace(/"name"\s*:\s*"mcp_([^"]+)"/g, '"name": "$1"');
}

const AnthropicAuthPlugin: Plugin = async ({ client }) => {
  return {
    "experimental.chat.system.transform": async (
      input: { model?: { providerID?: string } },
      output: { system: string[] },
    ) => {
      if (input.model?.providerID !== "anthropic") {
        return;
      }

      const hasIdentityPrefix = output.system.some((entry) =>
        entry.includes(SYSTEM_IDENTITY_PREFIX),
      );
      if (!hasIdentityPrefix) {
        output.system.unshift(SYSTEM_IDENTITY_PREFIX);
      }
    },
    auth: {
      provider: "anthropic",
      async loader(
        getAuth: () => Promise<OAuthStored | { type: string }>,
        provider: { models: Record<string, { cost?: unknown }> },
      ) {
        const auth = await getAuth();
        if (auth.type === "oauth") {
          // Zero out cost display for Pro/Max plan users
          for (const model of Object.values(provider.models)) {
            model.cost = {
              input: 0,
              output: 0,
              cache: {
                read: 0,
                write: 0,
              },
            };
          }
          return {
            apiKey: "",
            async fetch(input: Request | string | URL, init?: RequestInit) {
              // Use cached auth if fresh, otherwise fetch + cache
              let currentAuth = getCachedAuth();
              if (!currentAuth) {
                currentAuth = (await getAuth()) as OAuthStored;
                if (currentAuth.type === "oauth") {
                  setCachedAuth(currentAuth);
                }
              }
              if (currentAuth.type !== "oauth") return fetch(input, init);

              // Refresh token if expired
              if (!currentAuth.access || currentAuth.expires < Date.now()) {
                const response = await fetch(
                  "https://console.anthropic.com/v1/oauth/token",
                  {
                    method: "POST",
                    headers: {
                      "Content-Type": "application/json",
                    },
                    body: JSON.stringify({
                      grant_type: "refresh_token",
                      refresh_token: currentAuth.refresh,
                      client_id: CLIENT_ID,
                    }),
                  },
                );
                if (!response.ok) {
                  throw new Error(`Token refresh failed: ${response.status} ${await response.text()}`);
                }
                const json = (await response.json()) as {
                  refresh_token: string;
                  access_token: string;
                  expires_in: number;
                };
                const updated: OAuthStored = {
                  type: "oauth",
                  refresh: json.refresh_token,
                  access: json.access_token,
                  expires: Date.now() + json.expires_in * 1000 - 5 * 60 * 1000,
                };
                await client.auth.set({
                  path: { id: "anthropic" },
                  body: updated,
                });
                currentAuth = updated;
                setCachedAuth(updated);
              }

              const requestInit = init ?? {};

              // Build headers
              const requestHeaders = new Headers();
              if (input instanceof Request) {
                input.headers.forEach((value, key) => {
                  requestHeaders.set(key, value);
                });
              }
              if (requestInit.headers) {
                if (requestInit.headers instanceof Headers) {
                  requestInit.headers.forEach((value, key) => {
                    requestHeaders.set(key, value);
                  });
                } else if (Array.isArray(requestInit.headers)) {
                  for (const [key, value] of requestInit.headers as [string, string][]) {
                    if (typeof value !== "undefined") {
                      requestHeaders.set(key, String(value));
                    }
                  }
                } else {
                  for (const [key, value] of Object.entries(
                    requestInit.headers,
                  )) {
                    if (typeof value !== "undefined") {
                      requestHeaders.set(key, String(value));
                    }
                  }
                }
              }

              // Extract model ID for model-aware headers
              let modelId = "unknown";
              if (typeof requestInit.body === "string") {
                try {
                  modelId =
                    (JSON.parse(requestInit.body) as { model?: string }).model ??
                    "unknown";
                } catch {
                  // ignore
                }
              }

              // Merge beta headers - model-aware + preserve incoming
              const incomingBeta = requestHeaders.get("anthropic-beta") || "";
              const incomingBetasList = incomingBeta
                .split(",")
                .map((b) => b.trim())
                .filter(Boolean);

              const modelBetas = getModelBetas(modelId);
              const mergedBetas = [
                ...new Set([...modelBetas, ...incomingBetasList]),
              ].join(",");

              requestHeaders.set("authorization", `Bearer ${currentAuth.access}`);
              requestHeaders.set("anthropic-beta", mergedBetas);
              requestHeaders.set("x-app", "cli");
              requestHeaders.set(
                "user-agent",
                `claude-cli/${CC_VERSION} (external, cli)`,
              );
              requestHeaders.set(
                "x-anthropic-billing-header",
                getBillingHeader(modelId),
              );
              requestHeaders.delete("x-api-key");

              // Transform request body
              let body = requestInit.body;
              if (body && typeof body === "string") {
                try {
                  const parsed = JSON.parse(body);

                  // Add prefix to tools definitions
                  if (parsed.tools && Array.isArray(parsed.tools)) {
                    parsed.tools = parsed.tools.map(
                      (tool: { name?: string }) => ({
                        ...tool,
                        name: tool.name
                          ? `${TOOL_PREFIX}${tool.name}`
                          : tool.name,
                      }),
                    );
                  }

                  // Add prefix to tool_use blocks in messages
                  if (parsed.messages && Array.isArray(parsed.messages)) {
                    parsed.messages = parsed.messages.map(
                      (msg: { content?: Array<{ type?: string; name?: string }> }) => {
                        if (msg.content && Array.isArray(msg.content)) {
                          msg.content = msg.content.map((block) => {
                            if (block.type === "tool_use" && block.name) {
                              return {
                                ...block,
                                name: `${TOOL_PREFIX}${block.name}`,
                              };
                            }
                            return block;
                          });
                        }
                        return msg;
                      },
                    );
                  }
                  body = JSON.stringify(parsed);
                } catch {
                  // ignore parse errors
                }
              }

              const response = await fetch(input, {
                ...requestInit,
                body,
                headers: requestHeaders,
              });

              // Transform streaming response to rename tools back (remove mcp_ prefix)
              // Buffer until SSE event boundaries (\n\n) to avoid splitting mid-JSON
              if (response.body) {
                const reader = response.body.getReader();
                const decoder = new TextDecoder();
                const encoder = new TextEncoder();
                let buffer = "";

                const stream = new ReadableStream({
                  async pull(controller) {
                    for (;;) {
                      const boundary = buffer.indexOf("\n\n");
                      if (boundary !== -1) {
                        const completeEvent = buffer.slice(0, boundary + 2);
                        buffer = buffer.slice(boundary + 2);
                        controller.enqueue(
                          encoder.encode(stripToolPrefix(completeEvent)),
                        );
                        return;
                      }

                      const { done, value } = await reader.read();

                      if (done) {
                        if (buffer) {
                          controller.enqueue(
                            encoder.encode(stripToolPrefix(buffer)),
                          );
                          buffer = "";
                        }
                        controller.close();
                        return;
                      }

                      buffer += decoder.decode(value, { stream: true });
                    }
                  },
                });

                return new Response(stream, {
                  status: response.status,
                  statusText: response.statusText,
                  headers: response.headers,
                });
              }

              return response;
            },
          };
        }

        return {};
      },
      methods: [
        {
          label: "Claude Pro/Max",
          type: "oauth",
          authorize: async () => {
            const { url, verifier } = await authorize("max");
            return {
              url,
              instructions: "Paste the authorization code here: ",
              method: "code",
              callback: async (code: string): Promise<AuthResult> => {
                return exchange(code, verifier);
              },
            };
          },
        },
        {
          label: "Create an API Key",
          type: "oauth",
          authorize: async () => {
            const { url, verifier } = await authorize("console");
            return {
              url,
              instructions: "Paste the authorization code here: ",
              method: "code",
              callback: async (code: string): Promise<AuthResult> => {
                const credentials = await exchange(code, verifier);
                if (credentials.type === "failed") return credentials;
                const result = await fetch(
                  `https://api.anthropic.com/api/oauth/claude_cli/create_api_key`,
                  {
                    method: "POST",
                    headers: {
                      "Content-Type": "application/json",
                      authorization: `Bearer ${credentials.access}`,
                    },
                  },
                ).then((r) => r.json() as Promise<{ raw_key: string }>);
                return { type: "success", key: result.raw_key };
              },
            };
          },
        },
        {
          provider: "anthropic",
          label: "Manually enter API Key",
          type: "api",
        },
      ],
    },
  };
};

export { AnthropicAuthPlugin };
