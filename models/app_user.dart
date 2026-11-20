enum UserRole { employee, manager }

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.name,
    required this.job,
    required this.role,
    required this.passwordHash,
    required this.mustChangePassword,
  });

  final String id;
  final String username;
  final String name;
  final String job;
  final UserRole role;
  final String passwordHash;
  final bool mustChangePassword;

  bool get isManager => role == UserRole.manager;

  AppUser copyWith({String? passwordHash, bool? mustChangePassword}) => AppUser(
        id: id,
        username: username,
        name: name,
        job: job,
        role: role,
        passwordHash: passwordHash ?? this.passwordHash,
        mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'job': job,
        'role': role.name,
        'passwordHash': passwordHash,
        'mustChangePassword': mustChangePassword,
      };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] as String,
        username: j['username'] as String,
        name: j['name'] as String,
        job: j['job'] as String,
        role: UserRole.values.byName(j['role'] as String),
        passwordHash: j['passwordHash'] as String,
        mustChangePassword: j['mustChangePassword'] as bool,
      );
}
