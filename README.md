# Serafort SDK for Flutter

Enterprise IAM, PKCE S256 SSO, secure token storage, and wildcard RBAC for Flutter cross-platform mobile and desktop applications.

## Features

- 🔒 **Encrypted Hardware Storage**: Pluggable `SecureStorage` adapter (compatible with `flutter_secure_storage`).
- ⚡ **Flutter Reactivity**: `ValueNotifier<UserContext?>` for simple UI updates and Riverpod/Provider binding.
- 🌐 **Enterprise SSO**: RFC 7636 PKCE code generation for Custom Tabs and ASWebAuthenticationSession.
- 🛡️ **Wildcard RBAC**: `RBAC.hasPermission(user, 'org:*')` evaluation.
- 🏢 **Multi-Tenant Isolation**: Zero-leakage multi-tenant separation.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  serafort_flutter:
    path: ../SDK/Flutter
```

## Quick Start

```dart
import 'package:serafort_flutter/serafort_flutter.dart';

final client = SerafortClient(
  config: const SerafortConfig(
    endpoint: 'https://api.serafort.com',
    clientId: 'flutter_client_id',
  ),
);

// Validate Token
final user = await client.validateToken(accessToken);

// Check Permissions
if (client.hasPermission('billing:manage')) {
  // Show Billing View
}
```

## Contributing

### Requirements

- Flutter SDK (stable channel), Dart >=3.0.0 <4.0.0

### Git hooks

This repo ships a portable pre-commit hook under `.githooks/pre-commit` that runs `flutter analyze` and `flutter test` before every commit. It is **not** installed automatically — enable it once per clone with:

```bash
git config core.hooksPath .githooks
```

There is no Husky setup here: Husky is an npm-ecosystem tool, and while this repo is JS-adjacent in spirit, the package itself is pure Dart/Flutter with no Node.js tooling involved. A plain POSIX shell script wired through `core.hooksPath` is the dependency-free equivalent, and skips its checks gracefully if `flutter` isn't on `PATH`.

### CI

Every push and pull request against `main` runs `flutter pub get`, `flutter analyze`, and `flutter test` via GitHub Actions (`.github/workflows/ci.yml`).
