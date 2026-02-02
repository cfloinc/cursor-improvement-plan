# Technical Debt Finder Skill

> Find and report technical debt in the codebase.

---

## When to Use

Use this skill when:
- Starting work on an unfamiliar codebase
- Looking for improvement opportunities
- Preparing for a refactoring sprint
- Asked to assess code quality

---

## Instructions

### Step 1: Find TODO Comments

```bash
# Find all TODOs
grep -rn "TODO" --include="*.ts" --include="*.js" --include="*.py" --include="*.php" . 2>/dev/null | grep -v node_modules | grep -v vendor

# Find FIXMEs
grep -rn "FIXME" --include="*.ts" --include="*.js" --include="*.py" --include="*.php" . 2>/dev/null | grep -v node_modules | grep -v vendor

# Find HACKs
grep -rn "HACK" --include="*.ts" --include="*.js" --include="*.py" --include="*.php" . 2>/dev/null | grep -v node_modules | grep -v vendor
```

### Step 2: Find Commented-Out Code

```bash
# Large blocks of commented code (3+ consecutive lines)
# This is a heuristic - review results manually
grep -rn "^[[:space:]]*//.*;" --include="*.ts" --include="*.js" . 2>/dev/null | grep -v node_modules | head -20
grep -rn "^[[:space:]]*#.*=" --include="*.py" . 2>/dev/null | grep -v venv | head -20
```

### Step 3: Find Large Files

```bash
# Files over 300 lines (potential candidates for splitting)
find . -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.php" 2>/dev/null | \
  grep -v node_modules | grep -v vendor | grep -v venv | \
  xargs wc -l 2>/dev/null | sort -rn | head -20
```

### Step 4: Find Long Functions

This requires reading files and analyzing. Look for:
- Functions over 50 lines
- Functions with more than 5 parameters
- Deeply nested code (3+ levels)

```bash
# For JavaScript/TypeScript - find function definitions
grep -rn "function\|const.*=.*=>" --include="*.ts" --include="*.js" . 2>/dev/null | \
  grep -v node_modules | grep -v "\.d\.ts" | head -30
```

### Step 5: Find Duplicate Code

Look for similar patterns repeated across files:
- Copy-pasted error handling
- Repeated API call patterns
- Duplicate validation logic

```bash
# Find files with similar names (potential duplication)
find . -name "*.ts" -o -name "*.js" 2>/dev/null | grep -v node_modules | \
  xargs -I{} basename {} | sort | uniq -d
```

### Step 6: Find Files Without Tests

```bash
# List source files
find src -name "*.ts" -o -name "*.js" 2>/dev/null | sed 's/.*\///' | sort > /tmp/src_files.txt

# List test files
find tests -name "*.test.ts" -o -name "*.spec.ts" -o -name "test_*.py" 2>/dev/null | \
  sed 's/.*\///' | sed 's/\.test\./\./' | sed 's/\.spec\./\./' | sed 's/test_//' | sort > /tmp/test_files.txt

# Files without tests (approximate)
comm -23 /tmp/src_files.txt /tmp/test_files.txt 2>/dev/null
```

### Step 7: Check Dependencies

```bash
# Check for outdated dependencies (Node)
npm outdated 2>/dev/null

# Check for security vulnerabilities
npm audit 2>/dev/null | head -30

# Python
pip list --outdated 2>/dev/null
```

### Step 8: Generate Report

```markdown
## Technical Debt Report

**Project**: [name]
**Date**: YYYY-MM-DD
**Scanned**: X files

---

### Summary
| Category | Count | Severity |
|----------|-------|----------|
| TODO comments | X | 🟡 Medium |
| FIXME comments | X | 🟠 High |
| Large files (>300 lines) | X | 🟡 Medium |
| Files without tests | X | 🟠 High |
| Outdated dependencies | X | 🟡 Medium |
| Security vulnerabilities | X | 🔴 Critical |

---

### TODO Comments
| File | Line | Comment |
|------|------|---------|
| src/api.ts | 45 | TODO: Add rate limiting |
| src/auth.ts | 123 | TODO: Implement refresh tokens |

### FIXME Comments
| File | Line | Comment |
|------|------|---------|
| src/payment.ts | 89 | FIXME: Race condition in checkout |

### Large Files (Consider Splitting)
| File | Lines | Suggestion |
|------|-------|------------|
| src/utils.ts | 450 | Split into domain-specific utils |
| src/api/routes.ts | 380 | Extract route handlers |

### Files Without Tests
- src/services/payment.ts (critical - handles money)
- src/utils/validation.ts

### Outdated Dependencies
| Package | Current | Latest | Risk |
|---------|---------|--------|------|
| lodash | 4.17.15 | 4.17.21 | Security fix |
| express | 4.17.1 | 4.18.2 | Features |

### Security Vulnerabilities
| Severity | Count | Action |
|----------|-------|--------|
| Critical | 0 | - |
| High | 2 | Update dependencies |
| Medium | 5 | Review and update |

---

### Recommendations (Priority Order)

1. **🔴 Critical**: Fix security vulnerabilities
   ```bash
   npm audit fix
   ```

2. **🟠 High**: Add tests for payment.ts
   - Handles financial transactions
   - Currently untested

3. **🟠 High**: Fix FIXME in payment.ts:89
   - Race condition could cause double charges

4. **🟡 Medium**: Split utils.ts (450 lines)
   - Extract string utils, date utils, validation

5. **🟡 Medium**: Address TODO in api.ts:45
   - Rate limiting prevents abuse

---

### Quick Wins
- [ ] Run `npm audit fix` (5 min)
- [ ] Add .gitignore for coverage/ (1 min)
- [ ] Remove commented code in auth.ts (10 min)
```

---

## Debt Categories

| Category | What to Look For |
|----------|------------------|
| **Code Smells** | Long functions, deep nesting, magic numbers |
| **Documentation** | Missing comments, outdated docs |
| **Testing** | Low coverage, flaky tests, no tests |
| **Dependencies** | Outdated, vulnerable, unused |
| **Architecture** | Circular deps, tight coupling |
| **Performance** | N+1 queries, missing indexes |

---

## Example Interaction

**User:** "Find technical debt in this project"

**Agent:**
1. Scans for TODOs, FIXMEs, HACKs
2. Identifies large files and functions
3. Checks test coverage
4. Audits dependencies
5. Generates prioritized report
6. Offers quick wins to start addressing
