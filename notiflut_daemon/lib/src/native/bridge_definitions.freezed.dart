// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_definitions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DeamonAction {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeamonActionCopyWith<$Res> {
  factory $DeamonActionCopyWith(
          DeamonAction value, $Res Function(DeamonAction) then) =
      _$DeamonActionCopyWithImpl<$Res, DeamonAction>;
}

/// @nodoc
class _$DeamonActionCopyWithImpl<$Res, $Val extends DeamonAction>
    implements $DeamonActionCopyWith<$Res> {
  _$DeamonActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DeamonAction_ShowCopyWith<$Res> {
  factory _$$DeamonAction_ShowCopyWith(
          _$DeamonAction_Show value, $Res Function(_$DeamonAction_Show) then) =
      __$$DeamonAction_ShowCopyWithImpl<$Res>;
  @useResult
  $Res call({Notification field0});
}

/// @nodoc
class __$$DeamonAction_ShowCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_Show>
    implements _$$DeamonAction_ShowCopyWith<$Res> {
  __$$DeamonAction_ShowCopyWithImpl(
      _$DeamonAction_Show _value, $Res Function(_$DeamonAction_Show) _then)
      : super(_value, _then);

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
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_Show &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_ShowCopyWith<_$DeamonAction_Show> get copyWith =>
      __$$DeamonAction_ShowCopyWithImpl<_$DeamonAction_Show>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) {
    return show(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) {
    return show?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
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
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) {
    return show(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) {
    return show?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (show != null) {
      return show(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_Show implements DeamonAction {
  const factory DeamonAction_Show(final Notification field0) =
      _$DeamonAction_Show;

  Notification get field0;
  @JsonKey(ignore: true)
  _$$DeamonAction_ShowCopyWith<_$DeamonAction_Show> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeamonAction_ShowNcCopyWith<$Res> {
  factory _$$DeamonAction_ShowNcCopyWith(_$DeamonAction_ShowNc value,
          $Res Function(_$DeamonAction_ShowNc) then) =
      __$$DeamonAction_ShowNcCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeamonAction_ShowNcCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_ShowNc>
    implements _$$DeamonAction_ShowNcCopyWith<$Res> {
  __$$DeamonAction_ShowNcCopyWithImpl(
      _$DeamonAction_ShowNc _value, $Res Function(_$DeamonAction_ShowNc) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DeamonAction_ShowNc implements DeamonAction_ShowNc {
  const _$DeamonAction_ShowNc();

  @override
  String toString() {
    return 'DeamonAction.showNc()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeamonAction_ShowNc);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) {
    return showNc();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) {
    return showNc?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (showNc != null) {
      return showNc();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) {
    return showNc(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) {
    return showNc?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (showNc != null) {
      return showNc(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_ShowNc implements DeamonAction {
  const factory DeamonAction_ShowNc() = _$DeamonAction_ShowNc;
}

/// @nodoc
abstract class _$$DeamonAction_CloseNcCopyWith<$Res> {
  factory _$$DeamonAction_CloseNcCopyWith(_$DeamonAction_CloseNc value,
          $Res Function(_$DeamonAction_CloseNc) then) =
      __$$DeamonAction_CloseNcCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeamonAction_CloseNcCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_CloseNc>
    implements _$$DeamonAction_CloseNcCopyWith<$Res> {
  __$$DeamonAction_CloseNcCopyWithImpl(_$DeamonAction_CloseNc _value,
      $Res Function(_$DeamonAction_CloseNc) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DeamonAction_CloseNc implements DeamonAction_CloseNc {
  const _$DeamonAction_CloseNc();

  @override
  String toString() {
    return 'DeamonAction.closeNc()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeamonAction_CloseNc);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) {
    return closeNc();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) {
    return closeNc?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (closeNc != null) {
      return closeNc();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) {
    return closeNc(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) {
    return closeNc?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (closeNc != null) {
      return closeNc(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_CloseNc implements DeamonAction {
  const factory DeamonAction_CloseNc() = _$DeamonAction_CloseNc;
}

/// @nodoc
abstract class _$$DeamonAction_CloseCopyWith<$Res> {
  factory _$$DeamonAction_CloseCopyWith(_$DeamonAction_Close value,
          $Res Function(_$DeamonAction_Close) then) =
      __$$DeamonAction_CloseCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$DeamonAction_CloseCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_Close>
    implements _$$DeamonAction_CloseCopyWith<$Res> {
  __$$DeamonAction_CloseCopyWithImpl(
      _$DeamonAction_Close _value, $Res Function(_$DeamonAction_Close) _then)
      : super(_value, _then);

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
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_Close &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_CloseCopyWith<_$DeamonAction_Close> get copyWith =>
      __$$DeamonAction_CloseCopyWithImpl<_$DeamonAction_Close>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) {
    return close(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) {
    return close?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
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
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) {
    return close(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) {
    return close?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
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
  _$$DeamonAction_CloseCopyWith<_$DeamonAction_Close> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeamonAction_UpdateCopyWith<$Res> {
  factory _$$DeamonAction_UpdateCopyWith(_$DeamonAction_Update value,
          $Res Function(_$DeamonAction_Update) then) =
      __$$DeamonAction_UpdateCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Notification> field0, int? field1});
}

/// @nodoc
class __$$DeamonAction_UpdateCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_Update>
    implements _$$DeamonAction_UpdateCopyWith<$Res> {
  __$$DeamonAction_UpdateCopyWithImpl(
      _$DeamonAction_Update _value, $Res Function(_$DeamonAction_Update) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
    Object? field1 = freezed,
  }) {
    return _then(_$DeamonAction_Update(
      null == field0
          ? _value._field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as List<Notification>,
      freezed == field1
          ? _value.field1
          : field1 // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$DeamonAction_Update implements DeamonAction_Update {
  const _$DeamonAction_Update(final List<Notification> field0, [this.field1])
      : _field0 = field0;

  final List<Notification> _field0;
  @override
  List<Notification> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  final int? field1;

  @override
  String toString() {
    return 'DeamonAction.update(field0: $field0, field1: $field1)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_Update &&
            const DeepCollectionEquality().equals(other._field0, _field0) &&
            (identical(other.field1, field1) || other.field1 == field1));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_field0), field1);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_UpdateCopyWith<_$DeamonAction_Update> get copyWith =>
      __$$DeamonAction_UpdateCopyWithImpl<_$DeamonAction_Update>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) {
    return update(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) {
    return update?.call(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(field0, field1);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_Update implements DeamonAction {
  const factory DeamonAction_Update(final List<Notification> field0,
      [final int? field1]) = _$DeamonAction_Update;

  List<Notification> get field0;
  int? get field1;
  @JsonKey(ignore: true)
  _$$DeamonAction_UpdateCopyWith<_$DeamonAction_Update> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeamonAction_FlutterCloseCopyWith<$Res> {
  factory _$$DeamonAction_FlutterCloseCopyWith(
          _$DeamonAction_FlutterClose value,
          $Res Function(_$DeamonAction_FlutterClose) then) =
      __$$DeamonAction_FlutterCloseCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$DeamonAction_FlutterCloseCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_FlutterClose>
    implements _$$DeamonAction_FlutterCloseCopyWith<$Res> {
  __$$DeamonAction_FlutterCloseCopyWithImpl(_$DeamonAction_FlutterClose _value,
      $Res Function(_$DeamonAction_FlutterClose) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$DeamonAction_FlutterClose(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeamonAction_FlutterClose implements DeamonAction_FlutterClose {
  const _$DeamonAction_FlutterClose(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'DeamonAction.flutterClose(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_FlutterClose &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_FlutterCloseCopyWith<_$DeamonAction_FlutterClose>
      get copyWith => __$$DeamonAction_FlutterCloseCopyWithImpl<
          _$DeamonAction_FlutterClose>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) {
    return flutterClose(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) {
    return flutterClose?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (flutterClose != null) {
      return flutterClose(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) {
    return flutterClose(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) {
    return flutterClose?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (flutterClose != null) {
      return flutterClose(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_FlutterClose implements DeamonAction {
  const factory DeamonAction_FlutterClose(final int field0) =
      _$DeamonAction_FlutterClose;

  int get field0;
  @JsonKey(ignore: true)
  _$$DeamonAction_FlutterCloseCopyWith<_$DeamonAction_FlutterClose>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeamonAction_FlutterCloseAllCopyWith<$Res> {
  factory _$$DeamonAction_FlutterCloseAllCopyWith(
          _$DeamonAction_FlutterCloseAll value,
          $Res Function(_$DeamonAction_FlutterCloseAll) then) =
      __$$DeamonAction_FlutterCloseAllCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeamonAction_FlutterCloseAllCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_FlutterCloseAll>
    implements _$$DeamonAction_FlutterCloseAllCopyWith<$Res> {
  __$$DeamonAction_FlutterCloseAllCopyWithImpl(
      _$DeamonAction_FlutterCloseAll _value,
      $Res Function(_$DeamonAction_FlutterCloseAll) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DeamonAction_FlutterCloseAll implements DeamonAction_FlutterCloseAll {
  const _$DeamonAction_FlutterCloseAll();

  @override
  String toString() {
    return 'DeamonAction.flutterCloseAll()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_FlutterCloseAll);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) {
    return flutterCloseAll();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) {
    return flutterCloseAll?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (flutterCloseAll != null) {
      return flutterCloseAll();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) {
    return flutterCloseAll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) {
    return flutterCloseAll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (flutterCloseAll != null) {
      return flutterCloseAll(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_FlutterCloseAll implements DeamonAction {
  const factory DeamonAction_FlutterCloseAll() = _$DeamonAction_FlutterCloseAll;
}

/// @nodoc
abstract class _$$DeamonAction_FlutterActionInvokedCopyWith<$Res> {
  factory _$$DeamonAction_FlutterActionInvokedCopyWith(
          _$DeamonAction_FlutterActionInvoked value,
          $Res Function(_$DeamonAction_FlutterActionInvoked) then) =
      __$$DeamonAction_FlutterActionInvokedCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0, String field1});
}

/// @nodoc
class __$$DeamonAction_FlutterActionInvokedCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res,
        _$DeamonAction_FlutterActionInvoked>
    implements _$$DeamonAction_FlutterActionInvokedCopyWith<$Res> {
  __$$DeamonAction_FlutterActionInvokedCopyWithImpl(
      _$DeamonAction_FlutterActionInvoked _value,
      $Res Function(_$DeamonAction_FlutterActionInvoked) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
    Object? field1 = null,
  }) {
    return _then(_$DeamonAction_FlutterActionInvoked(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
      null == field1
          ? _value.field1
          : field1 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeamonAction_FlutterActionInvoked
    implements DeamonAction_FlutterActionInvoked {
  const _$DeamonAction_FlutterActionInvoked(this.field0, this.field1);

  @override
  final int field0;
  @override
  final String field1;

  @override
  String toString() {
    return 'DeamonAction.flutterActionInvoked(field0: $field0, field1: $field1)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_FlutterActionInvoked &&
            (identical(other.field0, field0) || other.field0 == field0) &&
            (identical(other.field1, field1) || other.field1 == field1));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0, field1);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_FlutterActionInvokedCopyWith<
          _$DeamonAction_FlutterActionInvoked>
      get copyWith => __$$DeamonAction_FlutterActionInvokedCopyWithImpl<
          _$DeamonAction_FlutterActionInvoked>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function() showNc,
    required TResult Function() closeNc,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0, int? field1) update,
    required TResult Function(int field0) flutterClose,
    required TResult Function() flutterCloseAll,
    required TResult Function(int field0, String field1) flutterActionInvoked,
  }) {
    return flutterActionInvoked(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function()? showNc,
    TResult? Function()? closeNc,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0, int? field1)? update,
    TResult? Function(int field0)? flutterClose,
    TResult? Function()? flutterCloseAll,
    TResult? Function(int field0, String field1)? flutterActionInvoked,
  }) {
    return flutterActionInvoked?.call(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function()? showNc,
    TResult Function()? closeNc,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0, int? field1)? update,
    TResult Function(int field0)? flutterClose,
    TResult Function()? flutterCloseAll,
    TResult Function(int field0, String field1)? flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (flutterActionInvoked != null) {
      return flutterActionInvoked(field0, field1);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_ShowNc value) showNc,
    required TResult Function(DeamonAction_CloseNc value) closeNc,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_FlutterClose value) flutterClose,
    required TResult Function(DeamonAction_FlutterCloseAll value)
        flutterCloseAll,
    required TResult Function(DeamonAction_FlutterActionInvoked value)
        flutterActionInvoked,
  }) {
    return flutterActionInvoked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_ShowNc value)? showNc,
    TResult? Function(DeamonAction_CloseNc value)? closeNc,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult? Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult? Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
  }) {
    return flutterActionInvoked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_ShowNc value)? showNc,
    TResult Function(DeamonAction_CloseNc value)? closeNc,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_FlutterClose value)? flutterClose,
    TResult Function(DeamonAction_FlutterCloseAll value)? flutterCloseAll,
    TResult Function(DeamonAction_FlutterActionInvoked value)?
        flutterActionInvoked,
    required TResult orElse(),
  }) {
    if (flutterActionInvoked != null) {
      return flutterActionInvoked(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_FlutterActionInvoked implements DeamonAction {
  const factory DeamonAction_FlutterActionInvoked(
          final int field0, final String field1) =
      _$DeamonAction_FlutterActionInvoked;

  int get field0;
  String get field1;
  @JsonKey(ignore: true)
  _$$DeamonAction_FlutterActionInvokedCopyWith<
          _$DeamonAction_FlutterActionInvoked>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Picture {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageData field0) data,
    required TResult Function(String field0) path,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageData field0)? data,
    TResult? Function(String field0)? path,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageData field0)? data,
    TResult Function(String field0)? path,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Picture_Data value) data,
    required TResult Function(Picture_Path value) path,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Picture_Data value)? data,
    TResult? Function(Picture_Path value)? path,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Picture_Data value)? data,
    TResult Function(Picture_Path value)? path,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PictureCopyWith<$Res> {
  factory $PictureCopyWith(Picture value, $Res Function(Picture) then) =
      _$PictureCopyWithImpl<$Res, Picture>;
}

/// @nodoc
class _$PictureCopyWithImpl<$Res, $Val extends Picture>
    implements $PictureCopyWith<$Res> {
  _$PictureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$Picture_DataCopyWith<$Res> {
  factory _$$Picture_DataCopyWith(
          _$Picture_Data value, $Res Function(_$Picture_Data) then) =
      __$$Picture_DataCopyWithImpl<$Res>;
  @useResult
  $Res call({ImageData field0});
}

/// @nodoc
class __$$Picture_DataCopyWithImpl<$Res>
    extends _$PictureCopyWithImpl<$Res, _$Picture_Data>
    implements _$$Picture_DataCopyWith<$Res> {
  __$$Picture_DataCopyWithImpl(
      _$Picture_Data _value, $Res Function(_$Picture_Data) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Picture_Data(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as ImageData,
    ));
  }
}

/// @nodoc

class _$Picture_Data implements Picture_Data {
  const _$Picture_Data(this.field0);

  @override
  final ImageData field0;

  @override
  String toString() {
    return 'Picture.data(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Picture_Data &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Picture_DataCopyWith<_$Picture_Data> get copyWith =>
      __$$Picture_DataCopyWithImpl<_$Picture_Data>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageData field0) data,
    required TResult Function(String field0) path,
  }) {
    return data(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageData field0)? data,
    TResult? Function(String field0)? path,
  }) {
    return data?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageData field0)? data,
    TResult Function(String field0)? path,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Picture_Data value) data,
    required TResult Function(Picture_Path value) path,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Picture_Data value)? data,
    TResult? Function(Picture_Path value)? path,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Picture_Data value)? data,
    TResult Function(Picture_Path value)? path,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class Picture_Data implements Picture {
  const factory Picture_Data(final ImageData field0) = _$Picture_Data;

  @override
  ImageData get field0;
  @JsonKey(ignore: true)
  _$$Picture_DataCopyWith<_$Picture_Data> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Picture_PathCopyWith<$Res> {
  factory _$$Picture_PathCopyWith(
          _$Picture_Path value, $Res Function(_$Picture_Path) then) =
      __$$Picture_PathCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Picture_PathCopyWithImpl<$Res>
    extends _$PictureCopyWithImpl<$Res, _$Picture_Path>
    implements _$$Picture_PathCopyWith<$Res> {
  __$$Picture_PathCopyWithImpl(
      _$Picture_Path _value, $Res Function(_$Picture_Path) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Picture_Path(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Picture_Path implements Picture_Path {
  const _$Picture_Path(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'Picture.path(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Picture_Path &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Picture_PathCopyWith<_$Picture_Path> get copyWith =>
      __$$Picture_PathCopyWithImpl<_$Picture_Path>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageData field0) data,
    required TResult Function(String field0) path,
  }) {
    return path(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageData field0)? data,
    TResult? Function(String field0)? path,
  }) {
    return path?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageData field0)? data,
    TResult Function(String field0)? path,
    required TResult orElse(),
  }) {
    if (path != null) {
      return path(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Picture_Data value) data,
    required TResult Function(Picture_Path value) path,
  }) {
    return path(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Picture_Data value)? data,
    TResult? Function(Picture_Path value)? path,
  }) {
    return path?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Picture_Data value)? data,
    TResult Function(Picture_Path value)? path,
    required TResult orElse(),
  }) {
    if (path != null) {
      return path(this);
    }
    return orElse();
  }
}

abstract class Picture_Path implements Picture {
  const factory Picture_Path(final String field0) = _$Picture_Path;

  @override
  String get field0;
  @JsonKey(ignore: true)
  _$$Picture_PathCopyWith<_$Picture_Path> get copyWith =>
      throw _privateConstructorUsedError;
}
