# flutter-boilerplate

> Production Flutter starter with Riverpod, go_router, Dio, secure storage, Material 3 theming, and clean architecture. Clone → configure API URL → build.

![Flutter](https://img.shields.io/badge/flutter-3.19+-blue) ![Dart](https://img.shields.io/badge/dart-3.3+-blue) ![License](https://img.shields.io/badge/license-MIT-green)

## What's included

| Feature | Package | Notes |
|---------|---------|-------|
| State management | `flutter_riverpod` | Providers, AsyncNotifier, StateProvider |
| Navigation | `go_router` | Declarative routes, auth redirect guards |
| HTTP client | `dio` + `pretty_dio_logger` | Auth interceptor, JWT refresh, request logging |
| Secure storage | `flutter_secure_storage` | JWT tokens stored securely |
| Local storage | `shared_preferences` | User preferences, feature flags |
| Serialization | `freezed` + `json_serializable` | Immutable models, code generation |
| Environment config | `envied` | Compile-time env vars via `--dart-define` |
| UI | Material 3 | Light + dark theme, Inter font |
| Localization | `flutter_localizations` | Ready for ARB-based l10n |
| Testing | `mocktail` + `flutter_test` | Widget + unit test helpers |
| CI | GitHub Actions | Analyze, test, build APK on every push |

## Project Structure

```
lib/
├── main.dart                     # App entry point
├── core/
│   ├── config/
│   │   └── app_config.dart       # Env vars, SharedPreferences init
│   ├── network/
│   │   ├── api_client.dart       # Dio + auth interceptor + JWT refresh
│   │   └── auth_provider.dart    # authStateProvider (current user)
│   ├── router/
│   │   └── app_router.dart       # go_router routes + auth guards
│   └── theme/
│       └── app_theme.dart        # Material 3 light/dark themes
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart   # login, register, logout, getCurrentUser
│   │   ├── domain/
│   │   │   └── user_model.dart        # User model
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   └── home/
│       └── presentation/
│           └── home_screen.dart
└── shared/
    └── widgets/
        ├── app_text_field.dart    # Styled TextFormField
        └── loading_button.dart   # ElevatedButton with loading spinner
```

## Quick Start

### Prerequisites

- Flutter 3.19+
- Dart 3.3+

### 1. Clone and install

```bash
git clone https://github.com/bhupendra05/flutter-boilerplate.git myapp
cd myapp
flutter pub get
```

### 2. Configure your API URL

```bash
# Option A — dart-define (recommended for CI/CD)
flutter run --dart-define=API_BASE_URL=https://api.yourapp.com/v1

# Option B — edit lib/core/config/app_config.dart directly
# Change the defaultValue in String.fromEnvironment('API_BASE_URL', ...)
```

### 3. Run code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the app

```bash
flutter run
```

---

## Authentication Flow

The auth flow is handled by three components working together:

**`AuthRepository`** — calls `POST /auth/login`, saves tokens to `FlutterSecureStorage`, calls `GET /auth/me`.

**`authStateProvider`** — a `FutureProvider<User?>` that calls `getCurrentUser()`. Returns `null` when not authenticated.

**`AppRouter`** — go_router `redirect` callback watches `authStateProvider`. If `user == null` and the route requires auth → redirects to `/login`. If `user != null` and already on `/login` → redirects to `/`.

**Token refresh** — the Dio interceptor catches 401 responses, calls `POST /auth/refresh` with the refresh token, updates storage, and retries the original request automatically.

### Backend API expected endpoints

```
POST /auth/login        → { access_token, refresh_token, user: { id, email, name } }
POST /auth/register     → { access_token, refresh_token, user: { id, email, name } }
POST /auth/refresh      → { access_token, refresh_token? }
POST /auth/logout       → 200 OK
GET  /auth/me           → { id, email, name, avatar_url? }
```

---

## Adding a New Feature

Follow the clean architecture pattern:

```
lib/features/myfeature/
├── data/
│   └── myfeature_repository.dart   # API calls, cache reads
├── domain/
│   └── myfeature_model.dart        # Data model (use freezed)
└── presentation/
    ├── myfeature_screen.dart        # Screen widget
    └── myfeature_provider.dart      # Riverpod providers for this feature
```

1. Define the model with `@freezed`
2. Create the repository (inject `ApiClient`)
3. Create Riverpod providers
4. Build the screen using `ConsumerWidget` or `ConsumerStatefulWidget`
5. Add the route in `app_router.dart`

---

## Theming

Colors are defined in `lib/core/theme/app_theme.dart`. Change `_primary` to your brand color and everything propagates through Material 3's color scheme.

Dark mode is toggled via:

```dart
ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
```

---

## Environment Config

Pass environment variables at build time:

```bash
# Run
flutter run \
  --dart-define=API_BASE_URL=https://api.example.com/v1 \
  --dart-define=APP_ENV=production

# Build APK
flutter build apk --release \
  --dart-define=API_BASE_URL=https://api.example.com/v1 \
  --dart-define=APP_ENV=production
```

For more complex secrets, use [envied](https://pub.dev/packages/envied) with a `.env` file (already in `.gitignore`).

---

## License

MIT © bhupendra05
