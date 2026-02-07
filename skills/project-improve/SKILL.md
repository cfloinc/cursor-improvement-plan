# Project Improvement Skill

> Audit an existing project and non-destructively add everything that's missing.

---

## When to Use

Use this skill when:
- Upgrading an existing project with best-practice structure
- Adding documentation, rules, or configuration to an established codebase
- Ensuring a project follows Cursor Improvement Plan conventions

---

## Instructions

### Step 1: Audit Current State

Check what already exists in the project:

```bash
ls -la
ls docs/ 2>/dev/null
ls .cursor/rules/ 2>/dev/null
ls tests/ 2>/dev/null
ls src/ 2>/dev/null
cat .gitignore 2>/dev/null | head -20
ls .env.example SCRATCHPAD.md AGENT.md 2>/dev/null
```

Build a mental inventory: what exists, what's missing, what's incomplete.

### Step 2: Detect Tech Stack

Auto-detect from existing files -- do not ask the user:

| File Found | Stack |
|------------|-------|
| `package.json` with `"next"` | nextjs |
| `package.json` (without Next) | node |
| `requirements.txt` or `pyproject.toml` or `setup.py` | python |
| `composer.json` | laravel |
| `Package.swift` or `*.xcodeproj` | swift |
| None of the above | generic |

### Step 3: Add Missing Structure

Only create directories that don't already exist:

```bash
IMPROVE_SRC=~/Cursor/cursor-improvement-plan

[ -d docs ] || mkdir -p docs
[ -d docs/tasks ] || mkdir -p docs/tasks
[ -d docs/notes ] || mkdir -p docs/notes
[ -d tests ] || mkdir -p tests
[ -d .cursor/rules ] || mkdir -p .cursor/rules
```

### Step 4: Add Missing Documentation

For each file, **skip if it already exists** -- never overwrite:

```bash
# Core agent reference
[ -f AGENT.md ] || cp "$IMPROVE_SRC/AGENT.md" ./AGENT.md

# Agent self-learning scratchpad
[ -f SCRATCHPAD.md ] || cp "$IMPROVE_SRC/templates/project/SCRATCHPAD.md.template" ./SCRATCHPAD.md

# Documentation templates
[ -f docs/PROJECT.md ] || cp "$IMPROVE_SRC/templates/project/PROJECT.md.template" docs/PROJECT.md
[ -f docs/ARCHITECTURE.md ] || cp "$IMPROVE_SRC/templates/project/ARCHITECTURE.md.template" docs/ARCHITECTURE.md
[ -f docs/SETUP.md ] || cp "$IMPROVE_SRC/templates/project/SETUP.md.template" docs/SETUP.md
[ -f docs/DECISIONS.md ] || cp "$IMPROVE_SRC/templates/project/DECISIONS.md.template" docs/DECISIONS.md
[ -f docs/CHANGELOG.md ] || cp "$IMPROVE_SRC/templates/project/CHANGELOG.md.template" docs/CHANGELOG.md
```

### Step 5: Improve .gitignore

```bash
if [ ! -f .gitignore ]; then
  cp "$IMPROVE_SRC/templates/project/.gitignore.template" .gitignore
else
  # Ensure critical security patterns are present
  grep -q "^\.env$" .gitignore || echo -e "\n# Added by Cursor Improvement Plan\n.env" >> .gitignore
  grep -q "^\*\.key$" .gitignore || echo "*.key" >> .gitignore
  grep -q "^\*\.pem$" .gitignore || echo "*.pem" >> .gitignore
fi
```

### Step 6: Add .env.example

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
EOF
fi
```

### Step 7: Add Stack-Specific Rules

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

### Step 8: Customize Templates

Replace placeholders in newly added files only:

- `[Project Name]` -> directory name
- `YYYY-MM-DD` -> today's date

### Step 9: Validate

Run the validation script to verify improvements:

```bash
~/Cursor/cursor-improvement-plan/tools/validate.sh .
```

### Step 10: Report Results

Summarize what was done:

```markdown
## Project Improvement Complete

**Stack detected**: [stack]

**Added** (did not exist before):
- [list each file/dir that was created]

**Skipped** (already existed):
- [list each file/dir that was skipped]

**Security**:
- .gitignore verified with essential patterns

**Next Steps:**
1. Review any newly added docs/ files and fill in project-specific details
2. Review and customize .cursor/rules/
3. Start using SCRATCHPAD.md at the end of each session
4. Delete IMPROVEMENT.md if it was copied into the project
```

---

## Non-Destructive Guarantee

This skill **never**:
- Overwrites existing files
- Modifies existing code
- Changes git history
- Removes anything

It **only**:
- Creates missing directories
- Adds missing documentation files
- Appends critical patterns to `.gitignore` (if absent)
- Copies templates that can be customized

---

## Stack Detection Details

If not obvious from a single file, check multiple signals:

| Signal | Stack |
|--------|-------|
| `next.config.js` or `next.config.mjs` | nextjs |
| `tsconfig.json` + `package.json` | node |
| `Pipfile` or `poetry.lock` | python |
| `artisan` file in root | laravel |
| `.swift` files or `*.xcworkspace` | swift |

---

## Validation Criteria

After improvement, verify:
- [ ] `docs/` directory exists with core files
- [ ] `.cursor/rules/` exists with at least one rule file
- [ ] `.gitignore` exists and includes `.env`
- [ ] `.env.example` exists
- [ ] `SCRATCHPAD.md` exists
- [ ] `AGENT.md` exists

---

## Example Interaction

**User:** "Improve this project"

**Agent:**
1. Audits current directory for existing structure
2. Detects stack from `package.json` / `requirements.txt` / etc.
3. Creates missing directories (docs/, tests/, .cursor/rules/)
4. Copies missing documentation templates (skips existing files)
5. Ensures .gitignore has security patterns
6. Adds stack-specific rules
7. Runs validation
8. Reports what was added vs. skipped
