// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unlock_progress_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnlockProgressState {

 UnlockProgress get progress; UnlockProgressStatus get status; String? get errorMessage;
/// Create a copy of UnlockProgressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnlockProgressStateCopyWith<UnlockProgressState> get copyWith => _$UnlockProgressStateCopyWithImpl<UnlockProgressState>(this as UnlockProgressState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnlockProgressState&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,progress,status,errorMessage);

@override
String toString() {
  return 'UnlockProgressState(progress: $progress, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $UnlockProgressStateCopyWith<$Res>  {
  factory $UnlockProgressStateCopyWith(UnlockProgressState value, $Res Function(UnlockProgressState) _then) = _$UnlockProgressStateCopyWithImpl;
@useResult
$Res call({
 UnlockProgress progress, UnlockProgressStatus status, String? errorMessage
});




}
/// @nodoc
class _$UnlockProgressStateCopyWithImpl<$Res>
    implements $UnlockProgressStateCopyWith<$Res> {
  _$UnlockProgressStateCopyWithImpl(this._self, this._then);

  final UnlockProgressState _self;
  final $Res Function(UnlockProgressState) _then;

/// Create a copy of UnlockProgressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progress = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as UnlockProgress,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnlockProgressStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UnlockProgressState].
extension UnlockProgressStatePatterns on UnlockProgressState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnlockProgressState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnlockProgressState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnlockProgressState value)  $default,){
final _that = this;
switch (_that) {
case _UnlockProgressState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnlockProgressState value)?  $default,){
final _that = this;
switch (_that) {
case _UnlockProgressState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UnlockProgress progress,  UnlockProgressStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnlockProgressState() when $default != null:
return $default(_that.progress,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UnlockProgress progress,  UnlockProgressStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _UnlockProgressState():
return $default(_that.progress,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UnlockProgress progress,  UnlockProgressStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _UnlockProgressState() when $default != null:
return $default(_that.progress,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _UnlockProgressState extends UnlockProgressState {
  const _UnlockProgressState({this.progress = const UnlockProgress(unlockedKansenIds: <String>{}), this.status = UnlockProgressStatus.initial, this.errorMessage}): super._();
  

@override@JsonKey() final  UnlockProgress progress;
@override@JsonKey() final  UnlockProgressStatus status;
@override final  String? errorMessage;

/// Create a copy of UnlockProgressState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnlockProgressStateCopyWith<_UnlockProgressState> get copyWith => __$UnlockProgressStateCopyWithImpl<_UnlockProgressState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnlockProgressState&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,progress,status,errorMessage);

@override
String toString() {
  return 'UnlockProgressState(progress: $progress, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$UnlockProgressStateCopyWith<$Res> implements $UnlockProgressStateCopyWith<$Res> {
  factory _$UnlockProgressStateCopyWith(_UnlockProgressState value, $Res Function(_UnlockProgressState) _then) = __$UnlockProgressStateCopyWithImpl;
@override @useResult
$Res call({
 UnlockProgress progress, UnlockProgressStatus status, String? errorMessage
});




}
/// @nodoc
class __$UnlockProgressStateCopyWithImpl<$Res>
    implements _$UnlockProgressStateCopyWith<$Res> {
  __$UnlockProgressStateCopyWithImpl(this._self, this._then);

  final _UnlockProgressState _self;
  final $Res Function(_UnlockProgressState) _then;

/// Create a copy of UnlockProgressState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progress = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_UnlockProgressState(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as UnlockProgress,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnlockProgressStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
