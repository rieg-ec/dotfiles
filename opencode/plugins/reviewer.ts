/**
 * Reviewer plugin for OpenCode.
 *
 * Provides a `review` tool that forks the current conversation to a stronger
 * model for an in-depth code review. The tool:
 *
 * 1. Fetches all messages from the current session via the SDK
 * 2. Formats them as a transcript
 * 3. Creates an ephemeral session and sends the transcript to a stronger model
 * 4. Returns only the review findings — no bloat in the main conversation
 *
 * The tool permission should be set to "ask" so the agent cannot invoke it
 * autonomously. Pair with the `/review` command for ergonomic invocation.
 */

import { type Plugin, tool } from "@opencode-ai/plugin";

const REVIEW_MODEL = {
  providerID: "anthropic",
  modelID: "claude-opus-4-6",
};

function buildReviewPrompt(transcript: string, focus?: string): string {
  return `You are a principal engineer conducting an in-depth code review.
You have been given the full transcript of a coding session. Your job is NOT
to give surface-level feedback — the implementing agent can do that itself.
Your job is to catch what it missed: subtle bugs, architectural concerns,
production risks, and edge cases.

${focus ? `## Priority focus area\n${focus}\n` : ""}

## Instructions

For each finding, provide ALL of the following:

### Identification
- **File and line** (file:line format)
- **Severity**: critical / warning / suggestion
- **Category**: bug, security, performance, architecture, correctness, edge-case, convention

### Analysis
- **What's wrong**: Explain the actual problem — not just "this looks wrong" but WHY
  it's wrong. What specific scenario triggers the issue? What assumption is being
  violated?
- **Impact**: What happens in production if this ships as-is? Who is affected and how?
  Be concrete — "users with concurrent requests could see stale data" not "might cause
  issues."

### Solution
- **Recommended fix**: Show the actual code change, not just a description. Include
  the surrounding context so the implementing agent can apply it directly.
- **Why this fix**: Explain why this approach is better than alternatives. If there are
  trade-offs, name them.
- **What to watch out for**: Any secondary effects of the fix — other files that need
  updating, tests that need changing, migrations to consider.

### If applicable
- **Alternative approaches**: When there's more than one valid solution, briefly
  outline the alternatives with pros/cons.
- **Testing gap**: If the issue reveals a missing test case, describe what test should
  be added and what it should assert.

## What NOT to do
- Don't flag style preferences unless they cause actual confusion
- Don't suggest changes that are purely cosmetic
- Don't repeat what the implementing agent already discussed in the transcript
- Don't praise the code — only report findings or state "no issues found"

## Output format

Start with a one-line verdict: **APPROVE**, **APPROVE WITH SUGGESTIONS**, or
**REQUEST CHANGES**.

Then list each finding grouped by file. End with a "Summary" section that lists
the findings by severity count and any cross-cutting concerns (e.g., "3 of the
5 findings relate to missing error handling in async paths — consider a
systematic pass").

---

<transcript>
${transcript}
</transcript>`;
}

type MessagePart = {
  type: string;
  text?: string;
  toolName?: string;
  args?: Record<string, unknown>;
};

type MessageEntry = {
  info: { role: string };
  parts: MessagePart[];
};

function formatTranscript(messages: MessageEntry[]): string {
  return messages
    .map((m) => {
      const role = m.info.role === "user" ? "USER" : "ASSISTANT";
      const texts = m.parts
        .filter((p) => p.type === "text" && p.text)
        .map((p) => p.text);
      const toolCalls = m.parts
        .filter((p) => p.type === "tool-invocation")
        .map((p) => `[tool: ${p.toolName}(${JSON.stringify(p.args ?? {})})]`);
      const content = [...texts, ...toolCalls].filter(Boolean).join("\n");
      return content ? `## ${role}\n${content}` : null;
    })
    .filter(Boolean)
    .join("\n\n---\n\n");
}

const ReviewerPlugin: Plugin = async ({ client }) => {
  return {
    tool: {
      review: tool({
        description:
          "Fork the current conversation to a stronger model for an in-depth " +
          "code review. The reviewer sees the full session context. Only the " +
          "findings are returned. Only invoke when the user explicitly " +
          "requests a review.",
        args: {
          focus: tool.schema
            .string()
            .optional()
            .describe("Optional area to focus the review on"),
        },
        async execute(args, context) {
          // 1. Fetch all messages from the current session
          const response = await client.session.messages({
            path: { id: context.sessionID },
          });
          const messages = (response as { data: MessageEntry[] }).data;

          // 2. Format as a transcript
          const transcript = formatTranscript(messages);
          if (!transcript) {
            return "No conversation context found to review.";
          }

          // 3. Create an ephemeral session for the review
          const sessionResponse = await client.session.create({
            body: {},
          });
          const reviewSessionId = (
            sessionResponse as { data: { id: string } }
          ).data.id;

          // 4. Send transcript + review prompt with the stronger model
          const result = await client.session.prompt({
            path: { id: reviewSessionId },
            body: {
              model: REVIEW_MODEL,
              parts: [
                {
                  type: "text" as const,
                  text: buildReviewPrompt(transcript, args.focus),
                },
              ],
            },
          });

          // 5. Extract and return only the review text
          const resultData = result as {
            data: { parts: MessagePart[] };
          };
          const reviewText = resultData.data.parts
            .filter((p) => p.type === "text" && p.text)
            .map((p) => p.text)
            .join("\n");

          // 6. Clean up the ephemeral session
          await client.session
            .delete({ path: { id: reviewSessionId } })
            .catch(() => {});

          return reviewText || "The reviewer produced no output.";
        },
      }),
    },
  };
};

export { ReviewerPlugin };
