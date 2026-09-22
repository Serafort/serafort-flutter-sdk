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
