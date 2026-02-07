# IMPROVE THIS PROJECT

> **Drop this file into any existing Cursor project.** The agent will read it,
> audit what's there, and automatically add everything that's missing.

---

## CRITICAL RULES

**ALL changes happen in THIS project directory only.**

- DO NOT modify, read from, copy from, or reference any other repository or directory.
- DO NOT access `~/Cursor/cursor-improvement-plan/` or any external source.
- Every file created below has its FULL CONTENT provided inline in this document.
- Create files using the content provided here, directly in this project.
- This document is 100% self-contained. You need nothing else.

---

## Agent: Do This Now

When you read this file in a project, **immediately run this improvement workflow**.
Never overwrite existing files -- only add what's missing.

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

### 4. Add Missing Files

For each file below, **skip if it already exists in THIS project**. Never overwrite.
Create each file using the exact content provided in the appendix sections below.

| File | Content Source | Skip If Exists |
|------|---------------|----------------|
| `SCRATCHPAD.md` | [Appendix A](#appendix-a-scratchpadmd) | Yes |
| `docs/PROJECT.md` | [Appendix B](#appendix-b-docsprojectmd) | Yes |
| `docs/ARCHITECTURE.md` | [Appendix C](#appendix-c-docsarchitecturemd) | Yes |
| `docs/SETUP.md` | [Appendix D](#appendix-d-docssetupmd) | Yes |
| `docs/DECISIONS.md` | [Appendix E](#appendix-e-docsdecisionsmd) | Yes |
| `docs/CHANGELOG.md` | [Appendix F](#appendix-f-docschangelogmd) | Yes |

### 5. Improve .gitignore

If `.gitignore` does not exist, create it using [Appendix G](#appendix-g-gitignore).

If `.gitignore` already exists, ensure these critical security patterns are present
(append them if missing):

```
.env
.env.*
!.env.example
*.key
*.pem
*.p12
```

### 6. Add .env.example

If `.env.example` does not exist, create it with this content (replace `PROJECT_NAME`
with the actual directory name of this project):

```
# =============================================================================
# PROJECT_NAME Environment Variables
# =============================================================================
# Copy this file to .env and fill in the values
# NEVER commit .env to git!
# =============================================================================

# Application
APP_NAME="PROJECT_NAME"
APP_ENV=local
APP_DEBUG=true

# Database (if needed)
# DB_HOST=127.0.0.1
# DB_PORT=5432
# DB_DATABASE=PROJECT_NAME
# DB_USERNAME=
# DB_PASSWORD=

# External Services
# API_KEY=
# API_SECRET=
```

### 7. Add Stack-Specific Cursor Rules

If `.cursor/rules/` is empty, generate a rules file for the detected stack.
Create `.cursor/rules/[stack].md` with rules appropriate for the stack:

**For Python projects** -- include rules about: black formatting, ruff linting, type hints
required on all functions, pytest for testing, snake_case naming, import ordering
(stdlib / third-party / local), repository pattern, no raw SQL in handlers.

**For Node/TypeScript projects** -- include rules about: ESLint + Prettier, TypeScript
strict mode, named exports preferred, camelCase for variables/functions, PascalCase
for classes/types, Jest or Vitest for testing, async/await over callbacks.

**For Next.js projects** -- include rules about: App Router conventions, server
components by default, "use client" only when needed, server actions for mutations,
Tailwind CSS, next/image and next/link usage, metadata API for SEO.

**For Laravel projects** -- include rules about: PSR-12 coding style, Eloquent ORM,
form request validation, resource controllers, Blade components, Pest or PHPUnit
for testing, artisan commands.

**For Swift projects** -- include rules about: Swift 6.0+, structured concurrency,
SwiftUI preferred, MVVM architecture, XCTest for testing, access control defaults.

**For Generic projects** -- create `.cursor/rules/core.md` with the 10 Commandments
(listed in Appendix H) and guardrails.

### 8. Customize Templates

Replace placeholders in any newly created files (not pre-existing ones):
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

After reporting, delete `IMPROVEMENT.md` from this project -- its job is done.

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
- Overwrites existing files
- Modifies existing code
- Changes git history
- Removes anything (except this IMPROVEMENT.md file at the end)
- Touches any other repository or directory

It **only**:
- Creates missing directories in THIS project
- Adds missing documentation files in THIS project
- Appends critical patterns to `.gitignore` (if they're missing)
- Creates template files that can be customized

---

## Appendix A: SCRATCHPAD.md

Create `SCRATCHPAD.md` in the project root with this exact content:

~~~markdown
# SCRATCHPAD -- Agent Self-Learning Log

> **Purpose**: Track agent mistakes, user corrections, what worked, what didn't,
> and user preferences so the agent improves over time.
>
> **Update this file at the end of every session.**

---

## Quick Reference (TL;DR)

> Read this first at the start of every session. The most important current
> preferences and corrections, distilled from the session log.

*(Empty -- populate as sessions accumulate.)*

---

## Session Start Checklist

Run through this at the beginning of each session:

- [ ] Read this scratchpad (especially Quick Reference and Active Rules)
- [ ] Check Active Rules -- am I following them?
- [ ] Check Open Questions -- anything relevant to this session?

---

## Session Count

| Metric | Value |
|--------|-------|
| Total sessions logged | 0 |
| Last updated | -- |

---

## Session Log

> Append newest entries at the top.

*(No sessions logged yet.)*

<!-- Template for new entries (copy this block and fill in):

### Session [N] -- YYYY-MM-DD

**Context**: What this session was about.

**What I got wrong**:
-

**What you corrected**:
-

**What worked**:
-

**What didn't**:
-

**What you liked**:
-

**Actionable changes for next session**:
-

-->

---

## Preferences and Corrections (rolling)

> Merged, deduplicated list of recurring user preferences and corrections
> extracted from the session log. Keep this concise.

*(Empty -- populate from session log entries.)*

---

## What You Like (rolling)

> Positive signals tracked separately so the agent knows what behaviors to
> repeat.

*(Empty -- populate from session log entries.)*

---

## Mistake Patterns (rolling)

> Recurring mistakes summarized with frequency, severity, root cause, and
> mitigation.

*(No patterns identified yet.)*

<!-- Template for new patterns:

| Pattern | Freq | Severity | Root Cause | Mitigation |
|---------|------|----------|------------|------------|
| [description] | [N] | low/med/high | [why it happens] | [how to prevent it] |

-->

---

## Open Questions

> Parking lot for unresolved items to watch for across sessions.

*(None yet.)*

---

## Learning Framework (self-updating)

Apply this 5-step process during each scratchpad update:

1. **Observe** -- Collect concrete examples from the session log.
2. **Classify** -- Tag each as one of:
   - requirement miss
   - assumption error
   - tool misuse
   - output format mismatch
   - scope overreach
   - under-communication
   - over-communication
   - other
3. **Decide** -- Pick 1-3 specific, testable changes to reduce repeats.
4. **Apply** -- Use the changes in the next session.
5. **Review** -- Check if the changes reduced errors; revise if not.

---

## Active Rules (current period)

> The 1-3 concrete behavior rules currently in effect, decided from the
> framework above. Review and rotate regularly.

*(No active rules yet -- will be populated after first session review.)*

---

## Review Log

> Track each Active Rule's lifecycle.

| Rule | Added | Last Reviewed | Status |
|------|-------|---------------|--------|
| *(none yet)* | -- | -- | -- |

<!-- Status values: new / working / revised / retired -->
~~~

---

## Appendix B: docs/PROJECT.md

Create `docs/PROJECT.md` with this content:

~~~markdown
# [Project Name]

> **Status**: Active
> **Last Updated**: YYYY-MM-DD

---

## Purpose

What problem does this solve? Why does it exist?

[1-2 paragraphs explaining the core value proposition]

---

## Goals

- [ ] Primary goal 1
- [ ] Primary goal 2
- [ ] Primary goal 3

---

## Tech Stack

| Technology | Purpose | Why Chosen |
|------------|---------|------------|
| [Language] | Runtime | [Reason] |
| [Framework] | Web framework | [Reason] |
| [Database] | Data storage | [Reason] |

---

## Architecture Overview

[Brief description - link to ARCHITECTURE.md for details]

---

## Quick Start

```bash
# Clone
git clone <repo-url>
cd [project-name]

# Setup
cp .env.example .env

# Install & Run
[install command]
[run command]
```

See [SETUP.md](SETUP.md) for detailed setup instructions.

---

## Project Structure

```
/
├── src/                 # Application source code
├── tests/               # Test files
├── docs/                # Documentation
│   ├── PROJECT.md       # This file
│   ├── ARCHITECTURE.md  # System design
│   ├── SETUP.md         # Environment setup
│   ├── DECISIONS.md     # Architecture decisions
│   ├── CHANGELOG.md     # Version history
│   ├── tasks/           # Task tracking
│   └── notes/           # Learning notes
├── .cursor/rules/       # AI rules
├── .env.example         # Environment template
└── README.md            # Quick start
```

---

## Links

- **Repository**: [URL]
- **Production**: [URL]
- **Staging**: [URL]
~~~

---

## Appendix C: docs/ARCHITECTURE.md

Create `docs/ARCHITECTURE.md` with this content:

~~~markdown
# Architecture

> **Last Updated**: YYYY-MM-DD

---

## System Overview

[High-level description of the system architecture]

---

## Components

### Component A: [Name]

**Purpose**: What this component does

**Location**: `src/[path]`

**Dependencies**:
- [Dependency 1]
- [Dependency 2]

---

## Data Flow

1. Client sends request to API endpoint
2. Middleware validates authentication
3. Controller processes request
4. Service layer executes business logic
5. Repository interacts with database
6. Response returned to client

---

## Integration Points

| Service | Purpose | Auth Method |
|---------|---------|-------------|
| [Service 1] | [Purpose] | API Key |
| [Service 2] | [Purpose] | OAuth |

---

## Security Considerations

- [Authentication method used]
- [Authorization / permission model]
- [Data protection approach]

---

## Deployment

| Environment | URL | Purpose |
|-------------|-----|---------|
| Development | localhost | Local dev |
| Staging | [URL] | Testing |
| Production | [URL] | Live |
~~~

---

## Appendix D: docs/SETUP.md

Create `docs/SETUP.md` with this content:

~~~markdown
# Environment Setup

> **Last Updated**: YYYY-MM-DD

---

## Prerequisites

- [ ] [Language/Runtime] v[version]+
- [ ] [Package Manager] v[version]+
- [ ] Git

---

## Quick Start

```bash
# 1. Clone the repository
git clone [repo-url]
cd [project-name]

# 2. Copy environment file
cp .env.example .env

# 3. Install dependencies
[install command]

# 4. Run the application
[run command]
```

---

## Environment Variables

Copy `.env.example` to `.env`:

| Variable | Description | How to Get |
|----------|-------------|------------|
| `DATABASE_URL` | Database connection | Local setup or cloud |
| `API_KEY` | External API key | Provider dashboard |

---

## Common Issues

### Database Connection Failed

1. Check database is running
2. Verify `DATABASE_URL` in `.env`
3. Check network/firewall settings

### Missing Environment Variables

1. Ensure `.env` exists
2. Compare with `.env.example` for missing vars
3. Restart the application
~~~

---

## Appendix E: docs/DECISIONS.md

Create `docs/DECISIONS.md` with this content:

~~~markdown
# Architecture Decision Records

> Record significant technical decisions and their context.

---

## Template

When adding a new decision, copy this template:

```
## [YYYY-MM-DD] Decision Title

**Status**: Proposed | Accepted | Deprecated | Superseded

**Context**: What situation required a decision?

**Options Considered**:
1. **Option A** - Pro: benefit / Con: drawback
2. **Option B** - Pro: benefit / Con: drawback

**Decision**: [Chosen option]

**Rationale**: Why this option best fits our needs.

**Consequences**: What this enables or constrains going forward.
```

---

## Decisions

<!-- Add new decisions below this line -->
~~~

---

## Appendix F: docs/CHANGELOG.md

Create `docs/CHANGELOG.md` with this content:

~~~markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

---

## [Unreleased]

### Added
- Initial project structure

### Changed

### Fixed

### Removed

---

<!--
Categories:
- Added: New features
- Changed: Changes to existing functionality
- Deprecated: Features to be removed
- Removed: Features removed
- Fixed: Bug fixes
- Security: Security improvements
-->
~~~

---

## Appendix G: .gitignore

Create `.gitignore` with this content:

~~~
# Secrets - NEVER commit these
.env
.env.*
!.env.example
*.key
*.pem
*.p12
*.pfx
credentials.json
secrets.json

# OS Files
.DS_Store
.DS_Store?
._*
Thumbs.db

# IDE / Editor
.vscode/
!.vscode/settings.json
!.vscode/extensions.json
.idea/
*.swp
*.swo
*~

# Dependencies
node_modules/
vendor/
venv/
.venv/
__pycache__/
*.pyc

# Build Output
dist/
build/
out/
.next/
*.egg-info/

# Test & Coverage
coverage/
.coverage
htmlcov/
.nyc_output/
.pytest_cache/

# Logs
logs/
*.log
npm-debug.log*

# Temporary Files
tmp/
temp/
*.tmp
*.bak

# Database
*.sqlite
*.sqlite3
*.db
~~~

---

## Appendix H: The 10 Commandments (for generic rules)

Use these when creating `.cursor/rules/core.md` for projects with no specific stack:

1. **Read before writing** -- Understand existing code and docs first
2. **Small commits, often** -- One logical change per commit, push immediately
3. **Document the "why"** -- Comments explain reasoning, not obvious behavior
4. **Test your changes** -- Run relevant tests before committing
5. **Ask before breaking changes** -- Stop for approval on architecture, auth, DB schema, CI/CD
6. **Use conventional commits** -- `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
7. **Keep secrets out of git** -- Use `.env` files, verify `.gitignore` works
8. **Update docs with code** -- If behavior changes, docs change too
9. **Progress over perfection** -- Working code now beats perfect code never
10. **Communicate blockers early** -- Don't spin; ask for help

**Guardrails -- Stop and ask the user before**:
- Deleting files or directories
- Changing authentication/authorization logic
- Modifying database schemas
- Altering CI/CD pipelines
- Refactoring core architecture
- Adding dependencies with security implications
- Any irreversible operation
- Force pushing to any branch

---

*Cursor Improvement Plan v4.0 -- https://github.com/cfloinc/cursor-improvement-plan*
