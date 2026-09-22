import 'models.dart';

class RBAC {
  static bool hasPermission(UserContext user, String required) {
    return hasPermissionInList(user.permissions, required);
  }

  static bool hasPermissionInList(List<String> userPermissions, String required) {
    for (final perm in userPermissions) {
      if (perm == '*') return true;
      if (perm == required) return true;
      if (perm.endsWith(':*')) {
        final prefix = perm.substring(0, perm.length - 2);
        if (required.startsWith('$prefix:') || required == prefix) {
          return true;
        }
      }
    }
    return false;
  }

  static bool hasRole(UserContext user, String role) {
    return user.roles.contains(role);
  }

  static bool hasTenant(UserContext user, String tenantId) {
    return user.tenantId == tenantId;
  }
}
