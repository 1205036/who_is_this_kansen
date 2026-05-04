// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_prompt_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizPromptState<T> {

 List<T> get prompts; int get activeIndex; QuizAnswerStatus get answerStatus; String get message;
/// Create a copy of QuizPromptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizPromptStateCopyWith<T, QuizPromptState<T>> get copyWith => _$QuizPromptStateCopyWithImpl<T, QuizPromptState<T>>(this as QuizPromptState<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizPromptState<T>&&const DeepCollectionEquality().equals(other.prompts, prompts)&&(identical(other.activeIndex, activeIndex) || other.activeIndex == activeIndex)&&(identical(other.answerStatus, answerStatus) || other.answerStatus == answerStatus)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(prompts),activeIndex,answerStatus,message);

@override
String toString() {
  return 'QuizPromptState<$T>(prompts: $prompts, activeIndex: $activeIndex, answerStatus: $answerStatus, message: $message)';
}


}

/// @nodoc
abstract mixin class $QuizPromptStateCopyWith<T,$Res>  {
  factory $QuizPromptStateCopyWith(QuizPromptState<T> value, $Res Function(QuizPromptState<T>) _then) = _$QuizPromptStateCopyWithImpl;
@useResult
$Res call({
 List<T> prompts, int activeIndex, QuizAnswerStatus answerStatus, String message
});




}
/// @nodoc
class _$QuizPromptStateCopyWithImpl<T,$Res>
    implements $QuizPromptStateCopyWith<T, $Res> {
  _$QuizPromptStateCopyWithImpl(this._self, this._then);

  final QuizPromptState<T> _self;
  final $Res Function(QuizPromptState<T>) _then;

/// Create a copy of QuizPromptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prompts = null,Object? activeIndex = null,Object? answerStatus = null,Object? message = null,}) {
  return _then(_self.copyWith(
prompts: null == prompts ? _self.prompts : prompts // ignore: cast_nullable_to_non_nullable
as List<T>,activeIndex: null == activeIndex ? _self.activeIndex : activeIndex // ignore: cast_nullable_to_non_nullable
as int,answerStatus: null == answerStatus ? _self.answerStatus : answerStatus // ignore: cast_nullable_to_non_nullable
as QuizAnswerStatus,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizPromptState].
extension QuizPromptStatePatterns<T> on QuizPromptState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizPromptState<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizPromptState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizPromptState<T> value)  $default,){
final _that = this;
switch (_that) {
case _QuizPromptState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizPromptState<T> value)?  $default,){
final _that = this;
switch (_that) {
case _QuizPromptState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> prompts,  int activeIndex,  QuizAnswerStatus answerStatus,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizPromptState() when $default != null:
return $default(_that.prompts,_that.activeIndex,_that.answerStatus,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> prompts,  int activeIndex,  QuizAnswerStatus answerStatus,  String message)  $default,) {final _that = this;
switch (_that) {
case _QuizPromptState():
return $default(_that.prompts,_that.activeIndex,_that.answerStatus,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> prompts,  int activeIndex,  QuizAnswerStatus answerStatus,  String message)?  $default,) {final _that = this;
switch (_that) {
case _QuizPromptState() when $default != null:
return $default(_that.prompts,_that.activeIndex,_that.answerStatus,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _QuizPromptState<T> extends QuizPromptState<T> {
  const _QuizPromptState({required final  List<T> prompts, this.activeIndex = 0, this.answerStatus = QuizAnswerStatus.awaitingAnswer, this.message = ''}): _prompts = prompts,super._();
  

 final  List<T> _prompts;
@override List<T> get prompts {
  if (_prompts is EqualUnmodifiableListView) return _prompts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prompts);
}

@override@JsonKey() final  int activeIndex;
@override@JsonKey() final  QuizAnswerStatus answerStatus;
@override@JsonKey() final  String message;

/// Create a copy of QuizPromptState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizPromptStateCopyWith<T, _QuizPromptState<T>> get copyWith => __$QuizPromptStateCopyWithImpl<T, _QuizPromptState<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizPromptState<T>&&const DeepCollectionEquality().equals(other._prompts, _prompts)&&(identical(other.activeIndex, activeIndex) || other.activeIndex == activeIndex)&&(identical(other.answerStatus, answerStatus) || other.answerStatus == answerStatus)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_prompts),activeIndex,answerStatus,message);

@override
String toString() {
  return 'QuizPromptState<$T>(prompts: $prompts, activeIndex: $activeIndex, answerStatus: $answerStatus, message: $message)';
}


}

/// @nodoc
abstract mixin class _$QuizPromptStateCopyWith<T,$Res> implements $QuizPromptStateCopyWith<T, $Res> {
  factory _$QuizPromptStateCopyWith(_QuizPromptState<T> value, $Res Function(_QuizPromptState<T>) _then) = __$QuizPromptStateCopyWithImpl;
@override @useResult
$Res call({
 List<T> prompts, int activeIndex, QuizAnswerStatus answerStatus, String message
});




}
/// @nodoc
class __$QuizPromptStateCopyWithImpl<T,$Res>
    implements _$QuizPromptStateCopyWith<T, $Res> {
  __$QuizPromptStateCopyWithImpl(this._self, this._then);

  final _QuizPromptState<T> _self;
  final $Res Function(_QuizPromptState<T>) _then;

/// Create a copy of QuizPromptState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prompts = null,Object? activeIndex = null,Object? answerStatus = null,Object? message = null,}) {
  return _then(_QuizPromptState<T>(
prompts: null == prompts ? _self._prompts : prompts // ignore: cast_nullable_to_non_nullable
as List<T>,activeIndex: null == activeIndex ? _self.activeIndex : activeIndex // ignore: cast_nullable_to_non_nullable
as int,answerStatus: null == answerStatus ? _self.answerStatus : answerStatus // ignore: cast_nullable_to_non_nullable
as QuizAnswerStatus,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
