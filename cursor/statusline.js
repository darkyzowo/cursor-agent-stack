#!/usr/bin/env node
// statusline.js — Cursor CLI HUD (context, model, git, caveman — no Machina workflow)

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');
const os = require('os');

const RESET = '\x1b[0m';
const DIM = '\x1b[2m';
const RED = '\x1b[31m';
const GREEN = '\x1b[32m';
const YELLOW = '\x1b[33m';
const MAGENTA = '\x1b[35m';
const CYAN = '\x1b[36m';
const ORANGE = '\x1b[38;5;208m';

function c(color, text) {
  return `${color}${text}${RESET}`;
}

function readStdin() {
  return new Promise((resolve) => {
    if (process.stdin.isTTY) return resolve({});
    let raw = '';
    let settled = false;

    const finish = (value) => {
      if (settled) return;
      settled = true;
      process.stdin.pause();
      resolve(value ?? {});
    };

    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => {
      raw += chunk;
      try {
        finish(JSON.parse(raw.trim()));
      } catch (_) {}
    });
    process.stdin.on('end', () => {
      try {
        finish(raw.trim() ? JSON.parse(raw.trim()) : {});
      } catch (_) {
        finish({});
      }
    });
    process.stdin.on('error', () => finish({}));
    process.stdin.resume();
  });
}

function contextPercent(payload) {
  const cw = payload.context_window || {};
  if (typeof cw.used_percentage === 'number' && cw.used_percentage > 0) {
    return Math.min(100, Math.max(0, Math.round(cw.used_percentage)));
  }
  const size = cw.context_window_size;
  const input = cw.total_input_tokens || 0;
  if (size && size > 0 && input > 0) {
    return Math.min(100, Math.round((input / size) * 100));
  }
  return 0;
}

function contextColor(pct) {
  if (pct >= 85) return RED;
  if (pct >= 70) return ORANGE;
  if (pct >= 50) return YELLOW;
  return GREEN;
}

function bar(pct, width) {
  const w = Math.max(1, width);
  const filled = Math.round((Math.min(100, Math.max(0, pct)) / 100) * w);
  const color = contextColor(pct);
  return `${color}${'█'.repeat(filled)}${DIM}${'░'.repeat(w - filled)}${RESET}`;
}

function formatTokens(n) {
  if (!n || n <= 0) return '';
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M';
  if (n >= 1000) return (n / 1000).toFixed(n >= 10000 ? 0 : 1) + 'k';
  return String(n);
}

function shortModel(payload) {
  const name = payload.model?.display_name || payload.model?.display_name_short || payload.model?.id || '';
  return name.replace(/\s*\([^)]*\)/g, '').trim();
}

function gitInfo(repoDir) {
  if (!repoDir) return { branch: '', dirty: false };
  const branch = spawnSync(
    'git',
    ['-C', repoDir, '--no-optional-locks', 'symbolic-ref', '--short', 'HEAD'],
    { encoding: 'utf8', timeout: 600 }
  );
  let name = branch.status === 0 ? (branch.stdout || '').trim() : '';
  if (!name) {
    const head = spawnSync('git', ['-C', repoDir, '--no-optional-locks', 'rev-parse', '--short', 'HEAD'], {
      encoding: 'utf8',
      timeout: 600,
    });
    name = head.status === 0 ? (head.stdout || '').trim() : '';
  }
  const status = spawnSync('git', ['-C', repoDir, '--no-optional-locks', 'status', '--porcelain'], {
    encoding: 'utf8',
    timeout: 600,
  });
  const dirty = status.status === 0 && Boolean((status.stdout || '').trim());
  return { branch: name, dirty };
}

function cavemanBadge() {
  const flag = path.join(os.homedir(), '.cursor', '.caveman-active');
  let mode = 'ultra';
  try {
    if (fs.existsSync(flag)) mode = fs.readFileSync(flag, 'utf8').trim() || 'ultra';
  } catch (_) {}
  return c(MAGENTA, `[CAV:${mode.toUpperCase()}]`);
}

function machinaHint(cwd) {
  let dir = path.resolve(cwd || process.cwd());
  for (let i = 0; i < 20; i++) {
    const machina = path.join(dir, '.machina');
    if (fs.existsSync(machina)) {
      let rigor = 'ship';
      try {
        rigor = fs.readFileSync(path.join(machina, 'rigor'), 'utf8').trim() || 'ship';
      } catch (_) {}
      return c(DIM, `machina:${rigor}`);
    }
    const parent = path.dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }
  return '';
}

async function main() {
  const payload = await readStdin();
  const cwd = payload.workspace?.current_dir || payload.cwd || process.cwd();
  const projectName = path.basename(cwd) || 'project';
  const pct = contextPercent(payload);
  const cw = payload.context_window || {};
  const model = shortModel(payload);
  const { branch, dirty } = gitInfo(cwd);
  const parts = [];

  parts.push(cavemanBadge());

  if (model || payload.context_window) {
    const ctxParts = [];
    if (model) ctxParts.push(c(CYAN, model));
    ctxParts.push(bar(pct, 12));
    ctxParts.push(`${contextColor(pct)}${pct}%${RESET}`);
    const tok = cw.total_input_tokens;
    const size = cw.context_window_size;
    if (tok && size) ctxParts.push(c(DIM, `${formatTokens(tok)}/${formatTokens(size)}`));
    if (pct >= 50) ctxParts.push(c(YELLOW, '↻ compact'));
    parts.push(ctxParts.join(' '));
  }

  const loc = [c(YELLOW, projectName)];
  if (branch) loc.push(`${c(MAGENTA, 'git:(')}${c(CYAN, branch + (dirty ? '*' : ''))}${c(MAGENTA, ')')}`);
  const wt = payload.worktree?.name;
  if (wt) loc.push(c(DIM, `wt:${wt}`));
  parts.push(loc.join(' '));

  const machina = machinaHint(cwd);
  if (machina) parts.push(machina);

  process.stdout.write(parts.filter(Boolean).join(` ${c(DIM, '|')} `));
}

main().catch(() => process.stdout.write(c(CYAN, 'cursor')));
