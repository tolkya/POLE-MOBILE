// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_club.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserClub {

 int get id; Club get club; User get member; List<ClubRole> get roles; DateTime? get validatedAt; DateTime? get createdAt;
/// Create a copy of UserClub
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserClubCopyWith<UserClub> get copyWith => _$UserClubCopyWithImpl<UserClub>(this as UserClub, _$identity);

  /// Serializes this UserClub to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserClub&&(identical(other.id, id) || other.id == id)&&(identical(other.club, club) || other.club == club)&&(identical(other.member, member) || other.member == member)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.validatedAt, validatedAt) || other.validatedAt == validatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,club,member,const DeepCollectionEquality().hash(roles),validatedAt,createdAt);

@override
String toString() {
  return 'UserClub(id: $id, club: $club, member: $member, roles: $roles, validatedAt: $validatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserClubCopyWith<$Res>  {
  factory $UserClubCopyWith(UserClub value, $Res Function(UserClub) _then) = _$UserClubCopyWithImpl;
@useResult
$Res call({
 int id, Club club, User member, List<ClubRole> roles, DateTime? validatedAt, DateTime? createdAt
});


$ClubCopyWith<$Res> get club;$UserCopyWith<$Res> get member;

}
/// @nodoc
class _$UserClubCopyWithImpl<$Res>
    implements $UserClubCopyWith<$Res> {
  _$UserClubCopyWithImpl(this._self, this._then);

  final UserClub _self;
  final $Res Function(UserClub) _then;

/// Create a copy of UserClub
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? club = null,Object? member = null,Object? roles = null,Object? validatedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,club: null == club ? _self.club : club // ignore: cast_nullable_to_non_nullable
as Club,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as User,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<ClubRole>,validatedAt: freezed == validatedAt ? _self.validatedAt : validatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of UserClub
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClubCopyWith<$Res> get club {
  
  return $ClubCopyWith<$Res>(_self.club, (value) {
    return _then(_self.copyWith(club: value));
  });
}/// Create a copy of UserClub
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get member {
  
  return $UserCopyWith<$Res>(_self.member, (value) {
    return _then(_self.copyWith(member: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserClub].
extension UserClubPatterns on UserClub {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserClub value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserClub() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserClub value)  $default,){
final _that = this;
switch (_that) {
case _UserClub():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserClub value)?  $default,){
final _that = this;
switch (_that) {
case _UserClub() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  Club club,  User member,  List<ClubRole> roles,  DateTime? validatedAt,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserClub() when $default != null:
return $default(_that.id,_that.club,_that.member,_that.roles,_that.validatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  Club club,  User member,  List<ClubRole> roles,  DateTime? validatedAt,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserClub():
return $default(_that.id,_that.club,_that.member,_that.roles,_that.validatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  Club club,  User member,  List<ClubRole> roles,  DateTime? validatedAt,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserClub() when $default != null:
return $default(_that.id,_that.club,_that.member,_that.roles,_that.validatedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserClub implements UserClub {
  const _UserClub({required this.id, required this.club, required this.member, final  List<ClubRole> roles = const [], this.validatedAt, this.createdAt}): _roles = roles;
  factory _UserClub.fromJson(Map<String, dynamic> json) => _$UserClubFromJson(json);

@override final  int id;
@override final  Club club;
@override final  User member;
 final  List<ClubRole> _roles;
@override@JsonKey() List<ClubRole> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override final  DateTime? validatedAt;
@override final  DateTime? createdAt;

/// Create a copy of UserClub
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserClubCopyWith<_UserClub> get copyWith => __$UserClubCopyWithImpl<_UserClub>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserClubToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserClub&&(identical(other.id, id) || other.id == id)&&(identical(other.club, club) || other.club == club)&&(identical(other.member, member) || other.member == member)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.validatedAt, validatedAt) || other.validatedAt == validatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,club,member,const DeepCollectionEquality().hash(_roles),validatedAt,createdAt);

@override
String toString() {
  return 'UserClub(id: $id, club: $club, member: $member, roles: $roles, validatedAt: $validatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserClubCopyWith<$Res> implements $UserClubCopyWith<$Res> {
  factory _$UserClubCopyWith(_UserClub value, $Res Function(_UserClub) _then) = __$UserClubCopyWithImpl;
@override @useResult
$Res call({
 int id, Club club, User member, List<ClubRole> roles, DateTime? validatedAt, DateTime? createdAt
});


@override $ClubCopyWith<$Res> get club;@override $UserCopyWith<$Res> get member;

}
/// @nodoc
class __$UserClubCopyWithImpl<$Res>
    implements _$UserClubCopyWith<$Res> {
  __$UserClubCopyWithImpl(this._self, this._then);

  final _UserClub _self;
  final $Res Function(_UserClub) _then;

/// Create a copy of UserClub
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? club = null,Object? member = null,Object? roles = null,Object? validatedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_UserClub(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,club: null == club ? _self.club : club // ignore: cast_nullable_to_non_nullable
as Club,member: null == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as User,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<ClubRole>,validatedAt: freezed == validatedAt ? _self.validatedAt : validatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of UserClub
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClubCopyWith<$Res> get club {
  
  return $ClubCopyWith<$Res>(_self.club, (value) {
    return _then(_self.copyWith(club: value));
  });
}/// Create a copy of UserClub
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get member {
  
  return $UserCopyWith<$Res>(_self.member, (value) {
    return _then(_self.copyWith(member: value));
  });
}
}

// dart format on
