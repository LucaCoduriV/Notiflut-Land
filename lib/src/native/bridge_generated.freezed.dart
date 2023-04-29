// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_generated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError('It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DeamonAction {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showLast,
    required TResult Function(int field0) close,
    required TResult Function() closeAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showLast,
    TResult? Function(int field0)? close,
    TResult? Function()? closeAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showLast,
    TResult Function(int field0)? close,
    TResult Function()? closeAll,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowLast value) showLast,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_CloseAll value) closeAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowLast value)? showLast,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_CloseAll value)? closeAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowLast value)? showLast,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_CloseAll value)? closeAll,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeamonActionCopyWith<$Res> {
  factory $DeamonActionCopyWith(DeamonAction value, $Res Function(DeamonAction) then) = _$DeamonActionCopyWithImpl<$Res, DeamonAction>;
}

/// @nodoc
class _$DeamonActionCopyWithImpl<$Res, $Val extends DeamonAction> implements $DeamonActionCopyWith<$Res> {
  _$DeamonActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DeamonAction_ShowCopyWith<$Res> {
  factory _$$DeamonAction_ShowCopyWith(_$DeamonAction_Show value, $Res Function(_$DeamonAction_Show) then) = __$$DeamonAction_ShowCopyWithImpl<$Res>;
  @useResult
  $Res call({Notification field0});
}

/// @nodoc
class __$$DeamonAction_ShowCopyWithImpl<$Res> extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_Show> implements _$$DeamonAction_ShowCopyWith<$Res> {
  __$$DeamonAction_ShowCopyWithImpl(_$DeamonAction_Show _value, $Res Function(_$DeamonAction_Show) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$DeamonAction_Show(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Notification,
    ));
  }
}

/// @nodoc

class _$DeamonAction_Show implements DeamonAction_Show {
  const _$DeamonAction_Show(this.field0);

  @override
  final Notification field0;

  @override
  String toString() {
    return 'DeamonAction.show(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _$DeamonAction_Show && (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_ShowCopyWith<_$DeamonAction_Show> get copyWith => __$$DeamonAction_ShowCopyWithImpl<_$DeamonAction_Show>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showLast,
    required TResult Function(int field0) close,
    required TResult Function() closeAll,
  }) {
    return show(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showLast,
    TResult? Function(int field0)? close,
    TResult? Function()? closeAll,
  }) {
    return show?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showLast,
    TResult Function(int field0)? close,
    TResult Function()? closeAll,
    required TResult orElse(),
  }) {
    if (show != null) {
      return show(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowLast value) showLast,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_CloseAll value) closeAll,
  }) {
    return show(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowLast value)? showLast,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_CloseAll value)? closeAll,
  }) {
    return show?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowLast value)? showLast,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_CloseAll value)? closeAll,
    required TResult orElse(),
  }) {
    if (show != null) {
      return show(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_Show implements DeamonAction {
  const factory DeamonAction_Show(final Notification field0) = _$DeamonAction_Show;

  Notification get field0;
  @JsonKey(ignore: true)
  _$$DeamonAction_ShowCopyWith<_$DeamonAction_Show> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeamonAction_ShowLastCopyWith<$Res> {
  factory _$$DeamonAction_ShowLastCopyWith(_$DeamonAction_ShowLast value, $Res Function(_$DeamonAction_ShowLast) then) = __$$DeamonAction_ShowLastCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeamonAction_ShowLastCopyWithImpl<$Res> extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_ShowLast> implements _$$DeamonAction_ShowLastCopyWith<$Res> {
  __$$DeamonAction_ShowLastCopyWithImpl(_$DeamonAction_ShowLast _value, $Res Function(_$DeamonAction_ShowLast) _then) : super(_value, _then);
}

/// @nodoc

class _$DeamonAction_ShowLast implements DeamonAction_ShowLast {
  const _$DeamonAction_ShowLast();

  @override
  String toString() {
    return 'DeamonAction.showLast()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _$DeamonAction_ShowLast);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showLast,
    required TResult Function(int field0) close,
    required TResult Function() closeAll,
  }) {
    return showLast();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showLast,
    TResult? Function(int field0)? close,
    TResult? Function()? closeAll,
  }) {
    return showLast?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showLast,
    TResult Function(int field0)? close,
    TResult Function()? closeAll,
    required TResult orElse(),
  }) {
    if (showLast != null) {
      return showLast();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowLast value) showLast,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_CloseAll value) closeAll,
  }) {
    return showLast(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowLast value)? showLast,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_CloseAll value)? closeAll,
  }) {
    return showLast?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowLast value)? showLast,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_CloseAll value)? closeAll,
    required TResult orElse(),
  }) {
    if (showLast != null) {
      return showLast(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_ShowLast implements DeamonAction {
  const factory DeamonAction_ShowLast() = _$DeamonAction_ShowLast;
}

/// @nodoc
abstract class _$$DeamonAction_CloseCopyWith<$Res> {
  factory _$$DeamonAction_CloseCopyWith(_$DeamonAction_Close value, $Res Function(_$DeamonAction_Close) then) = __$$DeamonAction_CloseCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$DeamonAction_CloseCopyWithImpl<$Res> extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_Close> implements _$$DeamonAction_CloseCopyWith<$Res> {
  __$$DeamonAction_CloseCopyWithImpl(_$DeamonAction_Close _value, $Res Function(_$DeamonAction_Close) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$DeamonAction_Close(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeamonAction_Close implements DeamonAction_Close {
  const _$DeamonAction_Close(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'DeamonAction.close(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _$DeamonAction_Close && (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_CloseCopyWith<_$DeamonAction_Close> get copyWith => __$$DeamonAction_CloseCopyWithImpl<_$DeamonAction_Close>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showLast,
    required TResult Function(int field0) close,
    required TResult Function() closeAll,
  }) {
    return close(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showLast,
    TResult? Function(int field0)? close,
    TResult? Function()? closeAll,
  }) {
    return close?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showLast,
    TResult Function(int field0)? close,
    TResult Function()? closeAll,
    required TResult orElse(),
  }) {
    if (close != null) {
      return close(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowLast value) showLast,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_CloseAll value) closeAll,
  }) {
    return close(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowLast value)? showLast,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_CloseAll value)? closeAll,
  }) {
    return close?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowLast value)? showLast,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_CloseAll value)? closeAll,
    required TResult orElse(),
  }) {
    if (close != null) {
      return close(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_Close implements DeamonAction {
  const factory DeamonAction_Close(final int field0) = _$DeamonAction_Close;

  int get field0;
  @JsonKey(ignore: true)
  _$$DeamonAction_CloseCopyWith<_$DeamonAction_Close> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeamonAction_CloseAllCopyWith<$Res> {
  factory _$$DeamonAction_CloseAllCopyWith(_$DeamonAction_CloseAll value, $Res Function(_$DeamonAction_CloseAll) then) = __$$DeamonAction_CloseAllCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeamonAction_CloseAllCopyWithImpl<$Res> extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_CloseAll> implements _$$DeamonAction_CloseAllCopyWith<$Res> {
  __$$DeamonAction_CloseAllCopyWithImpl(_$DeamonAction_CloseAll _value, $Res Function(_$DeamonAction_CloseAll) _then) : super(_value, _then);
}

/// @nodoc

class _$DeamonAction_CloseAll implements DeamonAction_CloseAll {
  const _$DeamonAction_CloseAll();

  @override
  String toString() {
    return 'DeamonAction.closeAll()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _$DeamonAction_CloseAll);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showLast,
    required TResult Function(int field0) close,
    required TResult Function() closeAll,
  }) {
    return closeAll();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showLast,
    TResult? Function(int field0)? close,
    TResult? Function()? closeAll,
  }) {
    return closeAll?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showLast,
    TResult Function(int field0)? close,
    TResult Function()? closeAll,
    required TResult orElse(),
  }) {
    if (closeAll != null) {
      return closeAll();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowLast value) showLast,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_CloseAll value) closeAll,
  }) {
    return closeAll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowLast value)? showLast,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_CloseAll value)? closeAll,
  }) {
    return closeAll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowLast value)? showLast,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_CloseAll value)? closeAll,
    required TResult orElse(),
  }) {
    if (closeAll != null) {
      return closeAll(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_CloseAll implements DeamonAction {
  const factory DeamonAction_CloseAll() = _$DeamonAction_CloseAll;
}
