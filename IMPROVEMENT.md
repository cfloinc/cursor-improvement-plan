# IMPROVE THIS PROJECT

> **Drop this file into any existing Cursor project.** The agent will read it,
> audit what's there, and automatically add everything that's missing.

---

## CRITICAL RULES

1. **ALL changes happen in THIS project directory only.**
2. `~/Cursor/cursor-improvement-plan/` is a **READ-ONLY** source of templates.
   You may copy files FROM it. You must NEVER modify, write to, or delete
   anything inside it.
3. Every new file you create goes into THIS project's working directory.
4. Never overwrite existing files -- only add what's missing.

---

## Agent: Do This Now

When you read this file in a project, **immediately run this improvement workflow**.

### 1. Audit Current State

Check what already exists in THIS project:

```bash
ls -la
ls docs/ 2>/dev/null
ls .cursor/rules/ 2>/dev/null
ls tests/ 2>/dev/null
ls src/ 2>/dev/null
cat .gitignore 2>/dev/null | head -20
ls .env.example 2>/dev/null
ls SCRATCHPAD.md 2>/dev/null
```

Record what exists and what's missing. Keep a running tally.

### 2. Detect Tech Stack

Auto-detect from existing files in THIS project -- do not ask the user:

| File Found | Stack |
|------------|-------|
| `package.json` with `"next"` dependency | nextjs |
| `package.json` (without Next) | node |
| `requirements.txt` or `pyproject.toml` or `setup.py` | python |
| `composer.json` | laravel |
| `Package.swift` or `*.xcodeproj` | swift |
| None of the above | generic |

### 3. Create Missing Directory Structure

Only create directories that don't already exist in THIS project:

```bash
[ -d docs ] || mkdir -p docs
[ -d docs/tasks ] || mkdir -p docs/tasks
[ -d docs/notes ] || mkdir -p docs/notes
[ -d tests ] || mkdir -p tests
[ -d .cursor/rules ] || mkdir -p .cursor/rules
```

### 4. Add Missing Documentation

For each file, **skip if it already exists** in THIS project. Copy FROM
the improvement plan repo (read-only source) INTO this project:

```bash
IMPROVE_SRC=~/Cursor/cursor-improvement-plan

# Agent self-learning scratchpad
[ -f SCRATCHPAD.md ] || cp "$IMPROVE_SRC/templates/project/SCRATCHPAD.md.template" ./SCRATCHPAD.md

# Documentation templates (only copy what's missing)
[ -f docs/PROJECT.md ] || cp "$IMPROVE_SRC/templates/project/PROJECT.md.template" docs/PROJECT.md
[ -f docs/ARCHITECTURE.md ] || cp "$IMPROVE_SRC/templates/project/ARCHITECTURE.md.template" docs/ARCHITECTURE.md
[ -f docs/SETUP.md ] || cp "$IMPROVE_SRC/templates/project/SETUP.md.template" docs/SETUP.md
[ -f docs/DECISIONS.md ] || cp "$IMPROVE_SRC/templates/project/DECISIONS.md.template" docs/DECISIONS.md
[ -f docs/CHANGELOG.md ] || cp "$IMPROVE_SRC/templates/project/CHANGELOG.md.template" docs/CHANGELOG.md
```

**Reminder**: These `cp` commands copy INTO this project. Do not modify the source files.

### 5. Improve .gitignore

If `.gitignore` does not exist in THIS project, copy the template:

```bash
[ -f .gitignore ] || cp "$IMPROVE_SRC/templates/project/.gitignore.template" .gitignore
```

If `.gitignore` already exists, ensure these critical security patterns are present
(append them if missing):

```bash
grep -q "^\.env$" .gitignore || echo -e "\n# Added by Cursor Improvement Plan\n.env" >> .gitignore
grep -q "^\*\.key$" .gitignore || echo "*.key" >> .gitignore
grep -q "^\*\.pem$" .gitignore || echo "*.pem" >> .gitignore
```

### 6. Add .env.example

If `.env.example` does not exist in THIS project, create it:

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

# External Services
# API_KEY=
# API_SECRET=
EOF
fi
```

### 7. Add Stack-Specific Cursor Rules

Copy rules for the detected stack INTO this project's `.cursor/rules/`.
Skip if rule files already exist:

```bash
RULES_DIR=.cursor/rules
STACK_SRC="$IMPROVE_SRC/templates/stacks/$STACK"

if [ -d "$STACK_SRC" ]; then
  for file in "$STACK_SRC"/*.md; do
    filename=$(basename "$file")
    [ -f "$RULES_DIR/$filename" ] || cp "$file" "$RULES_DIR/$filename"
  done
else
  # Generic fallback: add core rules if no rules exist at all
  if [ -z "$(ls -A $RULES_DIR 2>/dev/null)" ]; then
    cp "$IMPROVE_SRC/core/COMMANDMENTS.md" "$RULES_DIR/core.md"
  fi
fi
```

**Reminder**: These `cp` commands copy INTO this project. Do not modify the source files.

### 8. Customize Templates

Replace placeholders in any newly created files in THIS project (not pre-existing ones):
- `[Project Name]` -> this project's directory name
- `YYYY-MM-DD` -> today's date

### 9. Report What Was Improved

Tell the user:

```
Project improvements applied!

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

### 10. Delete This File

After reporting, delete `IMPROVEMENT.md` from THIS project -- its job is done.

---

## What Gets Added (Summary)

| Component | What's Checked | What's Added If Missing |
|-----------|---------------|------------------------|
| `docs/` | Directory and core doc files | PROJECT.md, ARCHITECTURE.md, SETUP.md, DECISIONS.md, CHANGELOG.md |
| `docs/tasks/` | Directory | Empty directory for task tracking |
| `docs/notes/` | Directory | Empty directory for session notes |
| `tests/` | Directory | Empty directory |
| `.cursor/rules/` | Directory and rule files | Stack-specific rules or generic core rules |
| `SCRATCHPAD.md` | File exists | Agent self-learning log |
| `.gitignore` | File exists + security patterns | Full template or appended patterns |
| `.env.example` | File exists | Environment variable template |

---

## Non-Destructive Guarantee

This workflow **never**:
- Overwrites existing files in this project
- Modifies existing code in this project
- Changes git history
- Modifies anything in `~/Cursor/cursor-improvement-plan/` (read-only source)

It **only**:
- Creates missing directories in THIS project
- Copies template files INTO this project
- Appends critical patterns to `.gitignore` (if they're missing)

---

## Reference

The improvement plan source repo contains additional resources you can
reference (read-only):

| Resource | Path (read-only) |
|----------|------------------|
| Core principles | `~/Cursor/cursor-improvement-plan/core/` |
| Detailed guides | `~/Cursor/cursor-improvement-plan/guides/` |
| All templates | `~/Cursor/cursor-improvement-plan/templates/` |
| Agent skills | `~/Cursor/cursor-improvement-plan/skills/` |
| Shell tools | `~/Cursor/cursor-improvement-plan/tools/` |

---

*Cursor Improvement Plan v4.0 -- https://github.com/cfloinc/cursor-improvement-plan*
