#!/usr/bin/env node
// hook-utils.js — Cursor user-hook I/O helpers

const fs = require('fs');

function readHookInput() {
  if (process.stdin.isTTY) return {};
  try {
    const raw = fs.readFileSync(0, 'utf8').trim();
    return raw ? JSON.parse(raw) : {};
  } catch (_) {
    return {};
  }
}

/** Block preToolUse — exit 2 + JSON deny (Cursor) and stderr (debug channel). */
function block(message) {
  const text = String(message).trim();
  process.stderr.write(text + '\n');
  process.stdout.write(
    JSON.stringify({
      permission: 'deny',
      user_message: text,
      agent_message: text,
    })
  );
  process.exit(2);
}

function extractWriteContent(toolInput) {
  if (!toolInput || typeof toolInput !== 'object') return '';
  const candidates = [
    toolInput.contents,
    toolInput.content,
    toolInput.new_string,
    toolInput.new_str,
    toolInput.newString,
    toolInput.text,
  ];
  for (const value of candidates) {
    if (typeof value === 'string' && value.length > 0) return value;
  }
  return '';
}

module.exports = { readHookInput, block, extractWriteContent };
