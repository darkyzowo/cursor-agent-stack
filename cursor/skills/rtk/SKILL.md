---
name: rtk
description: >-
  RTK (Rust Token Killer) — token-optimized terminal command wrappers.
  Use when running git, vitest, tsc, lint, docker, gh, or other noisy CLI commands.
  Prefix commands with rtk for 60-90% output compression.
---

# RTK — Token-Optimized Commands

## Golden Rule

**Always prefix commands with `rtk`**. If RTK has a dedicated filter, it uses it. If not, it passes through unchanged.

In command chains with `&&`, use `rtk` on each part:

```bash
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## Build & Compile

```bash
rtk cargo build
rtk cargo check
rtk cargo clippy
rtk tsc
rtk lint
rtk prettier --check
rtk next build
```

## Test

```bash
rtk cargo test
rtk vitest run
rtk playwright test
rtk test <cmd>
```

## Git

```bash
rtk git status
rtk git log
rtk git diff
rtk git show
rtk git add
rtk git commit
rtk git push
rtk git pull
rtk git branch
rtk git fetch
rtk git stash
rtk git worktree
```

Git passthrough works for ALL subcommands.

## GitHub

```bash
rtk gh pr view <num>
rtk gh pr checks
rtk gh run list
rtk gh issue list
rtk gh api
```

## JS/TS Tooling

```bash
rtk pnpm list
rtk pnpm outdated
rtk pnpm install
rtk npm run <script>
rtk npx <cmd>
rtk prisma
```

## Files & Search

```bash
rtk ls <path>
rtk read <file>
rtk grep <pattern>
rtk find <pattern>
```

## Analysis & Debug

```bash
rtk err <cmd>
rtk log <file>
rtk json <file>
rtk deps
rtk env
rtk summary <cmd>
rtk diff
```

## Infrastructure

```bash
rtk docker ps
rtk docker images
rtk docker logs <c>
rtk kubectl get
rtk kubectl logs
```

## Network

```bash
rtk curl <url>
rtk wget <url>
```

## Meta

```bash
rtk gain
rtk gain --history
rtk discover
rtk proxy <cmd>
```

## Large outputs RTK does not cover

Summarize, grep for errors, or read targeted file slices. Do not dump full build logs or search results into chat.
