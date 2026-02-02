# Guardrails: Stop and Ask Before

> Actions that require explicit user approval. Never proceed autonomously on these.

---

## The Rule

When you encounter any of the following situations, **STOP** and ask for explicit confirmation before proceeding. Do not assume approval.

---

## Always Ask Before

### 1. Deleting Files or Directories

```bash
# STOP - ask first
rm -rf directory/
git rm file.js
```

**Why**: Deletions can be difficult to recover, especially if not yet committed.

**Ask like this**:
> "I need to delete `src/old-module/`. This will remove 15 files. Should I proceed?"

---

### 2. Changing Authentication/Authorization

Any changes to:
- Login/logout logic
- Session management
- JWT/token handling
- Password hashing
- Permission checks
- OAuth flows
- API key validation

**Why**: Security-critical code. Bugs here = security vulnerabilities.

**Ask like this**:
> "This change modifies the JWT token validation logic. Here's what I'm changing:
> [show diff]
> This could affect all authenticated users. Should I proceed?"

---

### 3. Modifying Database Schemas

Any changes to:
- Table creation/deletion
- Column additions/removals
- Index changes
- Foreign key modifications
- Migration files

**Why**: Schema changes can cause data loss and are hard to reverse in production.

**Ask like this**:
> "I need to add a migration that:
> - Adds column `status` to `orders` table
> - Creates index on `user_id`
> Here's the migration:
> [show migration]
> Should I proceed?"

---

### 4. Altering CI/CD Pipelines

Any changes to:
- `.github/workflows/`
- `Jenkinsfile`
- `bitbucket-pipelines.yml`
- Deployment scripts
- Build configurations

**Why**: Broken CI/CD can block all deployments and affect the whole team.

**Ask like this**:
> "I'm modifying the GitHub Actions workflow to add a new test job. This will affect all PRs. Here's the change:
> [show diff]
> Should I proceed?"

---

### 5. Refactoring Core Architecture

Any changes to:
- Application entry points
- Core module structure
- Dependency injection setup
- Database connection handling
- Event/message bus configuration
- Caching layer

**Why**: Architectural changes have wide-ranging impacts and need careful consideration.

**Ask like this**:
> "I'm proposing to refactor the API layer from Express middleware to a controller pattern. This will touch 25 files. Should I create a detailed plan first?"

---

### 6. Adding Dependencies with Security Implications

New packages that:
- Handle authentication (passport, auth0, etc.)
- Process user input (body parsers, sanitizers)
- Access filesystem or network
- Have native bindings
- Are not well-maintained (< 1000 weekly downloads, no recent commits)

**Why**: Dependencies are a common attack vector.

**Ask like this**:
> "I'd like to add `some-auth-package` for OAuth handling. It has:
> - 50k weekly downloads
> - Last updated 2 months ago
> - No known vulnerabilities
> Should I add it?"

---

### 7. Any Irreversible Operation

Operations that cannot be easily undone:
- Sending emails/notifications
- Calling external payment APIs
- Publishing to production
- Deleting cloud resources
- Truncating database tables

**Why**: Once done, these cannot be taken back.

---

### 8. Git Dangerous Operations

```bash
# NEVER do these without explicit approval
git push --force
git reset --hard (on pushed commits)
git rebase (on shared branches)
```

**Why**: These rewrite history and can cause data loss for the whole team.

**Safe alternatives**:
```bash
# Instead of force push
git push --force-with-lease  # Fails if remote changed

# Instead of hard reset
git revert <commit>  # Creates new commit, preserves history
```

---

## When You Can Proceed Autonomously

These actions are generally safe without explicit approval:

- Routine documentation updates
- Fixing typos or formatting
- Running tests
- Reading files to understand code
- Adding comments
- Standard commits following an approved plan
- Creating new files (that don't replace existing ones)
- Running linters and formatters

---

## The Approval Pattern

When you need to ask, use this format:

```markdown
## I need approval for: [category]

**What I want to do:**
[Brief description]

**Why:**
[Reasoning]

**Impact:**
[What this affects]

**The change:**
[Show code/command/diff]

**Should I proceed?**
```

---

## If In Doubt, Ask

The cost of asking is low (a few seconds).
The cost of not asking can be high (data loss, security issues, broken prod).

When uncertain, err on the side of asking.

---

*These guardrails exist to prevent costly mistakes. Respect them.*
