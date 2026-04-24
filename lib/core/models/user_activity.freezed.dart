// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserActivity {

 int get id; User get member; Activity get activity; ActivityRole? get role; UserActivityStatus? get status; DateTime? get createdAt;
/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserActivityCopyWith<UserActivity> get copyWith => _$UserActivityCopyWithImpl<UserActivity>(this as UserActivity, _$identity);

  /// Serializes this UserActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.member, member) || other.member == member)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,member,activity,role,status,createdAt);

@override
String toString() {
  return 'UserActivity(id: $id, member: $member, activity: $activity, role: $role, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserActivityCopyWith<$Res>  {
  factory $UserActivityCopyWith(UserActivity value, $Res Function(UserActivity) _then) = _$UserActivityCopyWithImpl;
@useResult
$Res call({
 int id, User member, Activity activity, ActivityRole? role, UserActivityStatus? status, DateTime? createdAt
});


$UserCopyWith<$Res> get member;$ActivityCopyWith<$Res> get activity;

}
/// @nodoc
class _$UserActivityCopyWithImpl<$Res>
    implements $UserActivityCopyWith<$Res> {
  _$UserActivityCopyWithImpl(this._self, this._then);

  final UserActivity _self;
  final $Res Function(UserActivity) _then;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? member = null,Object? activity = null,Object? role = freezed,Object? status = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as User,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as Activity,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ActivityRole?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserActivityStatus?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get member {
  
  return $UserCopyWith<$Res>(_self.member, (value) {
    return _then(_self.copyWith(member: value));
  });
}/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCopyWith<$Res> get activity {
  
  return $ActivityCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserActivity].
extension UserActivityPatterns on UserActivity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserActivity value)  $default,){
final _that = this;
switch (_that) {
case _UserActivity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserActivity value)?  $default,){
final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  User member,  Activity activity,  ActivityRole? role,  UserActivityStatus? status,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that.id,_that.member,_that.activity,_that.role,_that.status,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  User member,  Activity activity,  ActivityRole? role,  UserActivityStatus? status,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserActivity():
return $default(_that.id,_that.member,_that.activity,_that.role,_that.status,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  User member,  Activity activity,  ActivityRole? role,  UserActivityStatus? status,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that.id,_that.member,_that.activity,_that.role,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserActivity implements UserActivity {
  const _UserActivity({required this.id, required this.member, required this.activity, this.role, this.status, this.createdAt});
  factory _UserActivity.fromJson(Map<String, dynamic> json) => _$UserActivityFromJson(json);

@override final  int id;
@override final  User member;
@override final  Activity activity;
@override final  ActivityRole? role;
@override final  UserActivityStatus? status;
@override final  DateTime? createdAt;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserActivityCopyWith<_UserActivity> get copyWith => __$UserActivityCopyWithImpl<_UserActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.member, member) || other.member == member)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,member,activity,role,status,createdAt);

@override
String toString() {
  return 'UserActivity(id: $id, member: $member, activity: $activity, role: $role, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserActivityCopyWith<$Res> implements $UserActivityCopyWith<$Res> {
  factory _$UserActivityCopyWith(_UserActivity value, $Res Function(_UserActivity) _then) = __$UserActivityCopyWithImpl;
@override @useResult
$Res call({
 int id, User member, Activity activity, ActivityRole? role, UserActivityStatus? status, DateTime? createdAt
});


@override $UserCopyWith<$Res> get member;@override $ActivityCopyWith<$Res> get activity;

}
/// @nodoc
class __$UserActivityCopyWithImpl<$Res>
    implements _$UserActivityCopyWith<$Res> {
  __$UserActivityCopyWithImpl(this._self, this._then);

  final _UserActivity _self;
  final $Res Function(_UserActivity) _then;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? member = null,Object? activity = null,Object? role = freezed,Object? status = freezed,Object? createdAt = freezed,}) {
  return _then(_UserActivity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as User,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as Activity,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ActivityRole?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserActivityStatus?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get member {
  
  return $UserCopyWith<$Res>(_self.member, (value) {
    return _then(_self.copyWith(member: value));
  });
}/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityCopyWith<$Res> get activity {
  
  return $ActivityCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

// dart format on
