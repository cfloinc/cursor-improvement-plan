# Project Initialization Skill

> Interactive wizard for scaffolding new projects or adding structure to existing ones.

---

## When to Use

Use this skill when:
- Starting a new project from scratch
- Adding the Starter Loop structure to an existing project
- Setting up a project with proper documentation and rules

---

## Instructions

### Step 1: Detect Current State

First, check what exists in the current directory:

```bash
ls -la
ls docs/ 2>/dev/null
ls .cursor/rules/ 2>/dev/null
cat package.json 2>/dev/null | head -5
cat requirements.txt 2>/dev/null | head -5
cat composer.json 2>/dev/null | head -5
```

### Step 2: Ask Questions

Based on what you found, ask the user using the AskQuestion tool:

**If empty directory (new project):**
1. What is the project name?
2. What tech stack? (python, node, nextjs, laravel, or generic)
3. Initialize git repository? (yes/no)

**If existing project without docs:**
1. Add documentation structure? (yes/no)
2. Add .cursorrules? (yes/no)
3. What tech stack for rules? (detect from package.json/requirements.txt or ask)

**If existing project with docs:**
1. Which components need updating? (docs, rules, templates)

### Step 3: Create Structure

**For new projects:**

```bash
# Create directory structure
mkdir -p docs/tasks docs/notes src tests .cursor/rules

# Copy core templates
STARTER="~/Cursor/cursor-starter-loop"
cp $STARTER/templates/project/PROJECT.md.template docs/PROJECT.md
cp $STARTER/templates/project/ARCHITECTURE.md.template docs/ARCHITECTURE.md
cp $STARTER/templates/project/SETUP.md.template docs/SETUP.md
cp $STARTER/templates/project/DECISIONS.md.template docs/DECISIONS.md
cp $STARTER/templates/project/CHANGELOG.md.template docs/CHANGELOG.md
cp $STARTER/templates/project/README.md.template README.md
cp $STARTER/templates/project/.gitignore.template .gitignore

# Copy stack-specific rules
cp $STARTER/templates/stacks/[STACK]/*.md .cursor/rules/
```

**For existing projects:**

```bash
# Only create what's missing
mkdir -p docs/tasks docs/notes .cursor/rules

# Copy only missing templates
# Check each file before copying
```

### Step 4: Customize Templates

Replace placeholders in all templates:
- `[Project Name]` → actual project name
- `YYYY-MM-DD` → current date
- `[STACK]` → detected/selected stack

### Step 5: Create .env.example

```bash
cat > .env.example << 'EOF'
# =============================================================================
# [Project Name] Environment Variables
# =============================================================================
# Copy to .env and fill in values. NEVER commit .env!
# =============================================================================

# Application
APP_NAME="[project-name]"
APP_ENV=local
APP_DEBUG=true

# Database (if needed)
# DB_HOST=localhost
# DB_PORT=5432
# DB_DATABASE=[project-name]
# DB_USERNAME=
# DB_PASSWORD=

# External Services (get from 1Password)
# API_KEY=
EOF
```

### Step 6: Initialize Git (if requested)

```bash
git init
git add .
git commit -m "chore: initial project setup from starter loop"
```

### Step 7: Validate Setup

Run the validation script:

```bash
~/Cursor/cursor-starter-loop/tools/validate.sh .
```

### Step 8: Report Results

Summarize what was created:

```markdown
## Project Setup Complete

**Created:**
- docs/PROJECT.md
- docs/ARCHITECTURE.md
- docs/SETUP.md
- docs/DECISIONS.md
- docs/CHANGELOG.md
- .cursor/rules/[stack].md
- .gitignore
- .env.example
- README.md

**Next Steps:**
1. Fill in docs/PROJECT.md with project details
2. Review and customize .cursor/rules/
3. Set up development environment
4. Run: cursor . (to open in Cursor)
```

---

## Stack Detection

If not specified, detect from existing files:

| File | Stack |
|------|-------|
| `package.json` with "next" | nextjs |
| `package.json` | node |
| `requirements.txt` or `pyproject.toml` | python |
| `composer.json` | laravel |
| None of the above | generic |

---

## Validation Criteria

After setup, verify:
- [ ] docs/ directory exists with core files
- [ ] .cursor/rules/ exists with at least one rule file
- [ ] .gitignore exists and includes .env
- [ ] .env.example exists
- [ ] README.md exists

---

## Example Interaction

**User:** "Set up this new project"

**Agent:**
1. Runs ls to check current state
2. Uses AskQuestion to get project name and stack
3. Creates directory structure
4. Copies and customizes templates
5. Initializes git
6. Runs validation
7. Reports what was created and next steps
