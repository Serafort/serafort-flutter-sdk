import 'package:test/test.dart';
import 'package:serafort_flutter/serafort_flutter.dart';

void main() {
  group('Serafort Flutter SDK', () {
    test('Wildcard RBAC Evaluator', () {
      const user = UserContext(
        userId: 'usr_flutter_1',
        tenantId: 'tenant_flutter',
        roles: ['admin', 'developer'],
        permissions: ['org:*', 'billing:read'],
      );

      // Wildcard
      expect(RBAC.hasPermission(user, 'org:members:invite'), isTrue);
      expect(RBAC.hasPermission(user, 'org:settings:update'), isTrue);

      // Exact
      expect(RBAC.hasPermission(user, 'billing:read'), isTrue);

      // Non-matching
      expect(RBAC.hasPermission(user, 'billing:write'), isFalse);
      expect(RBAC.hasPermission(user, 'system:admin'), isFalse);

      // Global wildcard
      const superUser = UserContext(
        userId: 'usr_super',
        tenantId: 'tenant_flutter',
        roles: ['superadmin'],
        permissions: ['*'],
      );
      expect(RBAC.hasPermission(superUser, 'any:perm'), isTrue);
    });

    test('Roles and Tenant checks', () {
      const user = UserContext(
        userId: 'usr_flutter_1',
        tenantId: 'tenant_flutter',
        roles: ['admin'],
      );

      expect(RBAC.hasRole(user, 'admin'), isTrue);
      expect(RBAC.hasRole(user, 'viewer'), isFalse);

      expect(RBAC.hasTenant(user, 'tenant_flutter'), isTrue);
      expect(RBAC.hasTenant(user, 'tenant_other'), isFalse);
    });

    test('PKCE S256 generation', () {
      final pkce1 = PKCEPair.generate();
      final pkce2 = PKCEPair.generate();

      expect(pkce1.codeVerifier, isNotEmpty);
      expect(pkce1.codeChallenge, isNotEmpty);
      expect(pkce1.codeChallengeMethod, equals('S256'));

      expect(pkce1.codeVerifier, isNot(equals(pkce2.codeVerifier)));
      expect(pkce1.codeChallenge, isNot(equals(pkce2.codeChallenge)));
    });

    test('Secure Storage in-memory operations', () async {
      final storage = InMemorySecureStorage();
      await storage.write(key: 'token', value: 'secret');
      expect(await storage.read(key: 'token'), equals('secret'));

      await storage.delete(key: 'token');
      expect(await storage.read(key: 'token'), isNull);
    });

    test('UserContext fromJson parsing', () {
      final json = {
        'user_id': 'usr_json_1',
        'tenant_id': 'tenant_acme',
        'roles': ['editor'],
        'permissions': ['org:*'],
      };

      final user = UserContext.fromJson(json);
      expect(user.userId, equals('usr_json_1'));
      expect(user.tenantId, equals('tenant_acme'));
      expect(user.roles, contains('editor'));
      expect(user.permissions, contains('org:*'));
    });
  });
}
