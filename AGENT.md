# AGENT START HERE

> **Version**: 3.0 | **Last Updated**: 2026-02-01
>
> Drop this file into any Cursor project to bootstrap agent workflows.
> Smart routing gets you to the right section fast.

---

## Quick Navigation

**What are you trying to do?**

| Task | Go To |
|------|-------|
| Start a new project | [Project Setup](#project-setup) |
| Access credentials/secrets | [Credentials](#credentials) |
| Make code changes | [Development Workflow](#development-workflow) |
| Debug an issue | [Troubleshooting](#troubleshooting) |
| Understand this codebase | [Exploration](#exploration) |
| Run pre-commit checks | [Quality Checks](#quality-checks) |

---

## The 10 Commandments

> Memorize these. They govern all agent behavior.

1. **Read before writing** — Understand existing code and docs first
2. **Small commits, often** — One logical change per commit, push immediately
3. **Document the "why"** — Comments explain reasoning, not obvious behavior
4. **Test your changes** — Run relevant tests before committing
5. **Ask before breaking changes** — Stop for approval on architecture, auth, DB schema, CI/CD
6. **Use conventional commits** — `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
7. **Keep secrets out of git** — Use `.env` files, verify `.gitignore` works
8. **Update docs with code** — If behavior changes, docs change too
9. **Progress over perfection** — Working code now beats perfect code never
10. **Communicate blockers early** — Don't spin; ask for help

**Full details**: [core/COMMANDMENTS.md](core/COMMANDMENTS.md)

---

## Guardrails: Stop and Ask Before

> These actions require explicit user approval. Never proceed autonomously.

- Deleting files or directories
- Changing authentication/authorization logic
- Modifying database schemas
- Altering CI/CD pipelines
- Refactoring core architecture
- Adding dependencies with security implications
- Any irreversible operation
- Force pushing to any branch

**Full details**: [core/GUARDRAILS.md](core/GUARDRAILS.md)

---

## Credentials

> **CRITICAL**: When you need ANY external service access, read this FIRST.

**Canonical credentials file**:
```
~/.cursor/credentials/UNIVERSAL_ACCESS.md
```

This file contains:
- All service URLs and endpoints
- 1Password item names for secrets
- Verification commands
- Server IP addresses

### Quick Access Pattern

```bash
# 1. Find the service in UNIVERSAL_ACCESS.md
grep -A 20 "ServiceName" ~/.cursor/credentials/UNIVERSAL_ACCESS.md

# 2. Retrieve the credential
op item get "Item Name" --vault Cursor --fields credential --reveal

# 3. Use it (never hardcode, never commit)
```

### 1Password CLI

```bash
# Authenticate if needed
eval $(op signin)

# Verify access
op vault list

# Common credentials
op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password" --reveal
op item get "DigitalOcean API Token" --vault Cursor --fields credential --reveal
```

**Full details**: [core/CREDENTIALS.md](core/CREDENTIALS.md)

---

## Project Setup

### New Project (Empty Directory)

Use the interactive skill:
```
@project-init
```

Or manually:
```bash
# Run the init script
~/Cursor/cursor-starter-loop/tools/init.sh [project-name] [stack]

# Available stacks: generic, python, node, nextjs, laravel
```

### Existing Project (Add Starter Loop)

1. Check for existing documentation:
   ```bash
   ls docs/ README.md .env.example .cursorrules 2>/dev/null
   ```

2. If missing docs, create structure:
   ```bash
   mkdir -p docs/tasks docs/notes
   ```

3. Copy relevant templates:
   ```bash
   cp ~/Cursor/cursor-starter-loop/templates/project/*.template docs/
   # Rename .template files and fill in
   ```

4. Set up project rules:
   ```bash
   mkdir -p .cursor/rules
   cp ~/Cursor/cursor-starter-loop/templates/stacks/[your-stack]/*.md .cursor/rules/
   ```

---

## Development Workflow

### Before Making Changes

1. **Read the relevant code** — Never edit blind
2. **Check for existing patterns** — Follow established conventions
3. **Understand the test situation** — Know what tests exist

### Making Changes

1. Create focused, small changes
2. Run linter and tests
3. Commit with conventional message:
   ```bash
   git add <files>
   git commit -m "feat(scope): description"
   git push
   ```

### After Changes

1. If you made a mistake the user corrected:
   ```
   → Update .cursor/rules/ so you don't repeat it
   ```

2. If you learned something project-specific:
   ```
   → Add to docs/notes/YYYY-MM-DD-topic.md
   ```

3. If behavior changed:
   ```
   → Update relevant documentation
   ```

---

## Quality Checks

### Pre-Commit Checklist

Run before every commit:

- [ ] Code does what it should
- [ ] No secrets in staged files
- [ ] Tests pass
- [ ] Linter passes
- [ ] Documentation updated if needed

### Validation

```bash
# Validate project follows conventions
~/Cursor/cursor-starter-loop/tools/validate.sh .

# Health check (credentials, git access)
~/Cursor/cursor-starter-loop/tools/health-check.sh
```

---

## Exploration

### Understanding a New Codebase

1. **Start with docs**:
   ```bash
   cat docs/PROJECT.md 2>/dev/null || cat README.md
   cat docs/ARCHITECTURE.md 2>/dev/null
   ```

2. **Check project structure**:
   ```bash
   ls -la
   find . -name "*.md" -not -path "./node_modules/*" | head -20
   ```

3. **Find entry points**:
   ```bash
   # Look for main files
   ls src/main.* src/index.* app/main.* 2>/dev/null
   # Check package.json or equivalent
   cat package.json 2>/dev/null | grep -A5 '"scripts"'
   ```

4. **Check for project rules**:
   ```bash
   cat .cursorrules 2>/dev/null
   ls .cursor/rules/ 2>/dev/null
   ```

---

## Troubleshooting

### Common Issues

| Problem | Solution |
|---------|----------|
| `op` command fails | `eval $(op signin)` or install: `brew install --cask 1password-cli` |
| Git permission denied | Use HTTPS with App Password instead of SSH |
| Can't find credentials | Read `~/.cursor/credentials/UNIVERSAL_ACCESS.md` |
| Tests failing | Check recent commits, run single test to isolate |
| Linter errors | Run auto-fix: `npm run lint:fix` or `ruff check . --fix` |

### Debug Process

1. **Reproduce** — Run the failing command/test
2. **Isolate** — Find smallest code that triggers issue
3. **Trace** — Add logging to understand flow
4. **Compare** — What's different between working and broken?
5. **Root cause** — Fix the actual problem, not symptoms

---

## Git Quick Reference

### Clone Repositories

**Bitbucket (HTTPS — preferred for agents)**:
```bash
git clone https://cfloinc:$(op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password")@bitbucket.org/cfloinc/<repo>.git
```

**GitHub (SSH)**:
```bash
git clone git@github.com:cfloinc/<repo>.git
```

### Commit Types

| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `refactor` | Code restructure |
| `test` | Tests |
| `chore` | Maintenance |

### Worktrees (Parallel Sessions)

```bash
# Create isolated worktree for a task
git worktree add ../project-feature -b feature/name

# List worktrees
git worktree list

# Remove when done
git worktree remove ../project-feature
```

---

## Self-Improvement Loop

> The most powerful pattern: make the AI improve its own rules.

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

## File Reference

| Location | Purpose |
|----------|---------|
| `~/.cursor/credentials/UNIVERSAL_ACCESS.md` | All service credentials |
| `~/Cursor/cursor-starter-loop/` | This starter kit |
| `~/Cursor/cursor-starter-loop/core/` | Core principles |
| `~/Cursor/cursor-starter-loop/guides/` | Detailed guides |
| `~/Cursor/cursor-starter-loop/templates/` | Project templates |
| `~/Cursor/cursor-starter-loop/skills/` | Agent skills |
| `~/Cursor/cursor-starter-loop/tools/` | Shell scripts |

---

## Remember

**DO**:
- Read `UNIVERSAL_ACCESS.md` immediately for any external service
- Use 1Password CLI for secrets
- Follow the 10 Commandments
- Update rules when you learn from mistakes

**DON'T**:
- Ask the user for credentials (they're in UNIVERSAL_ACCESS.md)
- Commit secrets to git
- Make breaking changes without asking
- Guess at API endpoints or connection details

---

*Starter Loop v3.0 | See [README.md](README.md) for full documentation*
