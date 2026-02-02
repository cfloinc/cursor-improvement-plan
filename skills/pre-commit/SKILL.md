# Pre-Commit Checks Skill

> Run quality checks before committing code.

---

## When to Use

Use this skill:
- Before every commit (especially for important changes)
- When asked to verify code quality
- As part of PR preparation

---

## Instructions

### Step 1: Check What's Staged

```bash
git status
git diff --staged --name-only
```

### Step 2: Security Check

**Critical - Check for secrets in staged files:**

```bash
# Look for common secret patterns in staged changes
git diff --staged | grep -iE "(api_key|api_secret|password|token|secret|credential)" | head -20

# Check if any secret files are staged
git diff --staged --name-only | grep -iE "\.env$|\.key$|\.pem$|credentials|secrets"
```

**If secrets found:** STOP and alert the user. Do not proceed.

### Step 3: Run Linter

Detect project type and run appropriate linter:

**JavaScript/TypeScript:**
```bash
npm run lint 2>/dev/null || npx eslint . 2>/dev/null
```

**Python:**
```bash
ruff check . 2>/dev/null || flake8 . 2>/dev/null || pylint **/*.py 2>/dev/null
```

**PHP:**
```bash
./vendor/bin/phpcs 2>/dev/null
```

### Step 4: Run Tests

**JavaScript/TypeScript:**
```bash
npm test 2>/dev/null
```

**Python:**
```bash
pytest 2>/dev/null || python -m pytest 2>/dev/null
```

**PHP:**
```bash
php artisan test 2>/dev/null || ./vendor/bin/phpunit 2>/dev/null
```

### Step 5: Type Check (if applicable)

**TypeScript:**
```bash
npx tsc --noEmit 2>/dev/null
```

**Python (with type hints):**
```bash
mypy . 2>/dev/null
```

### Step 6: Check Documentation

If any of these files changed, verify docs are updated:
- API routes/endpoints → API.md or README
- Config options → README or SETUP.md
- User-facing features → CHANGELOG.md

```bash
# Check which docs might need updating
git diff --staged --name-only | grep -E "\.(ts|js|py|php)$"
```

### Step 7: Generate Report

```markdown
## Pre-Commit Check Results

**Files staged**: X files
**Date**: YYYY-MM-DD HH:MM

### Security ✅/❌
- [ ] No secrets in staged files
- [ ] No .env files staged
- [ ] No credential files staged

### Code Quality ✅/❌/⚠️
- [ ] Linter passed (X warnings)
- [ ] Type check passed
- [ ] No console.log/print statements (unless intentional)

### Tests ✅/❌/⚠️
- [ ] All tests pass (X/Y passed)
- [ ] No skipped tests (or justified)

### Documentation ✅/⚠️
- [ ] CHANGELOG updated (if user-facing change)
- [ ] README updated (if setup changed)
- [ ] API docs updated (if endpoints changed)

### Result
**Ready to commit**: Yes/No

### Issues to Fix
1. [Issue 1]
2. [Issue 2]
```

### Step 8: Offer Fixes

For auto-fixable issues:

**Linter issues:**
```bash
npm run lint:fix 2>/dev/null
# or
ruff check . --fix 2>/dev/null
```

**Formatting:**
```bash
npx prettier --write . 2>/dev/null
# or
black . 2>/dev/null
```

---

## Quick Check (Minimal)

For simple commits, run this quick version:

```bash
# 1. Security check
git diff --staged | grep -iE "(api_key|password|token|secret)" && echo "⚠️ Possible secrets!"

# 2. Run tests
npm test 2>/dev/null || pytest 2>/dev/null

# 3. Check for debug statements
git diff --staged | grep -E "console\.log|print\(|debugger" | head -5
```

---

## Commit Checklist

Before committing, verify:

- [ ] **Security**: No secrets in staged files
- [ ] **Tests**: All tests pass
- [ ] **Lint**: No new linter errors
- [ ] **Types**: Type check passes (if applicable)
- [ ] **Docs**: Updated if behavior changed
- [ ] **Message**: Follows conventional commit format

---

## When to Skip Tests

It's acceptable to skip full test suite for:
- Documentation-only changes (`docs:` commits)
- Style/formatting changes (`style:` commits)
- Config file changes (but still verify they parse)

But ALWAYS run security checks, regardless of commit type.

---

## Example Interaction

**User:** "Check if this is ready to commit"

**Agent:**
1. Checks staged files
2. Scans for secrets (STOP if found)
3. Runs linter, reports issues
4. Runs tests, reports results
5. Checks if docs need updating
6. Provides summary with pass/fail
7. Offers to fix auto-fixable issues
