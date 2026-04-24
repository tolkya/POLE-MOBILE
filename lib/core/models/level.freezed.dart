// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Level {

 int get id; String get name; int get position; String? get description;
/// Create a copy of Level
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelCopyWith<Level> get copyWith => _$LevelCopyWithImpl<Level>(this as Level, _$identity);

  /// Serializes this Level to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Level&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,description);

@override
String toString() {
  return 'Level(id: $id, name: $name, position: $position, description: $description)';
}


}

/// @nodoc
abstract mixin class $LevelCopyWith<$Res>  {
  factory $LevelCopyWith(Level value, $Res Function(Level) _then) = _$LevelCopyWithImpl;
@useResult
$Res call({
 int id, String name, int position, String? description
});




}
/// @nodoc
class _$LevelCopyWithImpl<$Res>
    implements $LevelCopyWith<$Res> {
  _$LevelCopyWithImpl(this._self, this._then);

  final Level _self;
  final $Res Function(Level) _then;

/// Create a copy of Level
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? position = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Level].
extension LevelPatterns on Level {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Level value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Level() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Level value)  $default,){
final _that = this;
switch (_that) {
case _Level():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Level value)?  $default,){
final _that = this;
switch (_that) {
case _Level() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int position,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Level() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int position,  String? description)  $default,) {final _that = this;
switch (_that) {
case _Level():
return $default(_that.id,_that.name,_that.position,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int position,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _Level() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Level implements Level {
  const _Level({required this.id, required this.name, required this.position, this.description});
  factory _Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);

@override final  int id;
@override final  String name;
@override final  int position;
@override final  String? description;

/// Create a copy of Level
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LevelCopyWith<_Level> get copyWith => __$LevelCopyWithImpl<_Level>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LevelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Level&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,description);

@override
String toString() {
  return 'Level(id: $id, name: $name, position: $position, description: $description)';
}


}

/// @nodoc
abstract mixin class _$LevelCopyWith<$Res> implements $LevelCopyWith<$Res> {
  factory _$LevelCopyWith(_Level value, $Res Function(_Level) _then) = __$LevelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int position, String? description
});




}
/// @nodoc
class __$LevelCopyWithImpl<$Res>
    implements _$LevelCopyWith<$Res> {
  __$LevelCopyWithImpl(this._self, this._then);

  final _Level _self;
  final $Res Function(_Level) _then;

/// Create a copy of Level
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? position = null,Object? description = freezed,}) {
  return _then(_Level(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
