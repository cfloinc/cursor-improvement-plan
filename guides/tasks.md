# Task Management Guide

> Standards for tracking work, managing tasks, and reporting progress.

---

## Task File Location

All tasks live in `docs/tasks/` as individual markdown files.

**Naming**: `YYYY-MM-DD-brief-description.md`

**Examples**:
- `2026-01-15-user-authentication.md`
- `2026-01-16-payment-integration.md`
- `2026-01-17-fix-login-bug.md`

---

## Status Indicators

Use consistently across all task files:

| Emoji | Status | Meaning |
|-------|--------|---------|
| ⬚ | Not Started | Task hasn't begun |
| 🔄 | In Progress | Currently working on |
| ⏸️ | Blocked | Cannot proceed |
| ✅ | Complete | Done and verified |
| ⭐ | Current Focus | Active work item |
| ❌ | Cancelled | No longer needed |
| ⚠️ | Needs Attention | Issue or concern |

---

## Task Templates

### Quick Task (< 1 hour)

```markdown
# Task: [Brief Description]

**Status**: 🔄 In Progress
**Created**: YYYY-MM-DD

## Goal
What needs to be accomplished.

## Steps
- [ ] Step 1
- [ ] Step 2
- [ ] Step 3

## Notes
Any relevant context.
```

### Standard Task (Multi-step)

```markdown
# Task: [Descriptive Name]

**Status**: ⬚ Not Started | 🔄 In Progress | ⏸️ Blocked | ✅ Complete
**Created**: YYYY-MM-DD
**Priority**: 🟢 Low | 🟡 Medium | 🟠 High | 🔴 Critical

## Goal
Clear description of what needs to be accomplished.

## Context
Why is this task necessary? What problem does it solve?

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Tests written and passing
- [ ] Documentation updated

## Implementation Plan
- [ ] ⭐ Task 1: Description (current focus)
  - [ ] Subtask 1.1
  - [ ] Subtask 1.2
- [ ] Task 2: Description
- [ ] Task 3: Description

## Progress Log
### YYYY-MM-DD HH:MM
- What was done
- Decisions made
- Next steps

## Blockers
None currently.
```

---

## Task Workflow

### Starting a Task

1. Create task file from appropriate template
2. Fill in Goal, Context, and initial plan
3. Set status to 🔄 In Progress
4. Mark first step with ⭐

### During Work

1. Update plan with ✅ as items complete
2. Move ⭐ to current focus
3. Add Progress Log entries for milestones
4. Note any blockers immediately

### Completing a Task

1. Verify all acceptance criteria met
2. Mark all items with ✅
3. Set status to ✅ Complete
4. Add final Progress Log entry
5. Update `docs/CHANGELOG.md` if user-facing

### If Blocked

1. Mark blocking items with ⏸️
2. Document blocker in Blockers section
3. Include what's needed to unblock
4. Communicate to stakeholder

---

## Progress Log Guidelines

### What to Log

- Major milestones completed
- Decisions made and why
- Problems encountered and solutions
- Changes to the plan
- Blockers and how resolved

### Log Entry Format

```markdown
### 2026-01-15 14:30
- Completed user login endpoint
- Decided to use JWT over sessions (see DECISIONS.md)
- Encountered CORS issue, resolved by adding middleware
- Next: implement token refresh

### 2026-01-15 16:45
- Token refresh working
- ⏸️ Blocked on email service credentials
- Reached out to @admin for SendGrid access
```

### What NOT to Log

- Every small code change
- Routine commits
- Minor formatting fixes
- Details in commit messages

---

## When to Create Tasks

### Always Create a Task

- Features taking > 1 hour
- Bug fixes requiring investigation
- Refactoring work
- Infrastructure changes
- Anything with multiple steps

### Skip Task Files For

- Quick typo fixes
- Simple documentation updates
- Routine maintenance
- Single-commit changes

---

## Progress Example

```markdown
## Implementation Plan
- [✅] Task 1: Set up project structure
  - [✅] Create docs/ folder
  - [✅] Initialize git repository
- [🔄] Task 2: Implement authentication
  - [✅] Design auth flow
  - [⭐] Implement login endpoint (CURRENT)
  - [ ] Add JWT token generation
- [ ] Task 3: Add user management
```

---

## Organizing Tasks

### Active Tasks

Keep in `docs/tasks/` with current date prefixes.

### Completed Tasks

Options:
1. Move to `docs/tasks/archive/` monthly
2. Delete after 30 days (history in git)
3. Keep all (if storage not a concern)

### Finding Tasks

```bash
# List all tasks
ls docs/tasks/

# Find in-progress tasks
grep -l "In Progress" docs/tasks/*.md

# Find blocked tasks
grep -l "Blocked" docs/tasks/*.md

# Find by keyword
grep -r "authentication" docs/tasks/
```

---

## Task Review Checklist

Before marking complete:

- [ ] All acceptance criteria checked off
- [ ] All subtasks marked ✅
- [ ] Final Progress Log entry added
- [ ] CHANGELOG updated if user-facing
- [ ] Related documentation updated
- [ ] Tests passing
- [ ] Code committed and pushed
