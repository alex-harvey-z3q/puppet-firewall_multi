const {
  createOpenAIResponse,
  ensureOpenAIKey,
  extractOutputText,
  loadModel,
  truncate,
  upsertIssueComment
} = require("./ai-common");

module.exports = async ({github, context, core}) => {
  if (!ensureOpenAIKey(core)) {
    return;
  }

  const model = loadModel();
  const {owner, repo} = context.repo;
  const pullRequest = context.payload.pull_request;

  const diffResponse = await github.request("GET /repos/{owner}/{repo}/pulls/{pull_number}", {
    owner,
    repo,
    pull_number: pullRequest.number,
    headers: {
      accept: "application/vnd.github.v3.diff"
    }
  });
  const diff = truncate(diffResponse.data, 60000);

  const response = await createOpenAIResponse({
    model,
    maxOutputTokens: 1200,
    input: [
      {
        role: "system",
        content: [
          "You summarize pull requests for maintainers.",
          "Be concise, concrete, and cautious.",
          "Use only the supplied title, branch names, and diff.",
          "Do not invent test results or reviewer findings."
        ].join(" ")
      },
      {
        role: "user",
        content: [
          "Summarize this pull request for a Puppet module maintainer.",
          "",
          `Title: ${pullRequest.title}`,
          `Base branch: ${pullRequest.base.ref}`,
          `Head branch: ${pullRequest.head.ref}`,
          "",
          "Keep the whole response under 140 words. Use flat bullets only and complete every sentence.",
          "Write Markdown with these sections:",
          "Summary: 2-3 bullets describing the change.",
          "Maintainer Notes: 1-3 bullets mentioning risk areas, generated files, CI/test implications, or dependency changes when visible.",
          "Suggested Checks: 1-3 concise bullets with relevant commands or checks; say when this cannot be inferred.",
          "",
          `Diff, possibly truncated to the first 60000 bytes:\n${diff}`
        ].join("\n")
      }
    ]
  });
  const summary = extractOutputText(response);
  const marker = "<!-- ai-pr-summary -->";
  const body = `${marker}
## AI PR Summary

${summary}

_Generated from the PR diff. Treat as advisory, not as a substitute for review or CI._`;

  await upsertIssueComment({
    github,
    context,
    issueNumber: pullRequest.number,
    marker,
    body
  });
};
