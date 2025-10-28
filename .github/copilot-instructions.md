<!-- .github/copilot-instructions.md: Project-specific instructions for AI coding agents -->
# Quick guide for AI coding agents: `login` Flutter app

Purpose: help an AI become productive quickly in this repository by calling out the app architecture, developer workflows, notable conventions, and key integration points.

1) Big picture (what this app is)
- A small cross-platform Flutter app focused on authentication flows (login/register/forgot password).
- Entry point: `lib/main.dart` — app wiring, theme, `ChangeNotifierProvider` for `AuthProvider`, `AuthWrapper` that chooses home screen.
- UI layout lives under `lib/screens/` (e.g. `login_screen.dart`, `dashboard_screen.dart`). Reusable UI pieces are in `lib/widgets/`.
- App-wide theme and color constants are in `lib/core/constants.dart`.

2) State & data flow (important files & patterns)
- Auth state is a `ChangeNotifier` at `lib/providers/auth_provider.dart`. This provider:
  - Uses `flutter_secure_storage` to persist an `auth_token` under key `auth_token`.
  - Implements `_tryAutoLogin()` called from the constructor to restore session on startup.
  - Exposes `isLoading` and `isLoggedIn` used by `AuthWrapper` in `main.dart` to decide the initial route.
- Routes are registered centrally in `MaterialApp` (`main.dart`) — use those route names when navigating.

3) Where to make common changes / integrations
- Add real auth network calls in `AuthProvider.login()` and `_tryAutoLogin()` — these currently write/read a dummy token.
- Add API or environment configuration near `lib/core/` or create `lib/services/config.dart` — the project currently has no network/config wrapper.

4) Build / run / test commands (practical developer steps)
- Install deps: `flutter pub get` (see `pubspec.yaml`).
- Run on default device: `flutter run`
- Run on Chrome: `flutter run -d chrome`
- Build artifacts: `flutter build apk` / `flutter build ios` / `flutter build web`
- Run tests: `flutter test` (there is a `test/widget_test.dart` skeleton).
- Useful debug: hot reload (`r` in `flutter run`), DevTools for inspecting provider state.

5) Project-specific conventions and gotchas
- Dark theme is used by default and defined inline in `main.dart`; prefer `lib/core/constants.dart` for color values.
- Centralized routes: update `MaterialApp.routes` in `main.dart` to add new screens.
- Provider wiring: the root `ChangeNotifierProvider` creates `AuthProvider()` directly — avoid creating multiple instances; read/write via `context.read<AuthProvider>()` and `context.watch<AuthProvider>()`.
- Token key: storage key is the literal `'auth_token'` — search and reuse this exact string when adding token logic.

6) Integration & external dependencies to watch
- `flutter_secure_storage` (secure token storage) — see `pubspec.yaml`.
- `provider` is used for state management.
- UI uses `google_fonts` and `flutter_svg` (icons/assets).

7) Helpful examples for quick edits
- To add real login logic, edit `lib/providers/auth_provider.dart` — replace the dummy `write` in `login()` with a network call and store the returned token under `auth_token`.
- To change the initial landing logic, check `AuthWrapper` in `lib/main.dart`.

8) Files and folders to inspect first
- `lib/main.dart` — app wiring, routes, theme
- `lib/providers/auth_provider.dart` — auth state, storage
- `lib/core/constants.dart` — colors and small helpers
- `lib/screens/` and `lib/widgets/` — UI implementations
- `pubspec.yaml` — dependency list

If anything above is unclear or you want the instructions expanded (for example: CI commands, platform-specific build tweaks, or an example of integrating a REST API), tell me which area to expand and I will update this file.
