# Cursor Starter Loop

> A comprehensive starter kit for AI-assisted development with Cursor.
> Version 3.0

---

## What Is This?

The Cursor Starter Loop is a collection of guidelines, templates, skills, and tools that help AI agents (and humans) work effectively on projects. It provides:

- **Core Principles**: The 10 Commandments and Guardrails for safe agent behavior
- **Smart Entry Point**: AGENT.md with context-based routing
- **Reusable Skills**: Interactive workflows for common tasks
- **Project Templates**: Documentation and configuration templates
- **Stack-Specific Rules**: Pre-configured rules for Python, Node, Next.js, Laravel
- **Shell Tools**: Scripts for initialization, validation, and health checks

---

## Quick Start

### For a New Project

```bash
# Run the initialization script
~/Cursor/cursor-starter-loop/tools/init.sh my-project python

# Or for interactive mode
~/Cursor/cursor-starter-loop/tools/init.sh
```

### For an Existing Project

Drop AGENT.md into your project:

```bash
cp ~/Cursor/cursor-starter-loop/AGENT.md ./
```

Or add the starter loop to your Cursor context by referencing it:
```
@~/Cursor/cursor-starter-loop/AGENT.md
```

---

## Directory Structure

```
cursor-starter-loop/
├── AGENT.md                    # Smart entry point for AI agents
├── README.md                   # This file
│
├── core/                       # Essential principles
│   ├── COMMANDMENTS.md         # The 10 Commandments
│   ├── GUARDRAILS.md           # Stop and ask rules
│   └── CREDENTIALS.md          # Credential management guide
│
├── guides/                     # Detailed reference guides
│   ├── git.md                  # Git workflow and conventions
│   ├── docs.md                 # Documentation standards
│   ├── tasks.md                # Task management
│   └── code-quality.md         # Code quality and testing
│
├── skills/                     # Cursor Agent Skills
│   ├── project-init/           # Interactive project setup
│   ├── validate/               # Project validation
│   ├── pre-commit/             # Pre-commit checks
│   ├── tech-debt/              # Technical debt finder
│   └── sync-credentials/       # Credential verification
│
├── templates/                  # Project templates
│   ├── project/                # Core documentation templates
│   ├── stacks/                 # Stack-specific rules
│   │   ├── python/
│   │   ├── node/
│   │   ├── nextjs/
│   │   └── laravel/
│   ├── ci/                     # CI/CD templates
│   └── devcontainer/           # Dev container config
│
└── tools/                      # Shell scripts
    ├── init.sh                 # Project initialization
    ├── validate.sh             # Project validation
    └── health-check.sh         # System health check
```

---

## The 10 Commandments

1. **Read before writing** — Understand existing code and docs first
2. **Small commits, often** — One logical change per commit
3. **Document the "why"** — Comments explain reasoning, not code
4. **Test your changes** — Run tests before committing
5. **Ask before breaking changes** — Stop for approval on architecture, auth, DB, CI
6. **Use conventional commits** — `feat:`, `fix:`, `docs:`, etc.
7. **Keep secrets out of git** — Use `.env`, verify `.gitignore`
8. **Update docs with code** — Keep them in sync
9. **Progress over perfection** — Ship, then iterate
10. **Communicate blockers early** — Don't spin; ask for help

---

## Guardrails (Stop and Ask Before)

- Deleting files or directories
- Changing authentication/authorization logic
- Modifying database schemas
- Altering CI/CD pipelines
- Refactoring core architecture
- Any irreversible operation

---

## Using Skills

Skills are reusable workflows. Reference them in Cursor:

### Project Initialization
```
@~/Cursor/cursor-starter-loop/skills/project-init/SKILL.md
Set up this new project
```

### Validation
```
@~/Cursor/cursor-starter-loop/skills/validate/SKILL.md
Check if this project follows conventions
```

### Pre-Commit Checks
```
@~/Cursor/cursor-starter-loop/skills/pre-commit/SKILL.md
Run pre-commit checks
```

### Find Technical Debt
```
@~/Cursor/cursor-starter-loop/skills/tech-debt/SKILL.md
Find technical debt in this codebase
```

### Verify Credentials
```
@~/Cursor/cursor-starter-loop/skills/sync-credentials/SKILL.md
Check if my credentials are working
```

---

## Shell Tools

### Initialize a New Project

```bash
# Interactive mode
./tools/init.sh

# With arguments
./tools/init.sh my-project python
./tools/init.sh my-app node
./tools/init.sh my-site nextjs
```

### Validate a Project

```bash
# Current directory
./tools/validate.sh

# Specific path
./tools/validate.sh ~/projects/my-app
```

### Health Check

```bash
# Check system setup (1Password, Git, credentials)
./tools/health-check.sh
```

---

## Credential Management

All credentials are managed through 1Password and documented in:

```
~/.cursor/credentials/UNIVERSAL_ACCESS.md
```

### Quick Reference

```bash
# Sign in to 1Password
eval $(op signin)

# Get a credential
op item get "Item Name" --vault Cursor --fields credential --reveal

# Common items
op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password"
op item get "DigitalOcean API Token" --vault Cursor --fields credential
```

---

## Project Templates

### Core Documentation

Copy templates to your project:

```bash
cp ~/Cursor/cursor-starter-loop/templates/project/*.template docs/
# Rename .template files and fill in
```

Available templates:
- `PROJECT.md.template` — Project overview
- `ARCHITECTURE.md.template` — System design
- `SETUP.md.template` — Environment setup
- `DECISIONS.md.template` — Architecture decision records
- `CHANGELOG.md.template` — Version history
- `README.md.template` — Quick start
- `.gitignore.template` — Git ignore patterns

### Stack-Specific Rules

Copy rules for your stack:

```bash
mkdir -p .cursor/rules
cp ~/Cursor/cursor-starter-loop/templates/stacks/python/*.md .cursor/rules/
```

Available stacks:
- `python/` — Python/FastAPI/Django
- `node/` — Node.js/TypeScript
- `nextjs/` — Next.js App Router
- `laravel/` — PHP Laravel
- `swift/` — Swift/macOS/Xcode

### CI/CD Templates

```bash
# GitHub Actions
mkdir -p .github/workflows
cp ~/Cursor/cursor-starter-loop/templates/ci/github-actions.yml .github/workflows/ci.yml

# Docker Compose
cp ~/Cursor/cursor-starter-loop/templates/ci/docker-compose.yml ./
```

### Dev Containers

```bash
mkdir -p .devcontainer
cp ~/Cursor/cursor-starter-loop/templates/devcontainer/devcontainer.json .devcontainer/
```

---

## Self-Improvement Loop

The most powerful pattern: make the AI improve its own rules.

### After Every Correction

When the user corrects you, end with:
> "I'll update .cursor/rules/ so I don't make that mistake again."

### After Every PR

Update `docs/notes/YYYY-MM-DD-topic.md` with:
- What was learned
- Edge cases discovered
- Patterns that worked

### Weekly

Review `.cursor/rules/`:
- Remove rules that aren't triggered
- Strengthen rules that keep breaking
- Consolidate duplicates

---

## Recommended Cursor Setup

### Project Rules

Use the `.cursor/rules/` folder pattern for multiple rule files:

```
.cursor/rules/
├── core.md           # Project-wide rules
├── api.md            # API development rules
├── frontend.md       # Frontend rules
└── testing.md        # Testing rules
```

### Context References

- `@file.ts` — Reference a specific file
- `@folder/` — Reference a folder
- `@docs` — Reference documentation
- `@AGENT.md` — Reference the starter loop

---

## Migration from v2

If you're using the previous `00_Project_Starter_Kit`:

1. The content has been reorganized but principles remain the same
2. `START.md` is now `AGENT.md` with better routing
3. Cursor rules are now in `templates/stacks/` instead of `cursor-rules/`
4. Skills are a new addition for interactive workflows

To migrate:
```bash
# Just reference the new location
@~/Cursor/cursor-starter-loop/AGENT.md
```

---

## Contributing

To improve the Starter Loop:

1. Identify a pattern that would help future projects
2. Add it to the appropriate file
3. Update this README if needed
4. Test with a real project

---

## Files Reference

| File | Purpose |
|------|---------|
| `AGENT.md` | Smart entry point for AI agents |
| `core/COMMANDMENTS.md` | The 10 Commandments |
| `core/GUARDRAILS.md` | Stop and ask rules |
| `core/CREDENTIALS.md` | Credential management |
| `guides/git.md` | Git workflow guide |
| `guides/docs.md` | Documentation standards |
| `guides/tasks.md` | Task management |
| `guides/code-quality.md` | Code quality guide |
| `tools/init.sh` | Project initialization |
| `tools/validate.sh` | Project validation |
| `tools/health-check.sh` | System health check |

---

## License

Internal use only.

---

*Cursor Starter Loop v3.0 | Last Updated: 2026-02-01*
