#!/usr/bin/env node
// pre-compact-flush.js — preCompact: finalize checkpoint before context reset

const { readHookInput, finalizeCompact, buildSessionStartContext, emitJson } = require('./checkpoint-lib');

const input = readHookInput();
const { content, compactAt, archiveRel } = finalizeCompact(input);
const { context } = buildSessionStartContext(input, 'preCompact', {
  checkpoint: content,
  compactAt,
  archiveRel,
});

emitJson({
  additional_context:
    `CONTEXT COMPACT — checkpoint archived at ${compactAt}.\n` +
    `Continue from .cursor/session/checkpoint.md unless user asks for older history.\n\n` +
    context,
});

process.exit(0);
