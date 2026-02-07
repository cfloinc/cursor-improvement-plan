# Project Validation Skill

> Verify a project follows Cursor Improvement Plan conventions and report issues.

---

## When to Use

Use this skill when:
- Checking if a project is properly set up
- Auditing documentation completeness
- Before starting work on an unfamiliar project
- Verifying security best practices

---

## Instructions

### Step 1: Run Validation Script

```bash
~/Cursor/cursor-improvement-plan/tools/validate.sh .
```

### Step 2: Manual Checks

If the script isn't available, perform these checks manually:

#### Structure Checks

```bash
# Check directory structure
ls -d docs/ src/ tests/ 2>/dev/null

# Check for task tracking
ls docs/tasks/ 2>/dev/null

# Check for notes directory
ls docs/notes/ 2>/dev/null
```

#### Documentation Checks

```bash
# Required docs
ls docs/PROJECT.md docs/ARCHITECTURE.md docs/SETUP.md 2>/dev/null
ls README.md 2>/dev/null

# Check if docs have content (not just templates)
wc -l docs/PROJECT.md 2>/dev/null
wc -l docs/ARCHITECTURE.md 2>/dev/null
```

#### Configuration Checks

```bash
# Check for rules
ls .cursorrules 2>/dev/null
ls .cursor/rules/*.md 2>/dev/null

# Check for env template
ls .env.example 2>/dev/null

# Check gitignore
cat .gitignore 2>/dev/null | grep -E "\.env|\.key|\.pem"
```

#### Security Checks

```bash
# Check if .env is tracked (BAD if found)
git ls-files .env 2>/dev/null

# Check for tracked secret patterns
git ls-files "*.key" "*.pem" "*.p12" 2>/dev/null

# Verify .gitignore patterns
grep -E "^\.env$|^\*\.key$|^\*\.pem$" .gitignore 2>/dev/null
```

### Step 3: Generate Report

Create a validation report with this structure:

```markdown
## Project Validation Report

**Project**: [directory name]
**Date**: YYYY-MM-DD

### Structure
| Check | Status | Notes |
|-------|--------|-------|
| docs/ directory | ✅/❌ | |
| src/ directory | ✅/❌/⚠️ | |
| tests/ directory | ✅/❌/⚠️ | |

### Documentation
| Check | Status | Notes |
|-------|--------|-------|
| README.md | ✅/❌ | |
| docs/PROJECT.md | ✅/❌/⚠️ | Template only? |
| docs/ARCHITECTURE.md | ✅/❌/⚠️ | |
| docs/SETUP.md | ✅/❌/⚠️ | |
| docs/CHANGELOG.md | ✅/❌/⚠️ | |

### Configuration
| Check | Status | Notes |
|-------|--------|-------|
| .cursorrules or .cursor/rules/ | ✅/❌ | |
| .env.example | ✅/❌ | |
| .gitignore | ✅/❌ | |

### Security
| Check | Status | Notes |
|-------|--------|-------|
| .env not tracked | ✅/❌ | CRITICAL if ❌ |
| No secrets in git | ✅/❌ | |
| .gitignore has patterns | ✅/❌ | |

### Score
**Passed**: X/Y
**Warnings**: Z
**Failed**: W

### Recommendations
1. [Most critical issue first]
2. [Second issue]
3. [etc.]
```

### Step 4: Offer Fixes

For common issues, offer to fix them:

**Missing .gitignore patterns:**
```bash
echo ".env" >> .gitignore
echo "*.key" >> .gitignore
echo "*.pem" >> .gitignore
```

**Missing docs directory:**
```bash
mkdir -p docs/tasks docs/notes
cp ~/Cursor/cursor-improvement-plan/templates/project/*.template docs/
```

**Missing .env.example:**
```bash
touch .env.example
echo "# Add required environment variables here" >> .env.example
```

---

## Status Legend

| Status | Meaning |
|--------|---------|
| ✅ | Passed - meets requirements |
| ⚠️ | Warning - exists but may need attention |
| ❌ | Failed - missing or incorrect |

---

## Severity Levels

| Level | Description |
|-------|-------------|
| 🔴 Critical | Security issues, must fix immediately |
| 🟠 High | Missing essential components |
| 🟡 Medium | Missing recommended components |
| 🟢 Low | Nice to have |

---

## Example Output

```markdown
## Project Validation Report

**Project**: my-api
**Date**: 2026-02-01

### Summary
- ✅ 12 checks passed
- ⚠️ 3 warnings
- ❌ 2 failed

### Critical Issues
1. 🔴 `.env` file is tracked in git - remove and rotate credentials!
2. 🟠 No tests/ directory found

### Warnings
1. docs/PROJECT.md appears to be template placeholder (15 lines)
2. No docs/notes/ directory for learnings
3. .cursorrules is minimal (< 20 lines)

### Recommendations
1. Run `git rm --cached .env` and add to .gitignore
2. Create tests/ directory with at least one test
3. Fill in docs/PROJECT.md with actual project info
```
