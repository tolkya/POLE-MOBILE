class UserClubModel {
  UserClubModel({
    required this.userClubId,
    required this.clubId,
    required this.clubName,
    required this.clubCode,
    required this.roles,
    this.themeColor,
  });

  final int userClubId;
  final int clubId;
  final String clubName;
  final String clubCode;
  final List<String> roles;
  final String? themeColor;

  factory UserClubModel.fromJson(Map<String, dynamic> json) {
    final club = (json['club'] as Map<String, dynamic>? ?? <String, dynamic>{});

    return UserClubModel(
      userClubId: (json['id'] as num?)?.toInt() ?? 0,
      clubId: (club['id'] as num?)?.toInt() ?? 0,
      clubName: (club['name'] as String?) ?? 'Club',
      clubCode: (club['clubCode'] as String?) ?? '',
      roles: (json['roles'] as List<dynamic>? ?? const <dynamic>[]).cast<String>(),
      themeColor: club['themeColor'] as String?,
    );
  }
}
