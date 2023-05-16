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
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0) update,
    required TResult Function(int field0) clientClose,
    required TResult Function(int field0, String field1) clientActionInvoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0)? update,
    TResult? Function(int field0)? clientClose,
    TResult? Function(int field0, String field1)? clientActionInvoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0)? update,
    TResult Function(int field0)? clientClose,
    TResult Function(int field0, String field1)? clientActionInvoked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_ClientClose value) clientClose,
    required TResult Function(DeamonAction_ClientActionInvoked value)
        clientActionInvoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_ClientClose value)? clientClose,
    TResult? Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_ClientClose value)? clientClose,
    TResult Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
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
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0) update,
    required TResult Function(int field0) clientClose,
    required TResult Function(int field0, String field1) clientActionInvoked,
  }) {
    return show(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0)? update,
    TResult? Function(int field0)? clientClose,
    TResult? Function(int field0, String field1)? clientActionInvoked,
  }) {
    return show?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0)? update,
    TResult Function(int field0)? clientClose,
    TResult Function(int field0, String field1)? clientActionInvoked,
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
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_ClientClose value) clientClose,
    required TResult Function(DeamonAction_ClientActionInvoked value)
        clientActionInvoked,
  }) {
    return show(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_ClientClose value)? clientClose,
    TResult? Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
  }) {
    return show?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_ClientClose value)? clientClose,
    TResult Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
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

  @override
  Notification get field0;
  @JsonKey(ignore: true)
  _$$DeamonAction_ShowCopyWith<_$DeamonAction_Show> get copyWith =>
      throw _privateConstructorUsedError;
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
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0) update,
    required TResult Function(int field0) clientClose,
    required TResult Function(int field0, String field1) clientActionInvoked,
  }) {
    return close(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0)? update,
    TResult? Function(int field0)? clientClose,
    TResult? Function(int field0, String field1)? clientActionInvoked,
  }) {
    return close?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0)? update,
    TResult Function(int field0)? clientClose,
    TResult Function(int field0, String field1)? clientActionInvoked,
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
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_ClientClose value) clientClose,
    required TResult Function(DeamonAction_ClientActionInvoked value)
        clientActionInvoked,
  }) {
    return close(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_ClientClose value)? clientClose,
    TResult? Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
  }) {
    return close?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_ClientClose value)? clientClose,
    TResult Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
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

  @override
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
  $Res call({List<Notification> field0});
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
  }) {
    return _then(_$DeamonAction_Update(
      null == field0
          ? _value._field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as List<Notification>,
    ));
  }
}

/// @nodoc

class _$DeamonAction_Update implements DeamonAction_Update {
  const _$DeamonAction_Update(final List<Notification> field0)
      : _field0 = field0;

  final List<Notification> _field0;
  @override
  List<Notification> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'DeamonAction.update(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_Update &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

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
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0) update,
    required TResult Function(int field0) clientClose,
    required TResult Function(int field0, String field1) clientActionInvoked,
  }) {
    return update(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0)? update,
    TResult? Function(int field0)? clientClose,
    TResult? Function(int field0, String field1)? clientActionInvoked,
  }) {
    return update?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0)? update,
    TResult Function(int field0)? clientClose,
    TResult Function(int field0, String field1)? clientActionInvoked,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_ClientClose value) clientClose,
    required TResult Function(DeamonAction_ClientActionInvoked value)
        clientActionInvoked,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_ClientClose value)? clientClose,
    TResult? Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_ClientClose value)? clientClose,
    TResult Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_Update implements DeamonAction {
  const factory DeamonAction_Update(final List<Notification> field0) =
      _$DeamonAction_Update;

  @override
  List<Notification> get field0;
  @JsonKey(ignore: true)
  _$$DeamonAction_UpdateCopyWith<_$DeamonAction_Update> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeamonAction_ClientCloseCopyWith<$Res> {
  factory _$$DeamonAction_ClientCloseCopyWith(_$DeamonAction_ClientClose value,
          $Res Function(_$DeamonAction_ClientClose) then) =
      __$$DeamonAction_ClientCloseCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$DeamonAction_ClientCloseCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_ClientClose>
    implements _$$DeamonAction_ClientCloseCopyWith<$Res> {
  __$$DeamonAction_ClientCloseCopyWithImpl(_$DeamonAction_ClientClose _value,
      $Res Function(_$DeamonAction_ClientClose) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$DeamonAction_ClientClose(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeamonAction_ClientClose implements DeamonAction_ClientClose {
  const _$DeamonAction_ClientClose(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'DeamonAction.clientClose(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_ClientClose &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_ClientCloseCopyWith<_$DeamonAction_ClientClose>
      get copyWith =>
          __$$DeamonAction_ClientCloseCopyWithImpl<_$DeamonAction_ClientClose>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0) update,
    required TResult Function(int field0) clientClose,
    required TResult Function(int field0, String field1) clientActionInvoked,
  }) {
    return clientClose(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0)? update,
    TResult? Function(int field0)? clientClose,
    TResult? Function(int field0, String field1)? clientActionInvoked,
  }) {
    return clientClose?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0)? update,
    TResult Function(int field0)? clientClose,
    TResult Function(int field0, String field1)? clientActionInvoked,
    required TResult orElse(),
  }) {
    if (clientClose != null) {
      return clientClose(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_ClientClose value) clientClose,
    required TResult Function(DeamonAction_ClientActionInvoked value)
        clientActionInvoked,
  }) {
    return clientClose(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_ClientClose value)? clientClose,
    TResult? Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
  }) {
    return clientClose?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_ClientClose value)? clientClose,
    TResult Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
    required TResult orElse(),
  }) {
    if (clientClose != null) {
      return clientClose(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_ClientClose implements DeamonAction {
  const factory DeamonAction_ClientClose(final int field0) =
      _$DeamonAction_ClientClose;

  @override
  int get field0;
  @JsonKey(ignore: true)
  _$$DeamonAction_ClientCloseCopyWith<_$DeamonAction_ClientClose>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeamonAction_ClientActionInvokedCopyWith<$Res> {
  factory _$$DeamonAction_ClientActionInvokedCopyWith(
          _$DeamonAction_ClientActionInvoked value,
          $Res Function(_$DeamonAction_ClientActionInvoked) then) =
      __$$DeamonAction_ClientActionInvokedCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0, String field1});
}

/// @nodoc
class __$$DeamonAction_ClientActionInvokedCopyWithImpl<$Res>
    extends _$DeamonActionCopyWithImpl<$Res, _$DeamonAction_ClientActionInvoked>
    implements _$$DeamonAction_ClientActionInvokedCopyWith<$Res> {
  __$$DeamonAction_ClientActionInvokedCopyWithImpl(
      _$DeamonAction_ClientActionInvoked _value,
      $Res Function(_$DeamonAction_ClientActionInvoked) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
    Object? field1 = null,
  }) {
    return _then(_$DeamonAction_ClientActionInvoked(
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

class _$DeamonAction_ClientActionInvoked
    implements DeamonAction_ClientActionInvoked {
  const _$DeamonAction_ClientActionInvoked(this.field0, this.field1);

  @override
  final int field0;
  @override
  final String field1;

  @override
  String toString() {
    return 'DeamonAction.clientActionInvoked(field0: $field0, field1: $field1)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeamonAction_ClientActionInvoked &&
            (identical(other.field0, field0) || other.field0 == field0) &&
            (identical(other.field1, field1) || other.field1 == field1));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0, field1);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeamonAction_ClientActionInvokedCopyWith<
          _$DeamonAction_ClientActionInvoked>
      get copyWith => __$$DeamonAction_ClientActionInvokedCopyWithImpl<
          _$DeamonAction_ClientActionInvoked>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Notification field0) show,
    required TResult Function(int field0) close,
    required TResult Function(List<Notification> field0) update,
    required TResult Function(int field0) clientClose,
    required TResult Function(int field0, String field1) clientActionInvoked,
  }) {
    return clientActionInvoked(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Notification field0)? show,
    TResult? Function(int field0)? close,
    TResult? Function(List<Notification> field0)? update,
    TResult? Function(int field0)? clientClose,
    TResult? Function(int field0, String field1)? clientActionInvoked,
  }) {
    return clientActionInvoked?.call(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Notification field0)? show,
    TResult Function(int field0)? close,
    TResult Function(List<Notification> field0)? update,
    TResult Function(int field0)? clientClose,
    TResult Function(int field0, String field1)? clientActionInvoked,
    required TResult orElse(),
  }) {
    if (clientActionInvoked != null) {
      return clientActionInvoked(field0, field1);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeamonAction_Show value) show,
    required TResult Function(DeamonAction_Close value) close,
    required TResult Function(DeamonAction_Update value) update,
    required TResult Function(DeamonAction_ClientClose value) clientClose,
    required TResult Function(DeamonAction_ClientActionInvoked value)
        clientActionInvoked,
  }) {
    return clientActionInvoked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeamonAction_Show value)? show,
    TResult? Function(DeamonAction_Close value)? close,
    TResult? Function(DeamonAction_Update value)? update,
    TResult? Function(DeamonAction_ClientClose value)? clientClose,
    TResult? Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
  }) {
    return clientActionInvoked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeamonAction_Show value)? show,
    TResult Function(DeamonAction_Close value)? close,
    TResult Function(DeamonAction_Update value)? update,
    TResult Function(DeamonAction_ClientClose value)? clientClose,
    TResult Function(DeamonAction_ClientActionInvoked value)?
        clientActionInvoked,
    required TResult orElse(),
  }) {
    if (clientActionInvoked != null) {
      return clientActionInvoked(this);
    }
    return orElse();
  }
}

abstract class DeamonAction_ClientActionInvoked implements DeamonAction {
  const factory DeamonAction_ClientActionInvoked(
          final int field0, final String field1) =
      _$DeamonAction_ClientActionInvoked;

  @override
  int get field0;
  String get field1;
  @JsonKey(ignore: true)
  _$$DeamonAction_ClientActionInvokedCopyWith<
          _$DeamonAction_ClientActionInvoked>
      get copyWith => throw _privateConstructorUsedError;
}
