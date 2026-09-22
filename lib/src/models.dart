class UserContext {
  final String userId;
  final String tenantId;
  final List<String> roles;
  final List<String> permissions;
  final Map<String, dynamic>? customClaims;

  const UserContext({
    required this.userId,
    required this.tenantId,
    this.roles = const [],
    this.permissions = const [],
    this.customClaims,
  });

  factory UserContext.fromJson(Map<String, dynamic> json) {
    return UserContext(
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      tenantId: json['tenant_id'] as String? ?? json['tenantId'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      permissions: (json['permissions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      customClaims: json['custom_claims'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'tenant_id': tenantId,
      'roles': roles,
      'permissions': permissions,
      'custom_claims': customClaims,
    };
  }
}

class AuthTokens {
  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final int? expiresIn;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.idToken,
    this.expiresIn,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String?,
      idToken: json['id_token'] as String?,
      expiresIn: json['expires_in'] as int?,
    );
  }
}

class SerafortConfig {
  final String endpoint;
  final String? clientId;
  final String? redirectUri;
  final String keyPrefix;

  const SerafortConfig({
    required this.endpoint,
    this.clientId,
    this.redirectUri,
    this.keyPrefix = 'serafort_auth',
  });
}

class SerafortException implements Exception {
  final String message;
  final dynamic cause;

  const SerafortException(this.message, [this.cause]);

  @override
  String toString() => 'SerafortException: $message';
}
