# Python Project Rules

## Stack
- Python 3.12+
- Framework: FastAPI / Django / Flask (customize)
- Package Manager: pip / poetry / uv

## Code Style

### Formatting
- Use `black` for formatting
- Use `ruff` for linting
- Use `isort` for import sorting
- Line length: 88 characters

### Type Hints
- Required for all function parameters and returns
- Use `typing` module for complex types
- Run `mypy` for type checking

```python
def get_user(user_id: int) -> User | None:
    """Fetch user by ID."""
    ...
```

### Naming
- **Files**: snake_case (`user_service.py`)
- **Functions**: snake_case (`get_user_by_id`)
- **Classes**: PascalCase (`UserService`)
- **Constants**: SCREAMING_SNAKE_CASE (`MAX_RETRIES`)
- **Private**: underscore prefix (`_internal_method`)

### Imports
```python
# Standard library
import os
from typing import Optional

# Third-party
from fastapi import FastAPI
from pydantic import BaseModel

# Local
from src.services.user import UserService
```

## Architecture

### Preferred Patterns
- Repository pattern for database access
- Service layer for business logic
- Dependency injection (FastAPI's Depends)
- Pydantic models for validation

### Avoid
- Circular imports
- Global mutable state
- Raw SQL in route handlers
- Business logic in route handlers

## Testing

- Use `pytest` for testing
- Test file naming: `test_*.py`
- Use fixtures for common test data
- Mock external services

```python
def test_create_user_returns_user_with_id(user_service, mock_db):
    result = user_service.create(name="Test", email="test@example.com")
    assert result.id is not None
```

## Database

- Use SQLAlchemy or Django ORM
- Alembic for migrations
- Never modify existing migrations
- Index frequently queried columns

## Error Handling

```python
class UserNotFoundError(Exception):
    def __init__(self, user_id: int):
        self.user_id = user_id
        super().__init__(f"User {user_id} not found")
```

## Commands

```bash
# Development
python -m uvicorn src.main:app --reload

# Testing
pytest
pytest --cov=src --cov-report=html

# Linting
ruff check .
ruff check . --fix
black .

# Type checking
mypy .

# Database
alembic upgrade head
alembic revision --autogenerate -m "description"
```

## Common Mistakes

- [Add project-specific lessons here]
