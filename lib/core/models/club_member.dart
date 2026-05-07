import 'package:pole_mobile/core/models/enums.dart';
import 'package:pole_mobile/core/models/user.dart';

class ClubMember {
  ClubMember({
    required this.id,
    required this.member,
    required this.roles,
    this.validatedAt,
    this.createdAt,
  });

  factory ClubMember.fromJson(Map<String, dynamic> json) {
    final rawRoles = (json['roles'] as List<dynamic>? ?? const [])
        .cast<String>();

    return ClubMember(
      id: (json['id'] as num).toInt(),
      member: User.fromJson(json['member'] as Map<String, dynamic>),
      roles: rawRoles.map(_parseRole).toList(),
      validatedAt: json['validatedAt'] == null
          ? null
          : DateTime.tryParse(json['validatedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
    );
  }

  final int id;
  final User member;
  final List<ClubRole> roles;
  final DateTime? validatedAt;
  final DateTime? createdAt;

  bool get isPending => validatedAt == null;

  static ClubRole _parseRole(String role) {
    switch (role) {
      case 'ADMIN':
        return ClubRole.admin;
      case 'TEACHER':
        return ClubRole.teacher;
      case 'SECRETARY':
        return ClubRole.secretary;
      case 'MEMBER':
        return ClubRole.member;
      default:
        return ClubRole.user;
    }
  }
}