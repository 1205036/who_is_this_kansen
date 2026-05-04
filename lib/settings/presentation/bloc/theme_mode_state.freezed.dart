// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_mode_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThemeModeState {

 AppThemeMode get preference; ThemeModeStatus get status; String? get errorMessage;
/// Create a copy of ThemeModeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeModeStateCopyWith<ThemeModeState> get copyWith => _$ThemeModeStateCopyWithImpl<ThemeModeState>(this as ThemeModeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeModeState&&(identical(other.preference, preference) || other.preference == preference)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,preference,status,errorMessage);

@override
String toString() {
  return 'ThemeModeState(preference: $preference, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ThemeModeStateCopyWith<$Res>  {
  factory $ThemeModeStateCopyWith(ThemeModeState value, $Res Function(ThemeModeState) _then) = _$ThemeModeStateCopyWithImpl;
@useResult
$Res call({
 AppThemeMode preference, ThemeModeStatus status, String? errorMessage
});




}
/// @nodoc
class _$ThemeModeStateCopyWithImpl<$Res>
    implements $ThemeModeStateCopyWith<$Res> {
  _$ThemeModeStateCopyWithImpl(this._self, this._then);

  final ThemeModeState _self;
  final $Res Function(ThemeModeState) _then;

/// Create a copy of ThemeModeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preference = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as AppThemeMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ThemeModeStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemeModeState].
extension ThemeModeStatePatterns on ThemeModeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThemeModeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThemeModeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThemeModeState value)  $default,){
final _that = this;
switch (_that) {
case _ThemeModeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThemeModeState value)?  $default,){
final _that = this;
switch (_that) {
case _ThemeModeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppThemeMode preference,  ThemeModeStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThemeModeState() when $default != null:
return $default(_that.preference,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppThemeMode preference,  ThemeModeStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ThemeModeState():
return $default(_that.preference,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppThemeMode preference,  ThemeModeStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ThemeModeState() when $default != null:
return $default(_that.preference,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ThemeModeState extends ThemeModeState {
  const _ThemeModeState({this.preference = AppThemeMode.system, this.status = ThemeModeStatus.initial, this.errorMessage}): super._();
  

@override@JsonKey() final  AppThemeMode preference;
@override@JsonKey() final  ThemeModeStatus status;
@override final  String? errorMessage;

/// Create a copy of ThemeModeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThemeModeStateCopyWith<_ThemeModeState> get copyWith => __$ThemeModeStateCopyWithImpl<_ThemeModeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThemeModeState&&(identical(other.preference, preference) || other.preference == preference)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,preference,status,errorMessage);

@override
String toString() {
  return 'ThemeModeState(preference: $preference, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ThemeModeStateCopyWith<$Res> implements $ThemeModeStateCopyWith<$Res> {
  factory _$ThemeModeStateCopyWith(_ThemeModeState value, $Res Function(_ThemeModeState) _then) = __$ThemeModeStateCopyWithImpl;
@override @useResult
$Res call({
 AppThemeMode preference, ThemeModeStatus status, String? errorMessage
});




}
/// @nodoc
class __$ThemeModeStateCopyWithImpl<$Res>
    implements _$ThemeModeStateCopyWith<$Res> {
  __$ThemeModeStateCopyWithImpl(this._self, this._then);

  final _ThemeModeState _self;
  final $Res Function(_ThemeModeState) _then;

/// Create a copy of ThemeModeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preference = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_ThemeModeState(
preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as AppThemeMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ThemeModeStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
