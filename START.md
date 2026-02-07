# START HERE

> **Drop this file into any new Cursor project.** The agent will read it and set everything up.

---

## Agent: Do This Now

When you read this file in a new project, **immediately run these setup steps**:

### 1. Create Project Structure

```bash
mkdir -p docs/tasks docs/notes src tests .cursor/rules
```

### 2. Copy Core Files

```bash
# Copy AGENT.md (the main reference file)
cp ~/Cursor/cursor-starter-loop/AGENT.md ./AGENT.md

# Copy documentation templates
cp ~/Cursor/cursor-starter-loop/templates/project/PROJECT.md.template docs/PROJECT.md
cp ~/Cursor/cursor-starter-loop/templates/project/ARCHITECTURE.md.template docs/ARCHITECTURE.md
cp ~/Cursor/cursor-starter-loop/templates/project/SETUP.md.template docs/SETUP.md
cp ~/Cursor/cursor-starter-loop/templates/project/DECISIONS.md.template docs/DECISIONS.md
cp ~/Cursor/cursor-starter-loop/templates/project/CHANGELOG.md.template docs/CHANGELOG.md
cp ~/Cursor/cursor-starter-loop/templates/project/README.md.template README.md
cp ~/Cursor/cursor-starter-loop/templates/project/.gitignore.template .gitignore

# Copy agent self-learning scratchpad
cp ~/Cursor/cursor-starter-loop/templates/project/SCRATCHPAD.md.template SCRATCHPAD.md
```

### 3. Create .env.example

```bash
cat > .env.example << 'EOF'
# Environment Variables
# Copy to .env and fill in values. NEVER commit .env!

APP_NAME="MyProject"
APP_ENV=local
APP_DEBUG=true

# Database (if needed)
# DB_HOST=localhost
# DB_PORT=5432
# DB_DATABASE=myproject
# DB_USERNAME=
# DB_PASSWORD=

# External Services (get from 1Password via ~/.cursor/credentials/UNIVERSAL_ACCESS.md)
# API_KEY=
EOF
```

### 4. Ask User for Stack

**Ask the user**: "What tech stack is this project? Options: `python`, `node`, `nextjs`, `laravel`, `swift`, or `generic`"

Then copy the appropriate rules:

```bash
# For Python:
cp ~/Cursor/cursor-starter-loop/templates/stacks/python/python.md .cursor/rules/

# For Node:
cp ~/Cursor/cursor-starter-loop/templates/stacks/node/node.md .cursor/rules/

# For Next.js:
cp ~/Cursor/cursor-starter-loop/templates/stacks/nextjs/nextjs.md .cursor/rules/

# For Laravel:
cp ~/Cursor/cursor-starter-loop/templates/stacks/laravel/laravel.md .cursor/rules/

# For Swift/macOS:
cp ~/Cursor/cursor-starter-loop/templates/stacks/swift/swift.md .cursor/rules/

# For Generic (no specific stack):
cp ~/Cursor/cursor-starter-loop/core/COMMANDMENTS.md .cursor/rules/core.md
```

### 5. Initialize Git

```bash
git init
git add .
git commit -m "chore: initial project setup from Cursor Starter Kit"
```

### 6. Customize Templates

Replace placeholders in the copied files:
- `[Project Name]` → actual project name (ask user if not obvious)
- `YYYY-MM-DD` → today's date

### 7. Report What Was Created

Tell the user:
```
✓ Project structure created
✓ AGENT.md copied (your AI reference guide)
✓ SCRATCHPAD.md created (agent self-learning log)
✓ Documentation templates in docs/
✓ Stack rules in .cursor/rules/
✓ Git initialized

Next steps:
1. Fill in docs/PROJECT.md with your project details
2. Review .cursor/rules/ and customize
3. Delete this START.md file
4. Start building!
```

### 8. Delete This File

```bash
rm START.md
```

---

## The 10 Commandments (Quick Reference)

1. **Read before writing** — Understand existing code first
2. **Small commits, often** — One logical change per commit
3. **Document the "why"** — Comments explain reasoning
4. **Test your changes** — Run tests before committing
5. **Ask before breaking changes** — Get approval for architecture/auth/DB/CI
6. **Use conventional commits** — `feat:`, `fix:`, `docs:`, etc.
7. **Keep secrets out of git** — Use `.env`, verify `.gitignore`
8. **Update docs with code** — Keep them in sync
9. **Progress over perfection** — Ship, then iterate
10. **Communicate blockers early** — Don't spin; ask

---

## Credentials

For any external service, read: `~/.cursor/credentials/UNIVERSAL_ACCESS.md`

```bash
# 1Password CLI
eval $(op signin)
op item get "Item Name" --vault Cursor --fields credential
```

---

## Full Reference

After setup, read `AGENT.md` for complete guidelines.

---

*Cursor Starter Kit v3.0 — https://github.com/cfloinc/cursor-starter-kit*
