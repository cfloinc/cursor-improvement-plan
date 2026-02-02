# Laravel Project Rules

## Stack
- PHP 8.2+
- Laravel 10+
- Database: MySQL / PostgreSQL

## Code Style

### PSR-12
- Follow PSR-12 coding standard
- Use Laravel Pint for formatting
- Use PHPStan for static analysis

### Naming
- **Controllers**: PascalCase, singular (`UserController`)
- **Models**: PascalCase, singular (`User`)
- **Migrations**: snake_case with timestamp
- **Tables**: snake_case, plural (`users`)
- **Columns**: snake_case (`created_at`)

### Type Declarations
```php
public function getUser(int $id): ?User
{
    return User::find($id);
}
```

## Architecture

### Controllers
- Keep thin, delegate to services
- Use Form Requests for validation
- Use API Resources for responses

```php
class UserController extends Controller
{
    public function store(StoreUserRequest $request, UserService $service): UserResource
    {
        $user = $service->create($request->validated());
        return new UserResource($user);
    }
}
```

### Services
- Business logic lives here
- Inject dependencies via constructor

```php
class UserService
{
    public function __construct(
        private UserRepository $repository,
        private NotificationService $notifications
    ) {}
    
    public function create(array $data): User
    {
        $user = $this->repository->create($data);
        $this->notifications->sendWelcome($user);
        return $user;
    }
}
```

### Repositories
- Database queries only
- No business logic

### Form Requests
```php
class StoreUserRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users'],
        ];
    }
}
```

## Eloquent

### Queries
- Use Eloquent over raw queries
- Use scopes for reusable queries
- Eager load relationships

```php
// Good
$users = User::with('posts')
    ->active()
    ->orderBy('name')
    ->get();

// Avoid N+1
$users = User::all();
foreach ($users as $user) {
    echo $user->posts->count(); // N+1!
}
```

### Relationships
```php
class User extends Model
{
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }
}
```

## Database

### Migrations
- Never modify existing migrations in production
- Use descriptive names
- Add foreign keys and indexes

```php
Schema::create('posts', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->string('title');
    $table->text('content');
    $table->timestamps();
    
    $table->index('user_id');
});
```

## Testing

- Use PHPUnit or Pest
- Use factories for test data
- Test file: `tests/Feature/`, `tests/Unit/`

```php
public function test_user_can_be_created(): void
{
    $response = $this->postJson('/api/users', [
        'name' => 'Test User',
        'email' => 'test@example.com',
    ]);
    
    $response->assertStatus(201)
        ->assertJsonPath('data.name', 'Test User');
}
```

## Commands

```bash
# Development
php artisan serve

# Testing
php artisan test
php artisan test --coverage

# Database
php artisan migrate
php artisan migrate:fresh --seed
php artisan db:seed

# Cache
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Queue
php artisan queue:work
```

## Common Mistakes

- Using raw queries when Eloquent works
- Not using Form Requests for validation
- N+1 query problems (use eager loading)
- Business logic in controllers
- [Add project-specific lessons here]
