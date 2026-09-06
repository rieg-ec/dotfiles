---
name: debug-production
description: Debug Rails production incidents using local Rails investigation first and narrow read-only production queries when needed. Use when diagnosing production errors, incidents, unexpected Rails behavior, or CloudWatch logs.
compatibility: Requires a Ruby on Rails repository; production log access requires an authenticated AWS CLI.
---

# Debug a Rails production issue

Use the local repository and local Rails environment first. Treat every AWS
account, CloudWatch log, remote shell, production console, production database,
admin panel, and production secret as production access.

## Safety boundary

Treat a request to inspect or debug a production incident as approval for the
read-only access needed during that investigation. This approval covers later
read-only scope expansions for the same incident. Do not request confirmation
for read-only commands.

Before the first read-only production command:

1. State why local evidence is insufficient.
2. Name the production system to be accessed.
3. State the profile, region, data, and time range when applicable.
4. State that the access is read-only.

Ask for explicit confirmation immediately before each production mutation.
Show the exact command and describe its effect. Never infer approval for a
mutation from approval for read-only access.

## Workflow

### 1. Investigate locally

- Read the relevant code, tests, configuration, and recent changes.
- Reproduce the behavior with local data where possible.
- Prefer a focused command or test over opening an interactive console.
- When interactive inspection is useful, use the local Rails console:

  ```bash
  bin/rails console --sandbox
  ```

  Sandbox mode rolls back database transactions on exit, but it does not undo
  filesystem changes, network requests, emails, jobs, or other external side
  effects. Avoid those side effects.
- Never set `RAILS_ENV=production` or connect a local console to production.
  Use a narrow remote command instead.

### 2. Form a hypothesis

Summarize:

- The observed symptom.
- The likely code path.
- What local evidence supports or contradicts the hypothesis.
- The smallest production evidence needed to resolve the uncertainty.

### 3. Read production evidence

Proceed without another confirmation when the investigation needs read-only
production evidence. Prefer the narrowest CloudWatch query that can answer the
question.

Examples to adapt only after discovering the repository's documented AWS
profile, region, and log group:

```bash
aws sts get-caller-identity --profile <production-profile>
aws logs tail <log-group> --profile <production-profile> --region <region> --since <duration> --format short
aws logs filter-log-events --log-group-name <log-group> --profile <production-profile> --region <region> --start-time <epoch-ms> --filter-pattern <pattern>
```

Never guess an AWS profile, region, account, or log group. Start with a bounded
time window and a narrow filter. Avoid `--follow` unless the user asks for live
monitoring.

### 4. Analyze safely

- Keep production access read-only unless the user confirms a precisely
  described mutation.
- Do not copy secrets, tokens, full customer records, or unnecessary personal
  data into the conversation or Basic Memory.
- Redact sensitive values in summaries.
- Expand read-only scope only when the current evidence is insufficient.
- Prefer a local reproduction and tested code fix over experimentation in
  production.

### 5. Record durable findings

After resolving the incident, recommend **"update memory"** when the root cause,
failed approaches, or operational details would be useful in a future session.
