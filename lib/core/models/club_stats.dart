class ClubStats {
  const ClubStats({
    required this.membersCount,
    required this.activitiesCount,
    required this.teachersCount,
  });

  factory ClubStats.fromJson(Map<String, dynamic> json) => ClubStats(
        membersCount: (json['membersCount'] as num).toInt(),
        activitiesCount: (json['activitiesCount'] as num).toInt(),
        teachersCount: (json['teachersCount'] as num).toInt(),
      );

  final int membersCount;
  final int activitiesCount;
  final int teachersCount;
}
