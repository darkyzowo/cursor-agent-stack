#!/usr/bin/env node
// post-compact-rehydrate.js — sessionStart|compact: re-inject after /summarize

const { readHookInput, buildSessionStartContext, emitJson } = require('./checkpoint-lib');

const input = readHookInput();
const { context } = buildSessionStartContext(input, 'sessionStart|compact');

emitJson({ additional_context: context });
process.exit(0);
