# Architecture

## Design principles

1. **Global = pleasant default** — no pass ceilings, no phase gates on every chat
2. **Mechanical > prose** — hooks write files; rules tell agent how to use them
3. **One checkpoint per workspace root** — home and each repo are isolated
4. **Archives on compact only** — not every edit (avoids disk noise)

## Hook pipeline

```
sessionStart
  └─ session-rehydrate.js
       └─ buildSessionStartContext()
            ├─ buildSessionMemoryBrief()  ← paths, playbook, recent archive index
            └─ readForInjection(checkpoint.md)

sessionStart (matcher: compact)
  └─ post-compact-rehydrate.js  ← same as above after /summarize

preCompact  (/summarize)
  └─ pre-compact-flush.js
       └─ finalizeCompact()
            ├─ write checkpoint.md
            ├─ archiveCheckpoint() → archive/checkpoint-<ts>.md
            └─ pruneArchives() → max 10, max 7 days

postToolUse (Write|StrReplace)
  └─ session-checkpoint-update.js
       └─ updateFromToolUse() → merge files + goal scrape

preToolUse (Write|StrReplace)
  └─ secret-guard.js → block secret patterns in write content
```

## Workspace root resolution

`checkpoint-lib.js` uses `workspace_roots[0]` from the hook payload, then walks up for `.git` or `.cursor` to find the session directory.

## Rules vs hooks

| Mechanism | When loaded | Purpose |
|-----------|-------------|---------|
| Rules (`.mdc`) | Every Agent turn | Ambient knowledge — paths, behavior, forensics playbook |
| Hooks | Events | Write files, inject context on sessionStart/preCompact |

Rules alone fail under context pressure; hooks alone don't teach forensics phrasing. Both together.

## Cursor native `/summarize` vs this stack

Cursor replaces chat history with a **large narrative summary** + transcript pointer. This stack adds **structured** checkpoint + **archived snapshots** the agent can grep without you re-explaining paths.

## Extension points

- **Goal extraction** — `pickGoalMessage()` in `checkpoint-lib.js`; tune transcript parsing
- **Archive retention** — `MAX_ARCHIVES`, `MAX_ARCHIVE_AGE_DAYS` constants
- **End session skill** — optional future: user-triggered handoff file
- **Project skills** — copy domain skills into `<repo>/.cursor/skills/` only when needed

## Frontend module (project-local)

Separate from session memory. See [FRONTEND.md](FRONTEND.md).

```
Global ~/.cursor/
  frontend-design-pointer.mdc   ← "use Impeccable if installed"
  hooks.json                      ← checkpoint + secret-guard ONLY

Project <repo>/.cursor/
  hooks.json                      ← Impeccable design detector ONLY
  skills/impeccable/              ← npx impeccable install
  skills/ui-ux-pro-max/
  rules/frontend-design-lane.mdc
  design-refs/README.md

Project root
  PRODUCT.md, DESIGN.md           ← /impeccable init
  .impeccable/config.json
```

Hook stacking: Cursor runs global + project hooks. Checkpoint hooks must not be duplicated in project `hooks.json`.

### 3D module (project-local)

See [3D.md](3D.md). Same hook-stacking rules as frontend — no checkpoint hooks in project `hooks.json`.

```
Project <repo>/.cursor/
  skills/r3f-three/
  rules/3d-interactive-lane.mdc
  design-refs/3d.md

Project root
  scenes/ProofScene.tsx   (optional template from install-3d)
```

Global `3d-interactive-pointer.mdc` tells the agent to use r3f-three when installed.
