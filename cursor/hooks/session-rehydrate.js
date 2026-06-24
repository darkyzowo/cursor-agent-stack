#!/usr/bin/env node
// session-rehydrate.js — sessionStart: inject session memory brief + checkpoint

const { readHookInput, buildSessionStartContext, emitJson } = require('./checkpoint-lib');

const input = readHookInput();
const { context } = buildSessionStartContext(input, 'sessionStart');

emitJson({ additional_context: context });
process.exit(0);
