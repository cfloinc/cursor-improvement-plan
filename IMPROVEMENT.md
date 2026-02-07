# IMPROVE THIS PROJECT

> **Drop this file into any existing Cursor project.** The agent will read it,
> audit what's there, and automatically add everything that's missing.

---

## Agent: Do This Now

When you read this file in a project, **immediately run this improvement workflow**.
Never overwrite existing files -- only add what's missing.

### 1. Audit Current State

```bash
# Check what already exists
ls -la
ls docs/ 2>/dev/null
ls .cursor/rules/ 2>/dev/null
ls tests/ 2>/dev/null
ls src/ 2>/dev/null
cat .gitignore 2>/dev/null | head -20
ls .env.example 2>/dev/null
ls SCRATCHPAD.md 2>/dev/null
ls AGENT.md 2>/dev/null
```

Record what exists and what's missing. Keep a running tally.

### 2. Detect Tech Stack

Auto-detect from existing files -- do not ask the user:

| File Found | Stack |
|------------|-------|
| `package.json` with `"next"` dependency | nextjs |
| `package.json` (without Next) | node |
| `requirements.txt` or `pyproject.toml` or `setup.py` | python |
| `composer.json` | laravel |
| `Package.swift` or `*.xcodeproj` | swift |
| None of the above | generic |

```bash
# Detect stack
if [ -f package.json ] && grep -q '"next"' package.json 2>/dev/null; then
  STACK="nextjs"
elif [ -f package.json ]; then
  STACK="node"
elif [ -f requirements.txt ] || [ -f pyproject.toml ] || [ -f setup.py ]; then
  STACK="python"
elif [ -f composer.json ]; then
  STACK="laravel"
elif [ -f Package.swift ] || ls *.xcodeproj 2>/dev/null; then
  STACK="swift"
else
  STACK="generic"
fi
```

### 3. Create Missing Directory Structure

Only create directories that don't already exist:

```bash
[ -d docs ] || mkdir -p docs
[ -d docs/tasks ] || mkdir -p docs/tasks
[ -d docs/notes ] || mkdir -p docs/notes
[ -d tests ] || mkdir -p tests
[ -d .cursor/rules ] || mkdir -p .cursor/rules
```

### 4. Add Missing Documentation

For each file, **skip if it already exists**:

```bash
IMPROVE_SRC=~/Cursor/cursor-improvement-plan

# Core agent reference
[ -f AGENT.md ] || cp "$IMPROVE_SRC/AGENT.md" ./AGENT.md

# Agent self-learning scratchpad
[ -f SCRATCHPAD.md ] || cp "$IMPROVE_SRC/templates/project/SCRATCHPAD.md.template" ./SCRATCHPAD.md

# Documentation templates (only if docs/ files are missing)
[ -f docs/PROJECT.md ] || cp "$IMPROVE_SRC/templates/project/PROJECT.md.template" docs/PROJECT.md
[ -f docs/ARCHITECTURE.md ] || cp "$IMPROVE_SRC/templates/project/ARCHITECTURE.md.template" docs/ARCHITECTURE.md
[ -f docs/SETUP.md ] || cp "$IMPROVE_SRC/templates/project/SETUP.md.template" docs/SETUP.md
[ -f docs/DECISIONS.md ] || cp "$IMPROVE_SRC/templates/project/DECISIONS.md.template" docs/DECISIONS.md
[ -f docs/CHANGELOG.md ] || cp "$IMPROVE_SRC/templates/project/CHANGELOG.md.template" docs/CHANGELOG.md
```

### 5. Improve .gitignore

If `.gitignore` exists, verify it has essential security patterns. If missing, create one:

```bash
if [ ! -f .gitignore ]; then
  cp "$IMPROVE_SRC/templates/project/.gitignore.template" .gitignore
else
  # Ensure critical patterns are present
  grep -q "^\.env$" .gitignore || echo -e "\n# Added by Cursor Improvement Plan\n.env" >> .gitignore
  grep -q "^\*\.key$" .gitignore || echo "*.key" >> .gitignore
  grep -q "^\*\.pem$" .gitignore || echo "*.pem" >> .gitignore
fi
```

### 6. Add .env.example

If missing, create a starter `.env.example`:

```bash
if [ ! -f .env.example ]; then
  PROJECT_NAME=$(basename "$(pwd)")
  cat > .env.example << EOF
# =============================================================================
# $PROJECT_NAME Environment Variables
# =============================================================================
# Copy this file to .env and fill in the values
# NEVER commit .env to git!
# =============================================================================

# Application
APP_NAME="$PROJECT_NAME"
APP_ENV=local
APP_DEBUG=true

# Database (if needed)
# DB_HOST=127.0.0.1
# DB_PORT=5432
# DB_DATABASE=$PROJECT_NAME
# DB_USERNAME=
# DB_PASSWORD=

# External Services (get from 1Password)
# API_KEY=
# API_SECRET=
EOF
fi
```

### 7. Add Stack-Specific Rules

Copy rules for the detected stack if `.cursor/rules/` is empty or missing rules:

```bash
RULES_DIR=.cursor/rules
STACK_SRC="$IMPROVE_SRC/templates/stacks/$STACK"

if [ -d "$STACK_SRC" ]; then
  for file in "$STACK_SRC"/*.md; do
    filename=$(basename "$file")
    [ -f "$RULES_DIR/$filename" ] || cp "$file" "$RULES_DIR/$filename"
  done
else
  # Generic fallback: add core rules if no rules exist
  if [ -z "$(ls -A $RULES_DIR 2>/dev/null)" ]; then
    cp "$IMPROVE_SRC/core/COMMANDMENTS.md" "$RULES_DIR/core.md"
  fi
fi
```

### 8. Customize Templates

Replace placeholders in any newly added files:
- `[Project Name]` -> directory name (e.g., `basename $(pwd)`)
- `YYYY-MM-DD` -> today's date

```bash
PROJECT_NAME=$(basename "$(pwd)")
TODAY=$(date +%Y-%m-%d)

# Only update files that still have placeholders (i.e., freshly copied templates)
find . -name "*.md" -newer IMPROVEMENT.md -type f 2>/dev/null | while read -r file; do
  sed -i '' "s/\[Project Name\]/$PROJECT_NAME/g" "$file" 2>/dev/null || true
  sed -i '' "s/YYYY-MM-DD/$TODAY/g" "$file" 2>/dev/null || true
done
```

### 9. Run Validation

Verify the improvements look good:

```bash
~/Cursor/cursor-improvement-plan/tools/validate.sh .
```

### 10. Report What Was Improved

Tell the user:

```
Done! Project improvements applied:

  Added:
  - [list each file/dir that was created]

  Skipped (already existed):
  - [list each file/dir that was skipped]

  Stack detected: [stack]
  Rules applied: [rule files]

Next steps:
1. Review any newly added docs/ files and fill in project-specific details
2. Review .cursor/rules/ and customize for your project
3. Read SCRATCHPAD.md -- start using it at the end of each session
4. Delete this IMPROVEMENT.md file (its job is done)
```

### 11. Delete This File

```bash
rm IMPROVEMENT.md
```

---

## What Gets Added (Summary)

| Component | What's Checked | What's Added If Missing |
|-----------|---------------|------------------------|
| `docs/` | Directory and core doc files | PROJECT.md, ARCHITECTURE.md, SETUP.md, DECISIONS.md, CHANGELOG.md |
| `docs/tasks/` | Directory | Empty directory for task tracking |
| `docs/notes/` | Directory | Empty directory for session notes |
| `tests/` | Directory | Empty directory |
| `.cursor/rules/` | Directory and rule files | Stack-specific rules or generic core rules |
| `AGENT.md` | File exists | Full agent reference guide |
| `SCRATCHPAD.md` | File exists | Agent self-learning log |
| `.gitignore` | File exists + security patterns | Template or appended patterns |
| `.env.example` | File exists | Starter environment template |

---

## Non-Destructive Guarantee

This workflow **never**:
- Overwrites existing files
- Modifies existing code
- Changes git history
- Removes anything

It **only**:
- Creates missing directories
- Adds missing documentation files
- Appends critical patterns to `.gitignore` (if they're missing)
- Copies templates that can be customized

---

## Full Reference

After improvement, read `AGENT.md` for complete guidelines including:
- The 10 Commandments
- Guardrails (stop-and-ask rules)
- Credential management via 1Password
- Development workflow
- Self-improvement loop

---

*Cursor Improvement Plan v4.0 -- https://github.com/cfloinc/cursor-improvement-plan*
