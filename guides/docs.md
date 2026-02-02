# Documentation Guide

> Standards for documenting code, features, and decisions.

---

## Core Principle

**Document the "why", not the "what".**

Code shows what happens; documentation explains why it was built this way.

---

## .cursorrules Best Practices

Your AI rules file is your highest-leverage documentation artifact.

### The Self-Improvement Loop

After every correction from the user:

> "Update your .cursorrules so you don't make that mistake again."

The AI is excellent at writing rules for itself. Let it.

### Iterate Ruthlessly

| Frequency | Action |
|-----------|--------|
| After each correction | Add specific rule to prevent recurrence |
| Weekly | Review rules, remove unused ones |
| Monthly | Measure error rate, strengthen weak areas |

### What to Include

```markdown
# Project Rules

## Code Style
- Use functional components with hooks (not class components)
- Prefer named exports over default exports
- Error messages must include error code

## Architecture Decisions
- All API calls go through src/api/ wrapper
- State management: Zustand for global, useState for local

## Common Mistakes (Don't Repeat)
- Always null-check user.profile before accessing nested props
- The payment webhook expects amount in cents, not dollars
```

### Using .cursor/rules/ Folder

For larger projects, use multiple rule files:

```
.cursor/rules/
├── core.md           # Project-wide rules (always applied)
├── api.md            # Rules for API development
├── frontend.md       # Rules for frontend code
├── testing.md        # Rules for writing tests
└── database.md       # Rules for DB operations
```

---

## Project Documentation

### Required Files

| File | Purpose | When to Update |
|------|---------|----------------|
| `docs/PROJECT.md` | Project purpose, goals, tech stack | Major scope changes |
| `docs/ARCHITECTURE.md` | System design, data flow | Structural changes |
| `docs/SETUP.md` | Environment setup | Dependencies change |
| `docs/DECISIONS.md` | Architecture Decision Records | Significant decisions |
| `docs/CHANGELOG.md` | User-facing changes | Every release |
| `README.md` | Quick start | Onboarding changes |

### Maintain a Notes Directory

For complex projects, update `docs/notes/` after every PR:

```
docs/notes/
├── 2026-01-28-auth-refactor.md
├── 2026-01-30-api-patterns.md
└── 2026-02-01-edge-cases.md
```

Then reference in your rules:
```markdown
Before starting work, read docs/notes/ for project-specific learnings.
```

---

## Code Documentation

### File Headers

Every file should explain its purpose:

```javascript
/**
 * User authentication middleware
 * 
 * Validates JWT tokens and attaches user context to requests.
 * Used by all protected API routes.
 */
```

### Function Documentation

Document public functions with:
- What it does (brief)
- Parameters with types
- Return value
- Errors thrown
- Example for complex functions

```python
def calculate_shipping(weight: float, destination: str, express: bool = False) -> Decimal:
    """
    Calculate shipping cost based on package weight and destination.
    
    Args:
        weight: Package weight in kg. Must be positive.
        destination: ISO 3166-1 alpha-2 country code.
        express: Use express shipping (2-3 days vs 5-7 days).
    
    Returns:
        Shipping cost in USD as Decimal.
    
    Raises:
        ValueError: If weight <= 0 or destination is invalid.
        ShippingUnavailableError: If no carriers serve the destination.
    
    Example:
        >>> calculate_shipping(2.5, "US", express=True)
        Decimal('24.99')
    """
```

### Inline Comments

Use sparingly. Explain **why**, not **what**:

```python
# Bad - describes what (obvious)
# Increment counter by 1
counter += 1

# Good - explains why
# Using exponential backoff to avoid overwhelming the API during outages
delay = min(base_delay * (2 ** attempt), max_delay)
```

### TODO Comments

Include context and ownership:

```python
# TODO(username): Refactor to use batch API when available (Issue #123)
# TODO: Handle rate limiting - currently fails silently
```

---

## Decision Records

When making significant decisions, add to `docs/DECISIONS.md`:

```markdown
## [2026-01-15] JWT vs Session Authentication

**Context**: Needed to choose authentication approach for the API.

**Options Considered**:
1. **JWT Tokens**
   - Pro: Stateless, scales easily
   - Con: Can't invalidate without blocklist
   
2. **Server Sessions**
   - Pro: Easy to invalidate
   - Con: Requires session store, doesn't scale as easily

**Decision**: JWT Tokens

**Rationale**: Our API is stateless and we expect to scale horizontally. Token refresh handles most invalidation needs.

**Consequences**: Need to implement token refresh and consider blocklist for logout.
```

### What Warrants a Decision Record

- Database or storage technology choices
- Framework or major library selections
- Authentication/authorization approaches
- API design patterns
- Infrastructure architecture
- Breaking changes to public interfaces

---

## CHANGELOG Format

Follow [Keep a Changelog](https://keepachangelog.com/):

```markdown
# Changelog

## [Unreleased]

### Added
- New feature X (#123)

### Changed
- Updated behavior of Y

### Fixed
- Bug in Z that caused...

### Removed
- Deprecated API endpoint

## [1.2.0] - 2026-01-15

### Added
- User profile page
- Password reset flow
```

---

## Templates

### PROJECT.md

```markdown
# [Project Name]

> **Status**: Active
> **Last Updated**: YYYY-MM-DD

## Purpose
What problem does this solve? Why does it exist?

## Goals
- Primary goal 1
- Primary goal 2

## Tech Stack
| Technology | Purpose | Why Chosen |
|------------|---------|------------|
| Node.js | Runtime | Team expertise |
| PostgreSQL | Database | ACID, JSON support |

## Quick Start
Link to SETUP.md
```

### ARCHITECTURE.md

```markdown
# Architecture

## System Overview
[Diagram or description]

## Components
### Component A
- Purpose:
- Dependencies:
- Data flow:

## Data Flow
1. Request enters at...
2. Processed by...
3. Stored in...

## Integration Points
- External API X: purpose, auth method
```

---

## Documentation Checklist

Before committing:

- [ ] Code has inline comments explaining "why"
- [ ] Public functions have parameter/return documentation
- [ ] Complex modules have companion docs if needed
- [ ] `CHANGELOG.md` updated for user-facing changes
- [ ] `DECISIONS.md` updated for architectural choices
- [ ] `README.md` updated if setup/usage changed
