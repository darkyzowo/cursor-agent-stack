#!/usr/bin/env node
// session-checkpoint-update.js — postToolUse: maintain .cursor/session/checkpoint.md

const { readHookInput, updateFromToolUse } = require('./checkpoint-lib');

const input = readHookInput();
updateFromToolUse(input);
process.exit(0);
