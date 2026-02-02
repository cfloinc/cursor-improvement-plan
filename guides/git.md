# Git & Version Control Guide

> Standards for commits, branches, and repository management.

---

## Core Principles

1. **One logical change per commit** — Don't batch unrelated changes
2. **Commit early, commit often** — Small commits are easier to review and revert
3. **Push immediately after commit** — Don't let local commits pile up
4. **Never commit secrets** — Verify `.gitignore` before every first commit

---

## Commit Messages

### Format (Conventional Commits)

```
<type>(<scope>): <description>

[optional body explaining why]

[optional footer with references]
```

### Types

| Type | Use For |
|------|---------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, whitespace (no logic change) |
| `refactor` | Code restructuring (no behavior change) |
| `test` | Adding or updating tests |
| `chore` | Maintenance, dependencies, tooling |

### Examples

```bash
feat(auth): add password reset via email

fix(cart): prevent negative quantities

# With body explaining context
fix(api): handle rate limit errors gracefully

The Stripe API returns 429 errors during high traffic.
Added exponential backoff with max 3 retries.

Closes #456
```

### Guidelines

- Use imperative mood: "add feature" not "added feature"
- Keep first line under 72 characters
- Reference issues/tickets in footer when applicable
- Body should explain **why**, not **what**

---

## Branch Strategy

### Naming Convention

```
<type>/<brief-description>
```

| Prefix | Purpose |
|--------|---------|
| `feature/` | New features |
| `bugfix/` | Non-critical bug fixes |
| `hotfix/` | Critical production fixes |
| `docs/` | Documentation changes |
| `refactor/` | Code restructuring |

### Examples

```
feature/user-profile-page
bugfix/login-timeout-handling
hotfix/payment-processing-error
docs/api-authentication-guide
refactor/extract-validation-utils
```

### Lifecycle

1. Create branch from `main`
2. Make focused commits
3. Push branch to remote
4. Open pull request
5. Address review feedback
6. Merge (squash or merge per team convention)
7. Delete branch after merge

---

## Commit Workflow

### Before Each Commit

```bash
# 1. See what changed
git status
git diff

# 2. Run relevant tests
npm test  # or pytest, etc.

# 3. Stage changes (prefer explicit files)
git add <specific-files>

# 4. Review staged changes
git diff --staged

# 5. Commit with meaningful message
git commit -m "feat(scope): description"

# 6. Push immediately
git push
```

---

## Clone Repositories

### Bitbucket (HTTPS — Preferred for Agents)

```bash
git clone https://cfloinc:$(op item get "Bitbucket (cfloinc)" --vault Cursor --fields "App Password")@bitbucket.org/cfloinc/<repo>.git
```

> **Critical**: Username must be `cfloinc` (workspace name), NOT email.

### GitHub (SSH)

```bash
# Verify access first
ssh -T git@github.com

# Clone
git clone git@github.com:cfloinc/<repo>.git
```

---

## .gitignore Essentials

```gitignore
# Secrets - NEVER commit
.env
.env.*
!.env.example
*.key
*.pem
*.p12

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp

# Dependencies
node_modules/
vendor/
venv/
__pycache__/

# Build output
dist/
build/

# Logs
*.log
logs/

# Coverage
coverage/
htmlcov/
```

### Verification

```bash
# Check what would be committed
git status

# Verify secrets are ignored
git status --ignored | grep -E "\.env|\.key|\.pem"

# If a secret was accidentally staged
git reset HEAD .env
```

---

## Dangerous Operations

### Never Do Without Explicit Approval

- `git push --force` on shared branches
- `git reset --hard` on pushed commits
- Deleting remote branches others might use
- Rewriting history on `main`/`master`

### Safe Alternatives

```bash
# Instead of force push
git push --force-with-lease  # Fails if remote changed

# Instead of hard reset
git revert <commit>  # Creates revert commit

# If you must force push your own branch
git push --force-with-lease origin feature/my-branch
```

---

## Recovery Procedures

### Undo Last Commit (Not Pushed)

```bash
# Keep changes staged
git reset --soft HEAD~1

# Keep changes unstaged
git reset HEAD~1

# Discard changes entirely
git reset --hard HEAD~1
```

### Undo Pushed Commit

```bash
# Create a revert commit (safe for shared branches)
git revert <commit-hash>
git push
```

### Recover Deleted Branch

```bash
# Find the commit
git reflog

# Recreate branch
git checkout -b recovered-branch <commit-hash>
```

---

## Git Worktrees (Parallel Sessions)

Run multiple Cursor sessions on different tasks simultaneously.

### What Are Worktrees?

Git worktrees let you check out multiple branches into **separate directories**:
- Own working directory with isolated files
- Shared Git history and remote connections
- Independent state from other worktrees

### Creating Worktrees

```bash
# Create worktree with NEW branch
git worktree add ../project-feature -b feature/user-auth

# Create worktree from EXISTING branch
git worktree add ../project-bugfix bugfix/payment-error

# Naming convention
../myproject-auth      # Working on authentication
../myproject-api       # API refactor
../myproject-bugfix    # Bug investigation
```

### Running Parallel Sessions

```bash
# Terminal 1: Work on feature
cd ../project-feature
cursor .

# Terminal 2: Work on bugfix (completely isolated)
cd ../project-bugfix
cursor .
```

### Managing Worktrees

```bash
# List all worktrees
git worktree list

# Remove when done
git worktree remove ../project-feature

# Force remove (if uncommitted changes)
git worktree remove --force ../project-feature

# Prune stale references
git worktree prune
```

### Per-Worktree Environment Setup

Each worktree needs its own dependencies:

```bash
# JavaScript/Node
cd ../project-feature && npm install

# Python
cd ../project-feature && python -m venv venv && source venv/bin/activate && pip install -r requirements.txt

# Copy env files (don't commit!)
cp ~/projects/myapp/.env ../project-feature/.env
```

---

## Pull Request Guidelines

### Before Opening PR

- [ ] All commits follow message convention
- [ ] Branch is up to date with target branch
- [ ] Tests pass locally
- [ ] Self-reviewed the diff
- [ ] Documentation updated

### PR Description Template

```markdown
## Summary
Brief description of changes.

## Changes
- Change 1
- Change 2

## Testing
How was this tested?

## Checklist
- [ ] Tests pass
- [ ] Docs updated
- [ ] No breaking changes
```

---

## Quick Reference

```bash
# Status & Info
git status
git log --oneline -10
git diff
git diff --staged

# Branching
git checkout -b feature/name
git checkout main
git branch -d feature/name

# Committing
git add <files>
git commit -m "type: msg"
git push
git push -u origin HEAD  # New branch

# Undoing
git reset HEAD <file>    # Unstage
git checkout -- <file>   # Discard changes
git reset --soft HEAD~1  # Undo commit, keep staged
git revert <commit>      # Revert pushed commit
```
