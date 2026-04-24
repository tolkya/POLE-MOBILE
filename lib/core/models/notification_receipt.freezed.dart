// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_receipt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationEvent {

 int get id; String? get notifType; String? get subjectType; int? get subjectId; Map<String, dynamic> get context; User? get triggeredBy; DateTime? get createdAt;
/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationEventCopyWith<NotificationEvent> get copyWith => _$NotificationEventCopyWithImpl<NotificationEvent>(this as NotificationEvent, _$identity);

  /// Serializes this NotificationEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.notifType, notifType) || other.notifType == notifType)&&(identical(other.subjectType, subjectType) || other.subjectType == subjectType)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&const DeepCollectionEquality().equals(other.context, context)&&(identical(other.triggeredBy, triggeredBy) || other.triggeredBy == triggeredBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,notifType,subjectType,subjectId,const DeepCollectionEquality().hash(context),triggeredBy,createdAt);

@override
String toString() {
  return 'NotificationEvent(id: $id, notifType: $notifType, subjectType: $subjectType, subjectId: $subjectId, context: $context, triggeredBy: $triggeredBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NotificationEventCopyWith<$Res>  {
  factory $NotificationEventCopyWith(NotificationEvent value, $Res Function(NotificationEvent) _then) = _$NotificationEventCopyWithImpl;
@useResult
$Res call({
 int id, String? notifType, String? subjectType, int? subjectId, Map<String, dynamic> context, User? triggeredBy, DateTime? createdAt
});


$UserCopyWith<$Res>? get triggeredBy;

}
/// @nodoc
class _$NotificationEventCopyWithImpl<$Res>
    implements $NotificationEventCopyWith<$Res> {
  _$NotificationEventCopyWithImpl(this._self, this._then);

  final NotificationEvent _self;
  final $Res Function(NotificationEvent) _then;

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? notifType = freezed,Object? subjectType = freezed,Object? subjectId = freezed,Object? context = null,Object? triggeredBy = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,notifType: freezed == notifType ? _self.notifType : notifType // ignore: cast_nullable_to_non_nullable
as String?,subjectType: freezed == subjectType ? _self.subjectType : subjectType // ignore: cast_nullable_to_non_nullable
as String?,subjectId: freezed == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as int?,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,triggeredBy: freezed == triggeredBy ? _self.triggeredBy : triggeredBy // ignore: cast_nullable_to_non_nullable
as User?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get triggeredBy {
    if (_self.triggeredBy == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.triggeredBy!, (value) {
    return _then(_self.copyWith(triggeredBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationEvent].
extension NotificationEventPatterns on NotificationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationEvent value)  $default,){
final _that = this;
switch (_that) {
case _NotificationEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationEvent value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? notifType,  String? subjectType,  int? subjectId,  Map<String, dynamic> context,  User? triggeredBy,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
return $default(_that.id,_that.notifType,_that.subjectType,_that.subjectId,_that.context,_that.triggeredBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? notifType,  String? subjectType,  int? subjectId,  Map<String, dynamic> context,  User? triggeredBy,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationEvent():
return $default(_that.id,_that.notifType,_that.subjectType,_that.subjectId,_that.context,_that.triggeredBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? notifType,  String? subjectType,  int? subjectId,  Map<String, dynamic> context,  User? triggeredBy,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
return $default(_that.id,_that.notifType,_that.subjectType,_that.subjectId,_that.context,_that.triggeredBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationEvent implements NotificationEvent {
  const _NotificationEvent({required this.id, this.notifType, this.subjectType, this.subjectId, final  Map<String, dynamic> context = const {}, this.triggeredBy, this.createdAt}): _context = context;
  factory _NotificationEvent.fromJson(Map<String, dynamic> json) => _$NotificationEventFromJson(json);

@override final  int id;
@override final  String? notifType;
@override final  String? subjectType;
@override final  int? subjectId;
 final  Map<String, dynamic> _context;
@override@JsonKey() Map<String, dynamic> get context {
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_context);
}

@override final  User? triggeredBy;
@override final  DateTime? createdAt;

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationEventCopyWith<_NotificationEvent> get copyWith => __$NotificationEventCopyWithImpl<_NotificationEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.notifType, notifType) || other.notifType == notifType)&&(identical(other.subjectType, subjectType) || other.subjectType == subjectType)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&const DeepCollectionEquality().equals(other._context, _context)&&(identical(other.triggeredBy, triggeredBy) || other.triggeredBy == triggeredBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,notifType,subjectType,subjectId,const DeepCollectionEquality().hash(_context),triggeredBy,createdAt);

@override
String toString() {
  return 'NotificationEvent(id: $id, notifType: $notifType, subjectType: $subjectType, subjectId: $subjectId, context: $context, triggeredBy: $triggeredBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationEventCopyWith<$Res> implements $NotificationEventCopyWith<$Res> {
  factory _$NotificationEventCopyWith(_NotificationEvent value, $Res Function(_NotificationEvent) _then) = __$NotificationEventCopyWithImpl;
@override @useResult
$Res call({
 int id, String? notifType, String? subjectType, int? subjectId, Map<String, dynamic> context, User? triggeredBy, DateTime? createdAt
});


@override $UserCopyWith<$Res>? get triggeredBy;

}
/// @nodoc
class __$NotificationEventCopyWithImpl<$Res>
    implements _$NotificationEventCopyWith<$Res> {
  __$NotificationEventCopyWithImpl(this._self, this._then);

  final _NotificationEvent _self;
  final $Res Function(_NotificationEvent) _then;

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? notifType = freezed,Object? subjectType = freezed,Object? subjectId = freezed,Object? context = null,Object? triggeredBy = freezed,Object? createdAt = freezed,}) {
  return _then(_NotificationEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,notifType: freezed == notifType ? _self.notifType : notifType // ignore: cast_nullable_to_non_nullable
as String?,subjectType: freezed == subjectType ? _self.subjectType : subjectType // ignore: cast_nullable_to_non_nullable
as String?,subjectId: freezed == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as int?,context: null == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,triggeredBy: freezed == triggeredBy ? _self.triggeredBy : triggeredBy // ignore: cast_nullable_to_non_nullable
as User?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get triggeredBy {
    if (_self.triggeredBy == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.triggeredBy!, (value) {
    return _then(_self.copyWith(triggeredBy: value));
  });
}
}


/// @nodoc
mixin _$NotificationReceipt {

 int get id; NotificationEvent get event; bool get isRead; DateTime? get readAt; DateTime? get createdAt;
/// Create a copy of NotificationReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationReceiptCopyWith<NotificationReceipt> get copyWith => _$NotificationReceiptCopyWithImpl<NotificationReceipt>(this as NotificationReceipt, _$identity);

  /// Serializes this NotificationReceipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationReceipt&&(identical(other.id, id) || other.id == id)&&(identical(other.event, event) || other.event == event)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,event,isRead,readAt,createdAt);

@override
String toString() {
  return 'NotificationReceipt(id: $id, event: $event, isRead: $isRead, readAt: $readAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NotificationReceiptCopyWith<$Res>  {
  factory $NotificationReceiptCopyWith(NotificationReceipt value, $Res Function(NotificationReceipt) _then) = _$NotificationReceiptCopyWithImpl;
@useResult
$Res call({
 int id, NotificationEvent event, bool isRead, DateTime? readAt, DateTime? createdAt
});


$NotificationEventCopyWith<$Res> get event;

}
/// @nodoc
class _$NotificationReceiptCopyWithImpl<$Res>
    implements $NotificationReceiptCopyWith<$Res> {
  _$NotificationReceiptCopyWithImpl(this._self, this._then);

  final NotificationReceipt _self;
  final $Res Function(NotificationReceipt) _then;

/// Create a copy of NotificationReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? event = null,Object? isRead = null,Object? readAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as NotificationEvent,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of NotificationReceipt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEventCopyWith<$Res> get event {
  
  return $NotificationEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationReceipt].
extension NotificationReceiptPatterns on NotificationReceipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationReceipt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationReceipt value)  $default,){
final _that = this;
switch (_that) {
case _NotificationReceipt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationReceipt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  NotificationEvent event,  bool isRead,  DateTime? readAt,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationReceipt() when $default != null:
return $default(_that.id,_that.event,_that.isRead,_that.readAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  NotificationEvent event,  bool isRead,  DateTime? readAt,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationReceipt():
return $default(_that.id,_that.event,_that.isRead,_that.readAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  NotificationEvent event,  bool isRead,  DateTime? readAt,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationReceipt() when $default != null:
return $default(_that.id,_that.event,_that.isRead,_that.readAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationReceipt implements NotificationReceipt {
  const _NotificationReceipt({required this.id, required this.event, this.isRead = false, this.readAt, this.createdAt});
  factory _NotificationReceipt.fromJson(Map<String, dynamic> json) => _$NotificationReceiptFromJson(json);

@override final  int id;
@override final  NotificationEvent event;
@override@JsonKey() final  bool isRead;
@override final  DateTime? readAt;
@override final  DateTime? createdAt;

/// Create a copy of NotificationReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationReceiptCopyWith<_NotificationReceipt> get copyWith => __$NotificationReceiptCopyWithImpl<_NotificationReceipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationReceipt&&(identical(other.id, id) || other.id == id)&&(identical(other.event, event) || other.event == event)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,event,isRead,readAt,createdAt);

@override
String toString() {
  return 'NotificationReceipt(id: $id, event: $event, isRead: $isRead, readAt: $readAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationReceiptCopyWith<$Res> implements $NotificationReceiptCopyWith<$Res> {
  factory _$NotificationReceiptCopyWith(_NotificationReceipt value, $Res Function(_NotificationReceipt) _then) = __$NotificationReceiptCopyWithImpl;
@override @useResult
$Res call({
 int id, NotificationEvent event, bool isRead, DateTime? readAt, DateTime? createdAt
});


@override $NotificationEventCopyWith<$Res> get event;

}
/// @nodoc
class __$NotificationReceiptCopyWithImpl<$Res>
    implements _$NotificationReceiptCopyWith<$Res> {
  __$NotificationReceiptCopyWithImpl(this._self, this._then);

  final _NotificationReceipt _self;
  final $Res Function(_NotificationReceipt) _then;

/// Create a copy of NotificationReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? event = null,Object? isRead = null,Object? readAt = freezed,Object? createdAt = freezed,}) {
  return _then(_NotificationReceipt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as NotificationEvent,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of NotificationReceipt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEventCopyWith<$Res> get event {
  
  return $NotificationEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
