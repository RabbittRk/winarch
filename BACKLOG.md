# Backlog: go_router + Riverpod + Flutter Secure Storage + Clean Architecture

Setup and migration tasks for the **winarch** Flutter app.

---

## 1. Dependencies

- [x] Add `flutter_riverpod` and `riverpod_annotation`
- [x] Add `go_router`
- [x] Add `flutter_secure_storage`
- [x] Add dev deps: `riverpod_generator`, `build_runner`, `custom_lint`, `riverpod_lint` (optional)
- [x] Run `flutter pub get`

---

## 2. Clean Architecture – Folder Structure

- [ ] Create layer folders under `lib/`:
  - `lib/core/` – shared utilities, constants, failures, extensions
  - `lib/features/` – feature modules (each with domain, data, presentation)
  - `lib/shared/` – shared widgets, theme, routing (if desired)
- [ ] Per feature (e.g. `lib/features/auth/`):
  - [ ] `domain/` – entities, repository interfaces (abstract classes)
  - [ ] `data/` – models, data sources, repository implementations
  - [ ] `presentation/` – screens, widgets, providers (Riverpod), not routing config

---

## 3. Riverpod Setup

- [x] Wrap app with `ProviderScope` in `main.dart`
- [ ] Create a root “app provider” or bootstrap provider if needed
- [ ] Define provider conventions (e.g. `*Provider` for refs, `*Notifier` for logic)
- [ ] Add `ProviderScope`-level overrides for tests (e.g. mock storage, mock repo)

---

## 4. GoRouter Setup

- [x] Add go_router dependency and create `GoRouter` instance (e.g. in `lib/core/router/` or `lib/shared/router/`)
- [ ] Define route paths as constants (e.g. `/`, `/login`, `/home`, `/settings`)
- [ ] Implement `GoRoute` tree with `path`, `name`, `builder` (or `pageBuilder`)
- [x] Use `MaterialApp.router` with `routerConfig: goRouter` in `main.dart`
- [ ] Add redirect logic (e.g. auth redirect to `/login` or `/home`) using a provider that reads auth state
- [ ] Optional: shell routes / nested navigation (e.g. bottom nav with `StatefulShellRoute`)

---

## 5. Flutter Secure Storage – Data Layer

- [ ] Create a secure storage **interface** in domain (e.g. `lib/core/domain/` or per-feature `domain/`) – e.g. `SecureStorageRepository` with `read`, `write`, `delete`, `clear`
- [ ] Implement interface in data layer using `FlutterSecureStorage` (e.g. `SecureStorageRepositoryImpl` in `lib/core/data/` or feature `data/`)
- [ ] Register implementation as Riverpod provider (e.g. `secureStorageProvider`)
- [ ] Use only via repository in app code (no direct `FlutterSecureStorage` in UI or domain)
- [ ] Document Android/iOS keychain usage and min SDK if needed

---

## 6. Clean Architecture – Domain Layer

- [ ] Define **entities** (plain Dart classes) per feature
- [ ] Define **repository abstractions** (abstract classes) in domain; keep them free of Flutter/platform imports
- [ ] Optionally add **use cases** (single-responsibility classes that call one repo method) for complex flows

---

## 7. Clean Architecture – Data Layer

- [ ] Add **models** (DTOs with `fromJson`/`toJson`) where API or storage format differs from entities
- [ ] Implement **repository** classes that depend on data sources (e.g. secure storage impl, API client) and map models → entities
- [ ] Provide repositories via Riverpod (e.g. `authRepositoryProvider` depending on `secureStorageProvider`)

---

## 8. Presentation Layer (per feature)

- [ ] **Providers**: expose state and use cases/repositories via Riverpod (e.g. `authStateProvider`, `loginNotifierProvider`)
- [ ] **Screens**: use `GoRouter.of(context)` or `context.go`/`context.push` for navigation; read state from providers
- [ ] Keep **widgets** presentational where possible (receive callbacks and data via parameters)

---

## 9. Integration & Wiring

- [ ] Replace default `MaterialApp`/`home` with `MaterialApp.router` and `GoRouter`
- [ ] Implement at least one flow that uses: navigation (go_router) + state (Riverpod) + secure storage (via repository)
- [ ] Ensure `main()` runs `runApp(ProviderScope(child: MyApp()))` and app uses the same `GoRouter` instance (e.g. from a provider or top-level variable)

---

## 10. Optional / Later

- [ ] Deep linking with go_router
- [ ] Route guards / redirects based on Riverpod auth state
- [ ] Dependency injection for tests (override `secureStorageProvider`, repository providers)
- [ ] Code gen for Riverpod (`@riverpod` with build_runner) and consistent lint rules

---

## Quick reference

| Concern            | Tool / layer        |
|--------------------|---------------------|
| Routing            | go_router           |
| State / DI         | Riverpod            |
| Secrets / tokens   | flutter_secure_storage (via repository in data) |
| Structure          | Clean architecture (domain → data → presentation) |
