// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unlock_toast_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnlockToastState {

 KansenViewModel? get kansen; int get generation;
/// Create a copy of UnlockToastState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnlockToastStateCopyWith<UnlockToastState> get copyWith => _$UnlockToastStateCopyWithImpl<UnlockToastState>(this as UnlockToastState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnlockToastState&&(identical(other.kansen, kansen) || other.kansen == kansen)&&(identical(other.generation, generation) || other.generation == generation));
}


@override
int get hashCode => Object.hash(runtimeType,kansen,generation);

@override
String toString() {
  return 'UnlockToastState(kansen: $kansen, generation: $generation)';
}


}

/// @nodoc
abstract mixin class $UnlockToastStateCopyWith<$Res>  {
  factory $UnlockToastStateCopyWith(UnlockToastState value, $Res Function(UnlockToastState) _then) = _$UnlockToastStateCopyWithImpl;
@useResult
$Res call({
 KansenViewModel? kansen, int generation
});




}
/// @nodoc
class _$UnlockToastStateCopyWithImpl<$Res>
    implements $UnlockToastStateCopyWith<$Res> {
  _$UnlockToastStateCopyWithImpl(this._self, this._then);

  final UnlockToastState _self;
  final $Res Function(UnlockToastState) _then;

/// Create a copy of UnlockToastState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kansen = freezed,Object? generation = null,}) {
  return _then(_self.copyWith(
kansen: freezed == kansen ? _self.kansen : kansen // ignore: cast_nullable_to_non_nullable
as KansenViewModel?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UnlockToastState].
extension UnlockToastStatePatterns on UnlockToastState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnlockToastState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnlockToastState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnlockToastState value)  $default,){
final _that = this;
switch (_that) {
case _UnlockToastState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnlockToastState value)?  $default,){
final _that = this;
switch (_that) {
case _UnlockToastState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KansenViewModel? kansen,  int generation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnlockToastState() when $default != null:
return $default(_that.kansen,_that.generation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KansenViewModel? kansen,  int generation)  $default,) {final _that = this;
switch (_that) {
case _UnlockToastState():
return $default(_that.kansen,_that.generation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KansenViewModel? kansen,  int generation)?  $default,) {final _that = this;
switch (_that) {
case _UnlockToastState() when $default != null:
return $default(_that.kansen,_that.generation);case _:
  return null;

}
}

}

/// @nodoc


class _UnlockToastState implements UnlockToastState {
  const _UnlockToastState({this.kansen, this.generation = 0});
  

@override final  KansenViewModel? kansen;
@override@JsonKey() final  int generation;

/// Create a copy of UnlockToastState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnlockToastStateCopyWith<_UnlockToastState> get copyWith => __$UnlockToastStateCopyWithImpl<_UnlockToastState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnlockToastState&&(identical(other.kansen, kansen) || other.kansen == kansen)&&(identical(other.generation, generation) || other.generation == generation));
}


@override
int get hashCode => Object.hash(runtimeType,kansen,generation);

@override
String toString() {
  return 'UnlockToastState(kansen: $kansen, generation: $generation)';
}


}

/// @nodoc
abstract mixin class _$UnlockToastStateCopyWith<$Res> implements $UnlockToastStateCopyWith<$Res> {
  factory _$UnlockToastStateCopyWith(_UnlockToastState value, $Res Function(_UnlockToastState) _then) = __$UnlockToastStateCopyWithImpl;
@override @useResult
$Res call({
 KansenViewModel? kansen, int generation
});




}
/// @nodoc
class __$UnlockToastStateCopyWithImpl<$Res>
    implements _$UnlockToastStateCopyWith<$Res> {
  __$UnlockToastStateCopyWithImpl(this._self, this._then);

  final _UnlockToastState _self;
  final $Res Function(_UnlockToastState) _then;

/// Create a copy of UnlockToastState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kansen = freezed,Object? generation = null,}) {
  return _then(_UnlockToastState(
kansen: freezed == kansen ? _self.kansen : kansen // ignore: cast_nullable_to_non_nullable
as KansenViewModel?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
