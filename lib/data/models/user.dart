class AppUser {
  final String id;
  final String displayName;
  final String email;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String? ?? '',
      displayName:
          json['displayName'] as String? ??
          json['name'] as String? ??
          json['fullName'] as String? ??
          'User',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? json['photoUrl'] as String?,
    );
  }

  AppUser copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'email': email,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
  };
}
