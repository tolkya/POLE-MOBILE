// lib/core/models/user_model.dart
class UserModel {
  final int id;
  final String email;
  final List<String> roles;
  final String? phone;
  final String firstName;
  final String lastName;

  UserModel({
    required this.id,
    required this.email,
    required this.roles,
    required this.phone,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>).cast<String>(),
      phone: json['phone'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }
}