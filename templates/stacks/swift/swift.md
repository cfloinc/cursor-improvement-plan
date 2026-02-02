# Swift / macOS / Xcode Project Rules

## Stack
- Swift 6+
- Xcode 16+
- macOS / iOS / visionOS / watchOS / tvOS
- Swift Package Manager

---

## Project Structure

### Swift Package (Library)

```
MyPackage/
├── Package.swift                    # SPM manifest
├── Sources/
│   └── MyPackage/
│       ├── Core/                    # Core domain types
│       │   ├── MyType.swift
│       │   ├── MyTypeError.swift
│       │   └── MyTypeConfiguration.swift
│       ├── Features/                # Feature modules
│       │   ├── FeatureA/
│       │   └── FeatureB/
│       └── Utilities/               # Shared helpers
│           ├── Extensions/
│           └── Concurrency/
├── Tests/
│   └── MyPackageTests/
│       ├── Resources/               # Test fixtures
│       └── Samples/                 # Sample data factories
└── docs/
    ├── PROJECT.md
    └── ARCHITECTURE.md
```

### Xcode App Project

```
MyApp/
├── MyApp.xcodeproj
├── MyApp/
│   ├── App/
│   │   ├── MyAppApp.swift           # @main entry point
│   │   └── ContentView.swift
│   ├── Features/
│   │   ├── FeatureA/
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   └── FeatureB/
│   ├── Services/
│   ├── Utilities/
│   └── Resources/
│       ├── Assets.xcassets
│       └── Localizable.strings
├── MyAppTests/
├── MyAppUITests/
└── docs/
```

---

## File Organization

### Section Dividers

Use consistent MARK dividers (76 equals signs) to organize code:

```swift
// ============================================================================ //
// MARK: Section Name
// ============================================================================ //
```

**Standard section order:**
1. Initialization
2. Configuration (stored properties)
3. Public API
4. Private implementation (prefix with `Private:`)

### Sub-Section Dividers

For complex methods:

```swift
// ------------------------------------------------------- //
// Part 1: Description
// ------------------------------------------------------- //

// implementation...

// ------------------------------------------------------- //
// Part 2: Description
// ------------------------------------------------------- //
```

### Example File Structure

```swift
import Foundation

public struct MyFeature: Sendable {
    
    // ============================================================================ //
    // MARK: Initialization
    // ============================================================================ //
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    // ============================================================================ //
    // MARK: Configuration
    // ============================================================================ //
    
    private let configuration: Configuration
    
    // ============================================================================ //
    // MARK: Public API
    // ============================================================================ //
    
    public func process() throws(MyFeatureError) -> Result {
        // Implementation
    }
    
    // ============================================================================ //
    // MARK: Private: Helpers
    // ============================================================================ //
    
    private func _validate() -> Bool {
        // Implementation
    }
    
}
```

---

## Naming Conventions

### Types

| Type | Convention | Example |
|------|------------|---------|
| Public types | Prefix + PascalCase | `AppTrack`, `AppUserProfile` |
| Protocols | Descriptive name | `TrackProtocol`, `Configurable` |
| Enums | PascalCase, cases lowerCamelCase | `LoadState`, `.loading` |
| Error types | Descriptive + `Error` suffix | `TrackDecodingError` |

### Properties & Methods

| Type | Convention | Example |
|------|------------|---------|
| Private backing | Leading underscore | `_storage`, `_state` |
| Private methods | Leading underscore | `_prepareData()` |
| Booleans | `is`, `has`, `can`, `was` prefix | `isLoaded`, `hasContent` |
| Factory methods | `make` prefix | `makeConfiguration()` |

### Files

Name files after the primary type they contain:
- `MyTrack.swift` → `struct MyTrack`
- `MyTrackDecoder.swift` → `struct MyTrackDecoder`
- `MyTrackError.swift` → `enum MyTrackError`

---

## Type Design

### Struct-First Design

Prefer structs over classes:

```swift
// Preferred: struct for data types
public struct Track: Equatable, Sendable {
    public let id: UUID
    public var title: String
}

// Class only when necessary
@MainActor
public final class AppState: ObservableObject {
    @Published private(set) var tracks: [Track] = []
}
```

### Protocol Conformance

Always add `Sendable` and `Equatable` where appropriate:

```swift
public struct Configuration: Hashable, Sendable {
    // ...
}
```

Put conformances in extensions for clarity:

```swift
public struct Track {
    // Core implementation
}

extension Track: Equatable { }
extension Track: Sendable { }
extension Track: CustomStringConvertible {
    public var description: String { /* ... */ }
}
```

### Nested Types

Nest tightly coupled types:

```swift
public struct DuplicatesCluster {
    
    public struct Resolution: Equatable, Sendable {
        public let itemToKeep: Item
        public let itemsToDelete: Set<Item>
    }
    
    public let items: [Item]
}
```

### RawRepresentable Wrappers

Use for type-safe identifiers:

```swift
public struct ItemID: RawRepresentable, Hashable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
```

### Static Factory Properties

```swift
public struct Path: Hashable, Sendable {
    
    public static let empty = Self(components: [])
    
    public let components: [String]
}
```

---

## Error Handling

### Typed Throws (Swift 6)

Specify error types on all throwing functions:

```swift
public func decode(
    from data: Data
) throws(DecodingError) -> Model {
    // ...
}
```

### Error Enum Design

```swift
public enum TrackDatabaseError: Error {
    case dataReadingError(Error)
    case invalidVersionField
    case decodingError(TrackDecodingError)
    case duplicateIDs([ItemID])
}
```

### Nested Error Reasons

```swift
public enum ContentReadingError: Error, Equatable {
    case invalidFileExtension
    case dataReadingError(ReadingError)
    case invalidField(FieldFailureReason)
}

extension ContentReadingError {
    public enum FieldFailureReason: Equatable, Sendable {
        case malformedValue(String)
        case missingRequired(String)
    }
}
```

### Error Transformation

```swift
func process() throws(ProcessingError) -> Result {
    do {
        return try decoder.decode()
    } catch {
        throw ProcessingError.decodingFailed(error)
    }
}
```

---

## Access Control

### Default to Restrictive

- `internal` (default) unless public API required
- `private` for implementation details
- `fileprivate` for file-scoped types/constants

### Fileprivate Patterns

```swift
fileprivate enum JobID: Hashable {
    case update
    case delete
}

fileprivate let logger = Logger(
    subsystem: "com.company.MyApp",
    category: "FeatureA"
)
```

### Setter Access Control

```swift
internal(set) public var items: [Item]
```

---

## Concurrency

### @MainActor for UI State

```swift
@MainActor
public final class ViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .idle
    
    func load() async {
        state = .loading
        // ...
    }
}
```

### AsyncStream for Reactive State

```swift
public var stateStream: AsyncStream<State> {
    stateSubject.eraseToStream()
}
```

### Task.detached for Background Work

```swift
Task.detached {
    await self.performBackgroundWork()
}
```

### Task Groups for Parallel Work

```swift
let results = await withThrowingTaskGroup(
    of: ProcessedItem.self,
    returning: [ProcessedItem].self
) { group in
    for item in items {
        group.addTask {
            try await process(item)
        }
    }
    
    var collected: [ProcessedItem] = []
    for try await result in group {
        collected.append(result)
    }
    return collected
}
```

### Sendable Compliance

All types crossing actor boundaries must be `Sendable`:

```swift
public struct DataReader: Sendable {
    private let fileURL: URL  // URL is Sendable
}
```

---

## SwiftUI Patterns

### View Structure

```swift
struct FeatureView: View {
    @StateObject private var viewModel = FeatureViewModel()
    
    var body: some View {
        content
            .task { await viewModel.load() }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let data):
            DataView(data: data)
        case .error(let error):
            ErrorView(error: error)
        }
    }
}
```

### ViewModel Pattern

```swift
@MainActor
final class FeatureViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case loaded(Data)
        case error(Error)
    }
    
    @Published private(set) var state: State = .idle
    
    private let service: FeatureService
    
    init(service: FeatureService = .shared) {
        self.service = service
    }
    
    func load() async {
        state = .loading
        do {
            let data = try await service.fetch()
            state = .loaded(data)
        } catch {
            state = .error(error)
        }
    }
}
```

---

## Logging

### Logger Declaration

```swift
import os.log

fileprivate let logger = Logger(
    subsystem: "com.company.MyApp",
    category: "FeatureName"
)
```

### Log Levels

```swift
logger.debug("Debug details")
logger.log("Standard information")
logger.error("Error occurred: \(error.localizedDescription)")
```

### Privacy Modifiers

```swift
logger.error("Failed at path '\(path, privacy: .public)': \(error)")
```

---

## Testing

### Test Naming

```swift
func testDecoding_validData_returnsModel() throws {
    // Arrange
    let data = SampleData.validTrack
    let decoder = TrackDecoder()
    
    // Act
    let result = try decoder.decode(from: data)
    
    // Assert
    XCTAssertEqual(result.title, "Expected Title")
}
```

### Test Organization

```
Tests/
├── UnitTests/
│   ├── Models/
│   └── Services/
├── IntegrationTests/
├── Resources/           # Test fixtures
└── Samples/             # Sample data factories
```

### @_spi for Testable Internals

```swift
// In source:
@_spi(Testing)
public init(internal value: String) { ... }

// In tests:
@testable import MyPackage
@_spi(Testing) import MyPackage
```

---

## Dependencies

### Package.swift

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyPackage",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "MyPackage", targets: ["MyPackage"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "MyPackage",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
            ]
        ),
        .testTarget(
            name: "MyPackageTests",
            dependencies: ["MyPackage"]
        )
    ]
)
```

### Recommended Libraries

| Purpose | Library |
|---------|---------|
| Collections | `swift-collections`, `swift-identified-collections` |
| Algorithms | `swift-algorithms`, `swift-async-algorithms` |
| Debugging | `swift-custom-dump` |
| Concurrency | `swift-concurrency-extras` |

---

## Commands

```bash
# Build
swift build
xcodebuild -scheme MyApp -configuration Debug build

# Test
swift test
xcodebuild test -scheme MyApp -destination 'platform=macOS'

# Format (SwiftFormat)
swiftformat .

# Lint (SwiftLint)
swiftlint

# Generate Xcode project from SPM
swift package generate-xcodeproj
```

---

## Common Mistakes

- Using `!` force unwrap outside of tests
- Missing `Sendable` conformance on types crossing actor boundaries
- Using `Any` instead of protocols or generics
- Implicit returns (always use explicit `return`)
- Long methods (break into private helpers)
- Force-cast with `as!` instead of safe casting
- Using `print()` instead of `os.log` Logger
- Not handling all enum cases (avoid `default`)
- [Add project-specific lessons here]

---

## Anti-Patterns to Avoid

1. **Force unwrapping** — Use `guard let` or `if let`
2. **Untyped errors** — Use typed throws
3. **Mutable globals** — Use dependency injection
4. **Nested closures** — Extract to named functions
5. **Magic strings** — Use constants or typed keys
6. **Class when struct works** — Prefer value types
7. **Combine in new code** — Prefer AsyncStream
