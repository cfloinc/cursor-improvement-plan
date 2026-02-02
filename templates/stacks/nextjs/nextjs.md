# Next.js Project Rules

## Stack
- Next.js 14+ (App Router)
- React 18+
- TypeScript 5.x
- Styling: Tailwind CSS

## Project Structure

```
/
├── app/                    # App Router pages
│   ├── (auth)/            # Route groups
│   ├── api/               # API routes
│   ├── layout.tsx         # Root layout
│   └── page.tsx           # Home page
├── components/
│   ├── ui/                # Reusable UI (buttons, inputs)
│   └── features/          # Feature-specific components
├── lib/                   # Utilities and helpers
├── hooks/                 # Custom React hooks
├── types/                 # TypeScript types
└── public/                # Static assets
```

## React Patterns

### Components
- Use functional components with hooks
- Use Server Components by default
- Add `'use client'` only when needed
- Use named exports (no default exports)

```typescript
// components/UserCard.tsx
'use client'; // Only if needed

import { useState } from 'react';
import type { User } from '@/types';

interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
}

export function UserCard({ user, onEdit }: UserCardProps) {
  const [isExpanded, setIsExpanded] = useState(false);
  
  return (
    <div onClick={() => setIsExpanded(!isExpanded)}>
      {user.name}
    </div>
  );
}
```

### Server vs Client Components

**Server Components (default):**
- Data fetching
- Accessing backend resources
- Keeping sensitive info on server
- Large dependencies

**Client Components ('use client'):**
- Interactivity (onClick, onChange)
- useState, useEffect, useContext
- Browser-only APIs

## Data Fetching

### Server Components
```typescript
// app/users/page.tsx
async function UsersPage() {
  const users = await db.user.findMany();
  return <UserList users={users} />;
}
```

### Server Actions
```typescript
// app/actions/user.ts
'use server';

export async function createUser(formData: FormData) {
  const name = formData.get('name');
  await db.user.create({ data: { name } });
  revalidatePath('/users');
}
```

### Client-side
```typescript
// Use SWR or React Query
const { data, error, isLoading } = useSWR('/api/users', fetcher);
```

## Styling with Tailwind

```typescript
import { cn } from '@/lib/utils';

<button className={cn(
  'px-4 py-2 rounded',
  isActive && 'bg-blue-500 text-white',
  disabled && 'opacity-50 cursor-not-allowed'
)}>
```

## API Routes

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const users = await db.user.findMany();
  return NextResponse.json(users);
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const user = await db.user.create({ data: body });
  return NextResponse.json(user, { status: 201 });
}
```

## File Naming

- **Components**: PascalCase (`UserProfile.tsx`)
- **Utilities**: camelCase (`formatDate.ts`)
- **Hooks**: camelCase with 'use' (`useUser.ts`)
- **Types**: PascalCase (`types.ts`)
- **Routes**: kebab-case folders (`user-profile/`)

## Commands

```bash
# Development
npm run dev

# Build
npm run build

# Production
npm start

# Linting
npm run lint

# Type checking
npx tsc --noEmit
```

## Common Mistakes

- Fetching data in Client Components when Server works
- Using 'use client' unnecessarily
- Not handling loading and error states
- Not using proper caching/revalidation
- [Add project-specific lessons here]
