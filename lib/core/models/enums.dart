import 'package:json_annotation/json_annotation.dart';

enum ClubRole {
  @JsonValue('ADMIN')
  admin,
  @JsonValue('TEACHER')
  teacher,
  @JsonValue('SECRETARY')
  secretary,
  @JsonValue('MEMBER')
  member,
  @JsonValue('USER')
  user,
}

enum ActivityRole {
  @JsonValue('TEACHER')
  teacher,
  @JsonValue('STUDENT')
  student,
}

enum UserActivityStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('LEFT')
  left,
}

enum JoinPolicy {
  @JsonValue('AUTO_ACCEPT')
  autoAccept,
  @JsonValue('MANUAL_VALIDATION')
  manualValidation,
}

enum ActivityStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('SUSPENDED')
  suspended,
}

enum NotificationType {
  @JsonValue('CLUB_CREATED')
  clubCreated,
  @JsonValue('CLUB_VALIDATED')
  clubValidated,
  @JsonValue('CLUB_REJECTED')
  clubRejected,
  @JsonValue('MEMBER_VALIDATED')
  memberValidated,
  @JsonValue('MEMBER_JOIN_REQUEST')
  memberJoinRequest,
  @JsonValue('MEMBER_JOIN_APPROVED')
  memberJoinApproved,
  @JsonValue('MEMBER_EXCLUDED')
  memberExcluded,
  @JsonValue('ACTIVITY_JOIN_REQUEST')
  activityJoinRequest,
  @JsonValue('ACTIVITY_JOIN_APPROVED')
  activityJoinApproved,
  @JsonValue('ACTIVITY_JOIN_REJECTED')
  activityJoinRejected,
}