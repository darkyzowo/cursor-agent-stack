# Project template

Copy or run installers from here into **individual repos**. Nothing in this folder is loaded globally.

## Web app (frontend module)

```powershell
# From your Next/React/Vue repo root
& "C:\path\to\cursor-agent-stack\project-template\install-frontend.ps1"
```

```bash
chmod +x ./install-frontend.sh && ./install-frontend.sh
```

Then: **`/impeccable init`** → customize **`design-refs/README.md`**.

Full docs: [docs/FRONTEND.md](../docs/FRONTEND.md)

## Domain skills only

```powershell
& ".\install-project-skills.ps1"   # run from this folder, target = current directory
```

Or copy into a repo:

| Skill | Use when |
|-------|----------|
| `security-audit` | Auth, APIs, admin, user data |
| `playwright` | E2E browser tests |
| `ui-ux-pro-max` | Palette/stack/UX lookup |

## Session folder

```powershell
mkdir .cursor\session -Force
Copy-Item project-template\.cursor\session\.gitignore .cursor\session\
```

Checkpoint **hooks** are global (`~/.cursor/hooks.json`). Session **files** are per-repo.

## Included files

```
project-template/
├── install-frontend.ps1 / .sh      # Full stack
├── install-project-skills.ps1 / .sh
├── .cursor/
│   ├── rules/frontend-design-lane.mdc
│   ├── design-refs/README.md
│   ├── hooks.impeccable.json       # Reference only — impeccable install writes hooks.json
│   ├── session/.gitignore
│   └── skills/                     # security-audit, playwright, ui-ux-pro-max
└── .impeccable/
    ├── config.json
    └── live/config.next-app-router.json
```

Impeccable itself is installed via **`npx impeccable install`** (not vendored in cursor-agent-stack).
