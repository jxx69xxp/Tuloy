// Pure Dart: no Flutter, Dio or storage imports here.

/// Ordered lowest to highest: [User.roleAt] picks the highest one held.
enum Role { guest, restaurant, staff, admin }

class Membership {
  const Membership({required this.hotelId, required this.role, this.permissions = const []});
  final String hotelId;
  final Role role;
  final List<String> permissions;
}

class User {
  const User({
    required this.id,
    required this.fullName,
    required this.language,
    required this.memberships,
    this.email,
    this.phone,
  });
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String language;
  final List<Membership> memberships;

  /// Highest role held at [hotelId]; a signed-in user with no membership is a guest.
  Role roleAt(String hotelId) => memberships
      .where((m) => m.hotelId == hotelId)
      .map((m) => m.role)
      .fold(Role.guest, (best, r) => r.index > best.index ? r : best);
}

abstract interface class AuthRepository {
  /// Signed-in user from stored tokens, or null.
  Future<User?> restore();
  Future<User> signIn(String login, String password);
  Future<User> signUp({
    required String fullName,
    required String login,
    required String password,
    required String language,
  });
  Future<void> requestReset(String login);
  Future<void> resetPassword({required String login, required String code, required String newPassword});
  Future<void> updateLanguage(String language);
  Future<void> signOut();
}
