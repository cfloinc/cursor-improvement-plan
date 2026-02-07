# Cursor Improvement Plan

> A drop-in toolkit for upgrading any existing project with AI-assisted development best practices.
> Version 4.0

---

## What Is This?

The Cursor Improvement Plan is a collection of guidelines, templates, skills, and tools that improve existing projects. Drop `IMPROVEMENT.md` into any project and the agent will audit what's there, then automatically add everything that's missing -- non-destructively.

It provides:

- **Drop-In Upgrade**: `IMPROVEMENT.md` audits and improves any existing project
- **Core Principles**: The 10 Commandments and Guardrails for safe agent behavior
- **Smart Entry Point**: `AGENT.md` with context-based routing
- **Agent Learning**: `SCRATCHPAD.md` template for session-over-session improvement
- **Reusable Skills**: Interactive workflows for common tasks
- **Project Templates**: Documentation and configuration templates
- **Stack-Specific Rules**: Pre-configured rules for Python, Node, Next.js, Laravel, Swift
- **Shell Tools**: Scripts for project improvement, validation, and health checks

---

## Quick Start

### Improve an Existing Project

**Option 1: Drop in IMPROVEMENT.md** (recommended)
```bash
cp ~/Cursor/cursor-improvement-plan/IMPROVEMENT.md ./
# Then tell the agent: "Read IMPROVEMENT.md and improve this project"
```

**Option 2: Reference it in Cursor context**
```
@~/Cursor/cursor-improvement-plan/IMPROVEMENT.md
Improve this project
```

**Option 3: Run the improvement script**
```bash
~/Cursor/cursor-improvement-plan/tools/improve.sh .
```

### What Happens

1. The agent audits your project's current state
2. Detects your tech stack automatically
3. Adds missing documentation, rules, and structure
4. Never overwrites existing files
5. Reports what was added and what to do next

---

## Directory Structure

```
cursor-improvement-plan/
├── IMPROVEMENT.md                # Drop-in project upgrader
├── AGENT.md                      # Smart entry point for AI agents
├── README.md                     # This file
├── SCRATCHPAD.md                 # Agent self-learning log
│
├── core/                         # Essential principles
│   ├── COMMANDMENTS.md           # The 10 Commandments
│   ├── GUARDRAILS.md             # Stop and ask rules
│   └── CREDENTIALS.md            # Credential management guide
│
├── guides/                       # Detailed reference guides
│   ├── git.md                    # Git workflow and conventions
│   ├── docs.md                   # Documentation standards
│   ├── tasks.md                  # Task management
│   └── code-quality.md           # Code quality and testing
│
├── skills/                       # Cursor Agent Skills
│   ├── project-improve/          # Project audit and upgrade
│   ├── validate/                 # Project validation
│   ├── pre-commit/               # Pre-commit checks
│   ├── tech-debt/                # Technical debt finder
│   └── sync-credentials/         # Credential verification
│
├── templates/                    # Project templates
│   ├── project/                  # Core documentation templates
│   ├── stacks/                   # Stack-specific rules
│   │   ├── python/
│   │   ├── node/
│   │   ├── nextjs/
│   │   ├── laravel/
│   │   └── swift/
│   ├── ci/                       # CI/CD templates
│   └── devcontainer/             # Dev container config
│
└── tools/                        # Shell scripts
    ├── improve.sh                # Project improvement
    ├── validate.sh               # Project validation
    └── health-check.sh           # System health check
```

---

## The 10 Commandments

1. **Read before writing** -- Understand existing code and docs first
2. **Small commits, often** -- One logical change per commit
3. **Document the "why"** -- Comments explain reasoning, not code
4. **Test your changes** -- Run tests before committing
5. **Ask before breaking changes** -- Stop for approval on architecture, auth, DB, CI
6. **Use conventional commits** -- `feat:`, `fix:`, `docs:`, etc.
7. **Keep secrets out of git** -- Use `.env`, verify `.gitignore`
8. **Update docs with code** -- Keep them in sync
9. **Progress over perfection** -- Ship, then iterate
10. **Communicate blockers early** -- Don't spin; ask for help

---

## Guardrails (Stop and Ask Before)

- Deleting files or directories
- Changing authentication/authorization logic
- Modifying database schemas
- Altering CI/CD pipelines
- Refactoring core architecture
- Adding dependencies with security implications
- Any irreversible operation
- Force pushing to any branch

---

## Using Skills

Skills are reusable workflows. Reference them in Cursor:

### Project Improvement
```
@~/Cursor/cursor-improvement-plan/skills/project-improve/SKILL.md
Improve this project
```

### Validation
```
@~/Cursor/cursor-improvement-plan/skills/validate/SKILL.md
Check if this project follows conventions
```

### Pre-Commit Checks
```
@~/Cursor/cursor-improvement-plan/skills/pre-commit/SKILL.md
Run pre-commit checks
```

### Find Technical Debt
```
@~/Cursor/cursor-improvement-plan/skills/tech-debt/SKILL.md
Find technical debt in this codebase
```

### Verify Credentials
```
@~/Cursor/cursor-improvement-plan/skills/sync-credentials/SKILL.md
Check if my credentials are working
```

---

## Shell Tools

### Improve a Project

```bash
# Current directory
~/Cursor/cursor-improvement-plan/tools/improve.sh

# Specific path
~/Cursor/cursor-improvement-plan/tools/improve.sh ~/projects/my-app
```

### Validate a Project

```bash
# Current directory
~/Cursor/cursor-improvement-plan/tools/validate.sh

# Specific path
~/Cursor/cursor-improvement-plan/tools/validate.sh ~/projects/my-app
```

### Health Check

```bash
# Check system setup (1Password, Git, credentials)
~/Cursor/cursor-improvement-plan/tools/health-check.sh
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

Templates are automatically copied by the improvement workflow. To copy manually:

```bash
cp ~/Cursor/cursor-improvement-plan/templates/project/*.template docs/
# Rename .template files and fill in
```

Available templates:
- `PROJECT.md.template` -- Project overview
- `ARCHITECTURE.md.template` -- System design
- `SETUP.md.template` -- Environment setup
- `DECISIONS.md.template` -- Architecture decision records
- `CHANGELOG.md.template` -- Version history
- `README.md.template` -- Quick start
- `SCRATCHPAD.md.template` -- Agent self-learning log
- `.gitignore.template` -- Git ignore patterns

### Stack-Specific Rules

Rules are auto-detected and applied by the improvement workflow. To copy manually:

```bash
mkdir -p .cursor/rules
cp ~/Cursor/cursor-improvement-plan/templates/stacks/python/*.md .cursor/rules/
```

Available stacks:
- `python/` -- Python/FastAPI/Django
- `node/` -- Node.js/TypeScript
- `nextjs/` -- Next.js App Router
- `laravel/` -- PHP Laravel
- `swift/` -- Swift/macOS/Xcode

### CI/CD Templates

```bash
# GitHub Actions
mkdir -p .github/workflows
cp ~/Cursor/cursor-improvement-plan/templates/ci/github-actions.yml .github/workflows/ci.yml

# Docker Compose
cp ~/Cursor/cursor-improvement-plan/templates/ci/docker-compose.yml ./
```

### Dev Containers

```bash
mkdir -p .devcontainer
cp ~/Cursor/cursor-improvement-plan/templates/devcontainer/devcontainer.json .devcontainer/
```

---

## Self-Improvement Loop

The most powerful pattern: make the AI improve its own rules.

### After Every Session

Update `SCRATCHPAD.md` with a session log entry covering mistakes, corrections,
what worked, what didn't, and what the user liked. Run the Learning Framework to
update Active Rules.

### After Every Correction

When the user corrects you, end with:
> "I'll update .cursor/rules/ and SCRATCHPAD.md so I don't make that mistake again."

### After Every PR

Update `docs/notes/YYYY-MM-DD-topic.md` with:
- What was learned
- Edge cases discovered
- Patterns that worked

### Weekly

Review `.cursor/rules/` and `SCRATCHPAD.md`:
- Remove rules that aren't triggered
- Strengthen rules that keep breaking
- Consolidate duplicates
- Rotate Active Rules in the scratchpad

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

- `@file.ts` -- Reference a specific file
- `@folder/` -- Reference a folder
- `@docs` -- Reference documentation
- `@AGENT.md` -- Reference the agent guide

---

## Contributing

To improve the Improvement Plan:

1. Identify a pattern that would help existing projects
2. Add it to the appropriate file
3. Update this README if needed
4. Test with a real project

---

## Files Reference

| File | Purpose |
|------|---------|
| `IMPROVEMENT.md` | Drop-in project upgrader |
| `AGENT.md` | Smart entry point for AI agents |
| `templates/project/SCRATCHPAD.md.template` | Agent self-learning log template |
| `core/COMMANDMENTS.md` | The 10 Commandments |
| `core/GUARDRAILS.md` | Stop and ask rules |
| `core/CREDENTIALS.md` | Credential management |
| `guides/git.md` | Git workflow guide |
| `guides/docs.md` | Documentation standards |
| `guides/tasks.md` | Task management |
| `guides/code-quality.md` | Code quality guide |
| `tools/improve.sh` | Project improvement |
| `tools/validate.sh` | Project validation |
| `tools/health-check.sh` | System health check |

---

## License

Internal use only.

---

*Cursor Improvement Plan v4.0 | Last Updated: 2026-02-07*
