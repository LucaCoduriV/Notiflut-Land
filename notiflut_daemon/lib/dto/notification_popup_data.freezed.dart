// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_popup_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NotificationPopupData _$NotificationPopupDataFromJson(
    Map<String, dynamic> json) {
  return _NotificationPopupData.fromJson(json);
}

/// @nodoc
mixin _$NotificationPopupData {
  int get id => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  int get timeout => throw _privateConstructorUsedError;
  List<String> get actions => throw _privateConstructorUsedError;
  ImageData? get icon => throw _privateConstructorUsedError;
  ImageData? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationPopupDataCopyWith<NotificationPopupData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPopupDataCopyWith<$Res> {
  factory $NotificationPopupDataCopyWith(NotificationPopupData value,
          $Res Function(NotificationPopupData) then) =
      _$NotificationPopupDataCopyWithImpl<$Res, NotificationPopupData>;
  @useResult
  $Res call(
      {int id,
      String summary,
      String appName,
      String body,
      int timeout,
      List<String> actions,
      ImageData? icon,
      ImageData? image});

  $ImageDataCopyWith<$Res>? get icon;
  $ImageDataCopyWith<$Res>? get image;
}

/// @nodoc
class _$NotificationPopupDataCopyWithImpl<$Res,
        $Val extends NotificationPopupData>
    implements $NotificationPopupDataCopyWith<$Res> {
  _$NotificationPopupDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? summary = null,
    Object? appName = null,
    Object? body = null,
    Object? timeout = null,
    Object? actions = null,
    Object? icon = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      timeout: null == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int,
      actions: null == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as ImageData?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ImageData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ImageDataCopyWith<$Res>? get icon {
    if (_value.icon == null) {
      return null;
    }

    return $ImageDataCopyWith<$Res>(_value.icon!, (value) {
      return _then(_value.copyWith(icon: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ImageDataCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $ImageDataCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_NotificationPopupDataCopyWith<$Res>
    implements $NotificationPopupDataCopyWith<$Res> {
  factory _$$_NotificationPopupDataCopyWith(_$_NotificationPopupData value,
          $Res Function(_$_NotificationPopupData) then) =
      __$$_NotificationPopupDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String summary,
      String appName,
      String body,
      int timeout,
      List<String> actions,
      ImageData? icon,
      ImageData? image});

  @override
  $ImageDataCopyWith<$Res>? get icon;
  @override
  $ImageDataCopyWith<$Res>? get image;
}

/// @nodoc
class __$$_NotificationPopupDataCopyWithImpl<$Res>
    extends _$NotificationPopupDataCopyWithImpl<$Res, _$_NotificationPopupData>
    implements _$$_NotificationPopupDataCopyWith<$Res> {
  __$$_NotificationPopupDataCopyWithImpl(_$_NotificationPopupData _value,
      $Res Function(_$_NotificationPopupData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? summary = null,
    Object? appName = null,
    Object? body = null,
    Object? timeout = null,
    Object? actions = null,
    Object? icon = freezed,
    Object? image = freezed,
  }) {
    return _then(_$_NotificationPopupData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      timeout: null == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int,
      actions: null == actions
          ? _value._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as ImageData?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as ImageData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NotificationPopupData extends _NotificationPopupData {
  _$_NotificationPopupData(
      {required this.id,
      required this.summary,
      required this.appName,
      required this.body,
      required this.timeout,
      required final List<String> actions,
      this.icon,
      this.image})
      : _actions = actions,
        super._();

  factory _$_NotificationPopupData.fromJson(Map<String, dynamic> json) =>
      _$$_NotificationPopupDataFromJson(json);

  @override
  final int id;
  @override
  final String summary;
  @override
  final String appName;
  @override
  final String body;
  @override
  final int timeout;
  final List<String> _actions;
  @override
  List<String> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  @override
  final ImageData? icon;
  @override
  final ImageData? image;

  @override
  String toString() {
    return 'NotificationPopupData(id: $id, summary: $summary, appName: $appName, body: $body, timeout: $timeout, actions: $actions, icon: $icon, image: $image)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotificationPopupDataCopyWith<_$_NotificationPopupData> get copyWith =>
      __$$_NotificationPopupDataCopyWithImpl<_$_NotificationPopupData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NotificationPopupDataToJson(
      this,
    );
  }
}

abstract class _NotificationPopupData extends NotificationPopupData {
  factory _NotificationPopupData(
      {required final int id,
      required final String summary,
      required final String appName,
      required final String body,
      required final int timeout,
      required final List<String> actions,
      final ImageData? icon,
      final ImageData? image}) = _$_NotificationPopupData;
  _NotificationPopupData._() : super._();

  factory _NotificationPopupData.fromJson(Map<String, dynamic> json) =
      _$_NotificationPopupData.fromJson;

  @override
  int get id;
  @override
  String get summary;
  @override
  String get appName;
  @override
  String get body;
  @override
  int get timeout;
  @override
  List<String> get actions;
  @override
  ImageData? get icon;
  @override
  ImageData? get image;
  @override
  @JsonKey(ignore: true)
  _$$_NotificationPopupDataCopyWith<_$_NotificationPopupData> get copyWith =>
      throw _privateConstructorUsedError;
}
