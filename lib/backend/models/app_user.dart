class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
