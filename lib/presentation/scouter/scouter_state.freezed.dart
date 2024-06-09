// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scouter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScouterState {
  CameraController get controller => throw _privateConstructorUsedError;
  Image? get originalImage => throw _privateConstructorUsedError;
  Image? get croppedImage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScouterStateCopyWith<ScouterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScouterStateCopyWith<$Res> {
  factory $ScouterStateCopyWith(
          ScouterState value, $Res Function(ScouterState) then) =
      _$ScouterStateCopyWithImpl<$Res, ScouterState>;
  @useResult
  $Res call(
      {CameraController controller, Image? originalImage, Image? croppedImage});
}

/// @nodoc
class _$ScouterStateCopyWithImpl<$Res, $Val extends ScouterState>
    implements $ScouterStateCopyWith<$Res> {
  _$ScouterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? controller = null,
    Object? originalImage = freezed,
    Object? croppedImage = freezed,
  }) {
    return _then(_value.copyWith(
      controller: null == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as CameraController,
      originalImage: freezed == originalImage
          ? _value.originalImage
          : originalImage // ignore: cast_nullable_to_non_nullable
              as Image?,
      croppedImage: freezed == croppedImage
          ? _value.croppedImage
          : croppedImage // ignore: cast_nullable_to_non_nullable
              as Image?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScouterStateImplCopyWith<$Res>
    implements $ScouterStateCopyWith<$Res> {
  factory _$$ScouterStateImplCopyWith(
          _$ScouterStateImpl value, $Res Function(_$ScouterStateImpl) then) =
      __$$ScouterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CameraController controller, Image? originalImage, Image? croppedImage});
}

/// @nodoc
class __$$ScouterStateImplCopyWithImpl<$Res>
    extends _$ScouterStateCopyWithImpl<$Res, _$ScouterStateImpl>
    implements _$$ScouterStateImplCopyWith<$Res> {
  __$$ScouterStateImplCopyWithImpl(
      _$ScouterStateImpl _value, $Res Function(_$ScouterStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? controller = null,
    Object? originalImage = freezed,
    Object? croppedImage = freezed,
  }) {
    return _then(_$ScouterStateImpl(
      controller: null == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as CameraController,
      originalImage: freezed == originalImage
          ? _value.originalImage
          : originalImage // ignore: cast_nullable_to_non_nullable
              as Image?,
      croppedImage: freezed == croppedImage
          ? _value.croppedImage
          : croppedImage // ignore: cast_nullable_to_non_nullable
              as Image?,
    ));
  }
}

/// @nodoc

class _$ScouterStateImpl with DiagnosticableTreeMixin implements _ScouterState {
  const _$ScouterStateImpl(
      {required this.controller, this.originalImage, this.croppedImage});

  @override
  final CameraController controller;
  @override
  final Image? originalImage;
  @override
  final Image? croppedImage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScouterState(controller: $controller, originalImage: $originalImage, croppedImage: $croppedImage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScouterState'))
      ..add(DiagnosticsProperty('controller', controller))
      ..add(DiagnosticsProperty('originalImage', originalImage))
      ..add(DiagnosticsProperty('croppedImage', croppedImage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScouterStateImpl &&
            (identical(other.controller, controller) ||
                other.controller == controller) &&
            (identical(other.originalImage, originalImage) ||
                other.originalImage == originalImage) &&
            (identical(other.croppedImage, croppedImage) ||
                other.croppedImage == croppedImage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, controller, originalImage, croppedImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScouterStateImplCopyWith<_$ScouterStateImpl> get copyWith =>
      __$$ScouterStateImplCopyWithImpl<_$ScouterStateImpl>(this, _$identity);
}

abstract class _ScouterState implements ScouterState {
  const factory _ScouterState(
      {required final CameraController controller,
      final Image? originalImage,
      final Image? croppedImage}) = _$ScouterStateImpl;

  @override
  CameraController get controller;
  @override
  Image? get originalImage;
  @override
  Image? get croppedImage;
  @override
  @JsonKey(ignore: true)
  _$$ScouterStateImplCopyWith<_$ScouterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
