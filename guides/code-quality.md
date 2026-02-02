# Code Quality Guide

> Standards for writing maintainable code and comprehensive tests.

---

## The Big Five Principles

1. **Readability** — Code is read more than written. Optimize for understanding.
2. **Simplicity** — Prefer straightforward solutions over clever ones.
3. **Modularity** — Single responsibility. Small, focused functions and modules.
4. **DRY** — Don't Repeat Yourself. Extract common patterns.
5. **YAGNI** — You Aren't Gonna Need It. Don't build for hypotheticals.

---

## Naming Conventions

```python
# Variables: descriptive, lowercase_with_underscores (Python) or camelCase (JS)
user_count = 42
activeUsers = 42

# Functions: verb + noun, describes action
def calculate_total(items):
def fetchUserProfile(userId):

# Classes: PascalCase, noun
class PaymentProcessor:
class UserRepository:

# Constants: SCREAMING_SNAKE_CASE
MAX_RETRY_ATTEMPTS = 3
DEFAULT_TIMEOUT_MS = 5000

# Booleans: is_, has_, can_, should_
is_active = True
has_permission = False
can_edit = user.role == 'admin'
```

---

## Functions

### Good: Small, Single Purpose

```python
def validate_email(email: str) -> bool:
    """Check if email format is valid."""
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))

def send_welcome_email(user: User) -> None:
    """Send welcome email to newly registered user."""
    if not validate_email(user.email):
        raise ValueError(f"Invalid email: {user.email}")
    # ... send email
```

### Bad: Does Too Many Things

```python
def process_user(data):
    # validates, creates, sends email, logs, updates stats...
    # 200 lines later...
    pass
```

---

## Error Handling

### Good: Specific Exceptions, Clear Messages

```python
def get_user(user_id: int) -> User:
    user = db.query(User).filter_by(id=user_id).first()
    if not user:
        raise UserNotFoundError(f"User {user_id} not found")
    return user

# Handle expected errors, let unexpected bubble up
try:
    user = get_user(user_id)
except UserNotFoundError:
    return {"error": "User not found"}, 404
# Don't catch Exception broadly
```

### Bad: Swallowing Errors

```python
try:
    risky_operation()
except:
    pass  # Silent failure - debugging nightmare
```

---

## Configuration

### Rules

1. **No hardcoded values** — Use config files or environment variables
2. **Validate on startup** — Fail fast if config is invalid
3. **Document all options** — Every config value needs explanation
4. **Provide sensible defaults** — Work out of the box when possible

### Pattern

```python
import os
from dataclasses import dataclass

@dataclass
class Config:
    database_url: str = os.getenv("DATABASE_URL", "sqlite:///dev.db")
    api_timeout_seconds: int = int(os.getenv("API_TIMEOUT", "30"))
    enable_feature: bool = os.getenv("ENABLE_FEATURE", "false").lower() == "true"
    
    def validate(self) -> None:
        if not self.database_url:
            raise ValueError("DATABASE_URL is required")

config = Config()
config.validate()
```

---

## Testing

### Test Structure

```
tests/
├── unit/                    # Fast, isolated tests
│   ├── test_user.py
│   └── test_payment.py
├── integration/             # Tests across modules
│   └── test_checkout_flow.py
├── fixtures/                # Shared test data
└── conftest.py              # Shared fixtures
```

### Test Naming

Use descriptive names that explain what's being tested:

```python
# Good: Clear what's tested and expected outcome
def test_login_with_valid_credentials_returns_token():
def test_login_with_invalid_password_returns_401():
def test_calculate_shipping_raises_error_for_negative_weight():

# Bad: Vague
def test_login():
def test_shipping():
```

### Test Pattern (Arrange-Act-Assert)

```python
def test_calculate_order_total_with_discount():
    # Arrange - Set up test data
    order = Order(items=[
        Item(price=100, quantity=2),
        Item(price=50, quantity=1),
    ])
    discount = Discount(percent=10)
    
    # Act - Perform the action
    total = calculate_order_total(order, discount)
    
    # Assert - Verify the result
    assert total == 225  # (200 + 50) * 0.9
```

### What to Test

| Test Type | What to Cover |
|-----------|---------------|
| **Unit** | Individual functions, edge cases, error conditions |
| **Integration** | Module interactions, database, API calls |
| **E2E** | Critical user journeys |

### Coverage Guidelines

- High coverage on business logic
- Don't chase 100% — some code isn't worth testing
- Always test: edge cases, error paths, security-critical code
- Skip: simple getters/setters, framework boilerplate

---

## Dependencies

### Before Adding a Dependency

1. **Is it necessary?** Can you write this in < 100 lines?
2. **Is it maintained?** Check last commit, open issues
3. **Is it secure?** Check for known vulnerabilities
4. **What's the size?** Especially important for frontend
5. **What's the license?** Compatible with your project?

### Version Management

```bash
# Lock exact versions in production
npm install --save-exact lodash@4.17.21

# Audit regularly
npm audit
pip-audit
```

---

## Code Review Checklist

### Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases handled
- [ ] Error cases handled gracefully
- [ ] No obvious bugs

### Security
- [ ] No hardcoded secrets
- [ ] Input validated and sanitized
- [ ] SQL/injection attacks prevented
- [ ] Auth/authz correct

### Quality
- [ ] Follows project style conventions
- [ ] No unnecessary complexity
- [ ] No code duplication
- [ ] Functions are small and focused

### Testing
- [ ] New code has tests
- [ ] Edge cases tested
- [ ] All tests pass
- [ ] No flaky tests introduced

### Documentation
- [ ] Public functions documented
- [ ] Complex logic has comments
- [ ] README/docs updated if needed

---

## Refactoring Guidelines

### When to Refactor

- Before adding a feature that touches messy code
- When you find yourself copying code
- When code is hard to understand
- When tests are hard to write

### When NOT to Refactor

- Just because code "looks old"
- Without tests to verify behavior
- Close to a deadline
- Without understanding the code first

### Safe Refactoring Process

1. Ensure comprehensive tests exist
2. Make one small change
3. Run tests
4. Commit
5. Repeat

---

## Performance Basics

### Measure First

```python
# Don't guess — profile
import cProfile
cProfile.run('slow_function()')

# Or use timing
import time
start = time.time()
result = slow_function()
print(f"Took {time.time() - start:.2f}s")
```

### Common Optimizations

1. **Database**: Add indexes, reduce N+1 queries, pagination
2. **Caching**: Cache expensive computations and API calls
3. **Algorithms**: Use appropriate data structures
4. **I/O**: Batch operations, use async for concurrent I/O

### Premature Optimization Warning

Optimize only when:
- You have measured a performance problem
- The optimization is in a hot path
- The benefit outweighs the complexity cost
