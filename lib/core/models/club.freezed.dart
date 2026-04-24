// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Club {

 int get id; String get name; String? get phone; String? get email; JoinPolicy? get joinPolicy; String? get themeColor; String? get clubCode; String? get logoUrl;
/// Create a copy of Club
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClubCopyWith<Club> get copyWith => _$ClubCopyWithImpl<Club>(this as Club, _$identity);

  /// Serializes this Club to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Club&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.joinPolicy, joinPolicy) || other.joinPolicy == joinPolicy)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.clubCode, clubCode) || other.clubCode == clubCode)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,email,joinPolicy,themeColor,clubCode,logoUrl);

@override
String toString() {
  return 'Club(id: $id, name: $name, phone: $phone, email: $email, joinPolicy: $joinPolicy, themeColor: $themeColor, clubCode: $clubCode, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class $ClubCopyWith<$Res>  {
  factory $ClubCopyWith(Club value, $Res Function(Club) _then) = _$ClubCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? phone, String? email, JoinPolicy? joinPolicy, String? themeColor, String? clubCode, String? logoUrl
});




}
/// @nodoc
class _$ClubCopyWithImpl<$Res>
    implements $ClubCopyWith<$Res> {
  _$ClubCopyWithImpl(this._self, this._then);

  final Club _self;
  final $Res Function(Club) _then;

/// Create a copy of Club
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = freezed,Object? email = freezed,Object? joinPolicy = freezed,Object? themeColor = freezed,Object? clubCode = freezed,Object? logoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,joinPolicy: freezed == joinPolicy ? _self.joinPolicy : joinPolicy // ignore: cast_nullable_to_non_nullable
as JoinPolicy?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,clubCode: freezed == clubCode ? _self.clubCode : clubCode // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Club].
extension ClubPatterns on Club {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Club value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Club() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Club value)  $default,){
final _that = this;
switch (_that) {
case _Club():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Club value)?  $default,){
final _that = this;
switch (_that) {
case _Club() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? phone,  String? email,  JoinPolicy? joinPolicy,  String? themeColor,  String? clubCode,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Club() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.joinPolicy,_that.themeColor,_that.clubCode,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? phone,  String? email,  JoinPolicy? joinPolicy,  String? themeColor,  String? clubCode,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _Club():
return $default(_that.id,_that.name,_that.phone,_that.email,_that.joinPolicy,_that.themeColor,_that.clubCode,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? phone,  String? email,  JoinPolicy? joinPolicy,  String? themeColor,  String? clubCode,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _Club() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.joinPolicy,_that.themeColor,_that.clubCode,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Club implements Club {
  const _Club({required this.id, required this.name, this.phone, this.email, this.joinPolicy, this.themeColor, this.clubCode, this.logoUrl});
  factory _Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? phone;
@override final  String? email;
@override final  JoinPolicy? joinPolicy;
@override final  String? themeColor;
@override final  String? clubCode;
@override final  String? logoUrl;

/// Create a copy of Club
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClubCopyWith<_Club> get copyWith => __$ClubCopyWithImpl<_Club>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClubToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Club&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.joinPolicy, joinPolicy) || other.joinPolicy == joinPolicy)&&(identical(other.themeColor, themeColor) || other.themeColor == themeColor)&&(identical(other.clubCode, clubCode) || other.clubCode == clubCode)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,email,joinPolicy,themeColor,clubCode,logoUrl);

@override
String toString() {
  return 'Club(id: $id, name: $name, phone: $phone, email: $email, joinPolicy: $joinPolicy, themeColor: $themeColor, clubCode: $clubCode, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$ClubCopyWith<$Res> implements $ClubCopyWith<$Res> {
  factory _$ClubCopyWith(_Club value, $Res Function(_Club) _then) = __$ClubCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? phone, String? email, JoinPolicy? joinPolicy, String? themeColor, String? clubCode, String? logoUrl
});




}
/// @nodoc
class __$ClubCopyWithImpl<$Res>
    implements _$ClubCopyWith<$Res> {
  __$ClubCopyWithImpl(this._self, this._then);

  final _Club _self;
  final $Res Function(_Club) _then;

/// Create a copy of Club
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = freezed,Object? email = freezed,Object? joinPolicy = freezed,Object? themeColor = freezed,Object? clubCode = freezed,Object? logoUrl = freezed,}) {
  return _then(_Club(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,joinPolicy: freezed == joinPolicy ? _self.joinPolicy : joinPolicy // ignore: cast_nullable_to_non_nullable
as JoinPolicy?,themeColor: freezed == themeColor ? _self.themeColor : themeColor // ignore: cast_nullable_to_non_nullable
as String?,clubCode: freezed == clubCode ? _self.clubCode : clubCode // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
