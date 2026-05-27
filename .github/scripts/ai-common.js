const fs = require("fs");

const OPENAI_URL = "https://api.openai.com/v1/responses";

function ensureOpenAIKey(core) {
  if (process.env.OPENAI_API_KEY) {
    return true;
  }

  core.info("OPENAI_API_KEY is not set; skipping AI workflow.");
  return false;
}

function loadModel() {
  const config = JSON.parse(fs.readFileSync(".github/openai-model.json", "utf8"));

  if (typeof config.model !== "string" || config.model.length === 0) {
    throw new Error(".github/openai-model.json must contain a non-empty model string.");
  }

  return config.model;
}

async function createOpenAIResponse({model, input, maxOutputTokens}) {
  const response = await fetch(OPENAI_URL, {
    method: "POST",
    headers: {
      authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
      "content-type": "application/json"
    },
    body: JSON.stringify({
      model,
      input,
      max_output_tokens: maxOutputTokens
    })
  });

  if (!response.ok) {
    throw new Error(`OpenAI request failed: ${response.status} ${await response.text()}`);
  }

  return response.json();
}

function extractOutputText(response) {
  const text = response.output_text ??
    (response.output ?? [])
      .flatMap((item) => item.content ?? [])
      .filter((item) => item.type === "output_text" || item.type === "text")
      .map((item) => item.text)
      .join("\n");

  if (typeof text !== "string" || text.trim().length === 0 || text.trim() === "null") {
    throw new Error("OpenAI response did not contain output text.");
  }

  return text.trim();
}

async function upsertIssueComment({github, context, issueNumber, marker, body}) {
  const {owner, repo} = context.repo;
  const comments = await github.rest.issues.listComments({
    owner,
    repo,
    issue_number: issueNumber,
    per_page: 100
  });
  const previous = comments.data.find((comment) =>
    comment.user.type === "Bot" && comment.body.includes(marker)
  );

  if (previous) {
    await github.rest.issues.updateComment({
      owner,
      repo,
      comment_id: previous.id,
      body
    });
  } else {
    await github.rest.issues.createComment({
      owner,
      repo,
      issue_number: issueNumber,
      body
    });
  }
}

function truncate(value, maxLength) {
  return String(value ?? "").slice(0, maxLength);
}

function redactLog(value) {
  return String(value ?? "")
    .replace(/(Bearer )[A-Za-z0-9._~+/=-]+/g, "$1[REDACTED]")
    .replace(/([A-Za-z0-9_]*(TOKEN|SECRET|PASSWORD|KEY)[A-Za-z0-9_]*=)[^\s]+/gi, "$1[REDACTED]");
}

function responseDataToString(data) {
  if (typeof data === "string") {
    return data;
  }

  if (Buffer.isBuffer(data)) {
    return data.toString("utf8");
  }

  if (data instanceof ArrayBuffer) {
    return Buffer.from(data).toString("utf8");
  }

  if (ArrayBuffer.isView(data)) {
    return Buffer.from(data.buffer).toString("utf8");
  }

  return JSON.stringify(data);
}

module.exports = {
  createOpenAIResponse,
  ensureOpenAIKey,
  extractOutputText,
  loadModel,
  redactLog,
  responseDataToString,
  truncate,
  upsertIssueComment
};
