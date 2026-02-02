# The 10 Commandments

> Core principles for AI agent behavior. Memorize these.

---

## 1. Read Before Writing

**Always understand existing code and docs first.**

- Read relevant files before making changes
- Check for existing patterns and conventions
- Look for related tests to understand expected behavior
- Never edit code you haven't read

```bash
# Before editing any file
cat path/to/file.js
# Check for related tests
ls tests/*user* 2>/dev/null
```

---

## 2. Small Commits, Often

**One logical change per commit, push immediately.**

- Each commit should be reviewable in < 5 minutes
- Don't batch unrelated changes
- Push after every commit (don't let local commits pile up)
- Easy to review, easy to revert

```bash
# Good
git commit -m "feat(auth): add password reset endpoint"
git push

# Bad - batching unrelated changes
git commit -m "add auth, fix cart, update docs, refactor utils"
```

---

## 3. Document the "Why"

**Comments explain reasoning, not obvious behavior.**

```python
# Bad - describes what (obvious from code)
# Increment counter by 1
counter += 1

# Good - explains why
# Rate limit recovery: back off exponentially to avoid overwhelming the API
delay = min(base_delay * (2 ** attempt), max_delay)
```

When in doubt, ask: "Would future me understand WHY this code exists?"

---

## 4. Test Your Changes

**Run relevant tests before committing.**

- Run the test suite (or at minimum, affected tests)
- If no tests exist for your change, consider adding them
- Verify the feature works as expected
- Check for regressions

```bash
# Run all tests
npm test          # Node
pytest            # Python
php artisan test  # Laravel

# Run specific tests
npm test -- --grep "auth"
pytest tests/test_auth.py
```

---

## 5. Ask Before Breaking Changes

**Stop for approval on high-impact changes.**

Always get explicit approval before:
- Changing authentication or authorization logic
- Modifying database schemas
- Altering CI/CD pipelines
- Refactoring core architecture
- Deleting files or directories
- Any irreversible operation

```markdown
# Good pattern
"This requires a database schema change. Here's the migration I'd run:
[show migration]
Should I proceed?"
```

---

## 6. Use Conventional Commits

**Consistent commit message format.**

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | Use For |
|------|---------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting (no logic change) |
| `refactor` | Code restructure (no behavior change) |
| `test` | Adding or updating tests |
| `chore` | Maintenance, dependencies |

### Examples

```bash
feat(auth): add password reset via email
fix(cart): prevent negative quantities
docs(api): update authentication examples
refactor(utils): extract date formatting helpers
test(auth): add tests for token refresh
chore(deps): update lodash to 4.17.21
```

---

## 7. Keep Secrets Out of Git

**Use `.env` files, verify `.gitignore` works.**

### Never Commit

- `.env` files with real credentials
- API keys, tokens, passwords
- Private keys (`.pem`, `.key`, `.p12`)
- Connection strings with passwords

### Always Do

```bash
# Before first commit, verify secrets are ignored
git status --ignored | grep -E "\.env|\.key|\.pem"

# If accidentally staged
git reset HEAD .env
```

### Pattern

```bash
# .env (gitignored, local only)
DATABASE_URL=postgresql://user:secret@localhost/db
API_KEY=sk-live-xxxxx

# .env.example (committed, no real values)
DATABASE_URL=postgresql://user:password@host/database
API_KEY=your-api-key-here
```

---

## 8. Update Docs With Code

**If behavior changes, docs change too.**

When you change code:
1. Check if the change affects documented behavior
2. Update relevant docs in the same commit
3. Don't leave docs and code out of sync

### Documentation Checklist

- [ ] README.md still accurate?
- [ ] API docs reflect changes?
- [ ] CHANGELOG updated for user-facing changes?
- [ ] Comments still accurate?

---

## 9. Progress Over Perfection

**Working code now beats perfect code never.**

- Ship incremental improvements
- Don't over-engineer for hypotheticals
- Refactor when patterns become clear, not before
- "Good enough" that works > "perfect" that doesn't exist

### Anti-Patterns

- Spending hours on code style for a prototype
- Adding abstraction before you have 3 use cases
- Optimizing before you've measured a problem
- Debating architecture instead of shipping

---

## 10. Communicate Blockers Early

**Don't spin; ask for help.**

If you're stuck for more than 15 minutes:
1. Document what you've tried
2. Explain where you're stuck
3. Ask for guidance

```markdown
# Good pattern
"I've been trying to fix this test failure. Here's what I've tried:
1. [approach 1] - didn't work because [reason]
2. [approach 2] - got error [error]

I'm stuck on [specific thing]. Can you help?"
```

### Signs You Should Ask

- Trying the same thing multiple times
- Not sure if approach is correct
- Making changes without understanding why
- Feeling like you're guessing

---

## Quick Reference Card

| # | Commandment | Key Action |
|---|-------------|------------|
| 1 | Read before writing | `cat file` before edit |
| 2 | Small commits, often | One change, push immediately |
| 3 | Document the "why" | Explain reasoning, not code |
| 4 | Test your changes | `npm test` before commit |
| 5 | Ask before breaking | Stop for architecture, auth, DB, CI |
| 6 | Conventional commits | `type(scope): description` |
| 7 | Secrets out of git | Use `.env`, check `.gitignore` |
| 8 | Docs with code | Same commit for both |
| 9 | Progress over perfection | Ship, then iterate |
| 10 | Communicate blockers | Ask after 15 min stuck |

---

*These commandments are non-negotiable. Violating them consistently will lead to poor outcomes.*
