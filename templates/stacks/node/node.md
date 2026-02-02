# Node.js/TypeScript Project Rules

## Stack
- Node.js 20+
- TypeScript 5.x
- Package Manager: npm / pnpm / bun

## Code Style

### TypeScript
- Strict mode enabled
- Always type function parameters and returns
- Prefer `interface` over `type` for objects
- Use `const` by default, `let` when reassignment needed

```typescript
interface User {
  id: string;
  name: string;
  email: string;
}

async function getUser(id: string): Promise<User | null> {
  // ...
}
```

### Formatting
- Use Prettier for formatting
- Use ESLint for linting
- Semicolons: yes (or configure as team prefers)

### Naming
- **Files**: kebab-case (`user-service.ts`)
- **Functions**: camelCase (`getUserById`)
- **Classes**: PascalCase (`UserService`)
- **Constants**: SCREAMING_SNAKE_CASE (`MAX_RETRIES`)
- **Interfaces**: PascalCase, no `I` prefix (`User`, not `IUser`)

### Imports
```typescript
// Node built-ins
import fs from 'node:fs';

// Third-party
import express from 'express';

// Local (use path aliases)
import { UserService } from '@/services/user';
import type { User } from '@/types';
```

### Exports
- Prefer named exports over default exports
- Export types separately with `export type`

```typescript
export function createUser() { ... }
export type { User };
```

## Architecture

### Preferred Patterns
- Repository pattern for data access
- Service layer for business logic
- Dependency injection for testability
- Use async/await (never raw promises)

### Avoid
- Callback hell
- `any` type (use `unknown` if needed)
- Circular dependencies
- Business logic in route handlers

## Testing

- Use Jest or Vitest
- Test file: `*.test.ts` or `*.spec.ts`
- Mock external dependencies
- Use factories for test data

```typescript
describe('UserService', () => {
  it('should create user with generated id', async () => {
    const user = await userService.create({ name: 'Test' });
    expect(user.id).toBeDefined();
  });
});
```

## Error Handling

```typescript
class AppError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public code?: string
  ) {
    super(message);
    this.name = 'AppError';
  }
}

class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(`${resource} ${id} not found`, 404, 'NOT_FOUND');
  }
}
```

## Commands

```bash
# Development
npm run dev

# Build
npm run build

# Testing
npm test
npm run test:coverage

# Linting
npm run lint
npm run lint:fix

# Type checking
npx tsc --noEmit
```

## tsconfig.json Essentials

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

## Common Mistakes

- Forgetting to await async functions
- Not handling promise rejections
- Using `any` instead of proper types
- [Add project-specific lessons here]
