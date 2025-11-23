import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

abstract class ThemeExtension<T extends ThemeExtension<T>> {
  /// Enable const constructor for subclasses.
  const ThemeExtension();

  /// The extension's type.
  Object get type => T;

  /// Creates a copy of this theme extension with the given fields
  /// replaced by the non-null parameter values.
  ThemeExtension<T> copyWith() => throw UnimplementedError();

  /// Linearly interpolate with another [ThemeExtension] object.
  ///
  /// {@macro dart.ui.shadow.lerp}
  ThemeExtension<T> lerp(covariant ThemeExtension<T>? other, double t) =>
      throw UnimplementedError();
}

// ignore: avoid_classes_with_only_static_members
final class Color {
  static Color? lerp(Color? x, Color? y, double t) => null;
}

mixin _$NullableTheme {}
mixin _$EmptyTheme {}
mixin _$EmptyThemeWithConst {}
mixin _$EmptyThemeNoExtension {}
mixin _$SimpleTheme {}
mixin _$Custom {}

@ShouldGenerate(r'''
mixin _$NullableTheme on ThemeExtension<NullableTheme> {
  @override
  ThemeExtension<NullableTheme> copyWith({
    double? width,
    double? height,
    String? title,
  }) {
    final _this = (this as NullableTheme);

    return NullableTheme(
      width: width ?? _this.width,
      height: height ?? _this.height,
      title: title ?? _this.title,
    );
  }

  @override
  ThemeExtension<NullableTheme> lerp(
    ThemeExtension<NullableTheme>? other,
    double t,
  ) {
    if (other is! NullableTheme) {
      return this;
    }

    final _this = (this as NullableTheme);

    return NullableTheme(
      width: lerpDouble$(_this.width, other.width, t),
      height: lerpDouble$(_this.height, other.height, t),
      title: t < 0.5 ? _this.title : other.title,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as NullableTheme);
    final _other = (other as NullableTheme);

    return _other.width == _this.width &&
        _other.height == _this.height &&
        _other.title == _this.title;
  }

  @override
  int get hashCode {
    final _this = (this as NullableTheme);

    return Object.hash(runtimeType, _this.width, _this.height, _this.title);
  }
}

extension NullableThemeBuildContext on BuildContext {
  NullableTheme get nullableTheme => Theme.of(this).extension<NullableTheme>()!;
}
''')
@ThemeExtensions()
class NullableTheme extends ThemeExtension<NullableTheme> with _$NullableTheme {
  const NullableTheme({
    this.width,
    this.height,
    this.title,
    this.color,
  });

  final double? width;
  final double? height;
  final String? title;
  final Color? color;
}

@ShouldGenerate(r'''
mixin _$EmptyTheme on ThemeExtension<EmptyTheme> {
  @override
  ThemeExtension<EmptyTheme> copyWith() {
    return EmptyTheme();
  }

  @override
  ThemeExtension<EmptyTheme> lerp(ThemeExtension<EmptyTheme>? other, double t) {
    if (other is! EmptyTheme) {
      return this;
    }

    return EmptyTheme();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}

extension EmptyThemeBuildContext on BuildContext {
  EmptyTheme get emptyTheme => Theme.of(this).extension<EmptyTheme>()!;
}
''')
@ThemeExtensions()
class EmptyTheme extends ThemeExtension<EmptyTheme> with _$EmptyTheme {
  EmptyTheme();
}

@ShouldGenerate(r'''
mixin _$EmptyThemeWithConst on ThemeExtension<EmptyThemeWithConst> {
  @override
  ThemeExtension<EmptyThemeWithConst> copyWith() {
    return const EmptyThemeWithConst();
  }

  @override
  ThemeExtension<EmptyThemeWithConst> lerp(
    ThemeExtension<EmptyThemeWithConst>? other,
    double t,
  ) {
    if (other is! EmptyThemeWithConst) {
      return this;
    }

    return const EmptyThemeWithConst();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}

extension EmptyThemeWithConstBuildContext on BuildContext {
  EmptyThemeWithConst get emptyThemeWithConst =>
      Theme.of(this).extension<EmptyThemeWithConst>()!;
}
''')
@ThemeExtensions()
class EmptyThemeWithConst extends ThemeExtension<EmptyThemeWithConst>
    with _$EmptyThemeWithConst {
  const EmptyThemeWithConst();
}

@ShouldGenerate(r'''
mixin _$EmptyThemeNoExtension on ThemeExtension<EmptyThemeNoExtension> {
  @override
  ThemeExtension<EmptyThemeNoExtension> copyWith() {
    return EmptyThemeNoExtension();
  }

  @override
  ThemeExtension<EmptyThemeNoExtension> lerp(
    ThemeExtension<EmptyThemeNoExtension>? other,
    double t,
  ) {
    if (other is! EmptyThemeNoExtension) {
      return this;
    }

    return EmptyThemeNoExtension();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
''')
@ThemeExtensions(buildContextExtension: false)
class EmptyThemeNoExtension extends ThemeExtension<EmptyThemeNoExtension>
    with _$EmptyThemeNoExtension {
  EmptyThemeNoExtension();
}

@ShouldGenerate(r'''
mixin _$SimpleTheme on ThemeExtension<SimpleTheme> {
  @override
  ThemeExtension<SimpleTheme> copyWith({
    double? size,
    int? count,
    bool? isEnabled,
    String? name,
    List<String>? items,
    Map<String, int>? scores,
    DateTime? timestamp,
    Duration? duration,
    Object? data,
  }) {
    final _this = (this as SimpleTheme);

    return SimpleTheme(
      size: size ?? _this.size,
      count: count ?? _this.count,
      isEnabled: isEnabled ?? _this.isEnabled,
      name: name ?? _this.name,
      items: items ?? _this.items,
      scores: scores ?? _this.scores,
      timestamp: timestamp ?? _this.timestamp,
      duration: duration ?? _this.duration,
      data: data ?? _this.data,
    );
  }

  @override
  ThemeExtension<SimpleTheme> lerp(
    ThemeExtension<SimpleTheme>? other,
    double t,
  ) {
    if (other is! SimpleTheme) {
      return this;
    }

    final _this = (this as SimpleTheme);

    return SimpleTheme(
      size: lerpDouble$(_this.size, other.size, t)!,
      count: t < 0.5 ? _this.count : other.count,
      isEnabled: t < 0.5 ? _this.isEnabled : other.isEnabled,
      name: t < 0.5 ? _this.name : other.name,
      items: t < 0.5 ? _this.items : other.items,
      scores: t < 0.5 ? _this.scores : other.scores,
      timestamp: t < 0.5 ? _this.timestamp : other.timestamp,
      duration: lerpDuration$(_this.duration, other.duration, t)!,
      data: t < 0.5 ? _this.data : other.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as SimpleTheme);
    final _other = (other as SimpleTheme);

    return _other.size == _this.size &&
        _other.count == _this.count &&
        _other.isEnabled == _this.isEnabled &&
        _other.name == _this.name &&
        _other.items == _this.items &&
        _other.scores == _this.scores &&
        _other.timestamp == _this.timestamp &&
        _other.duration == _this.duration &&
        _other.data == _this.data;
  }

  @override
  int get hashCode {
    final _this = (this as SimpleTheme);

    return Object.hash(
      runtimeType,
      _this.size,
      _this.count,
      _this.isEnabled,
      _this.name,
      _this.items,
      _this.scores,
      _this.timestamp,
      _this.duration,
      _this.data,
    );
  }
}

extension SimpleThemeBuildContext on BuildContext {
  SimpleTheme get simpleTheme => Theme.of(this).extension<SimpleTheme>()!;
}
''')
@ThemeExtensions()
class SimpleTheme extends ThemeExtension<SimpleTheme> with _$SimpleTheme {
  const SimpleTheme({
    required this.size,
    required this.count,
    required this.isEnabled,
    required this.name,
    required this.items,
    required this.scores,
    required this.timestamp,
    required this.duration,
    required this.data,
  });

  final double size;
  final int count;
  final bool isEnabled;
  final String name;
  final List<String> items;
  final Map<String, int> scores;
  final DateTime timestamp;
  final Duration duration;
  final Object data;
}

@ShouldGenerate(r'''
mixin _$Custom on ThemeExtension<CustomMixinName> {
  @override
  ThemeExtension<CustomMixinName> copyWith({double? size, bool? isEnabled}) {
    final _this = (this as CustomMixinName);

    return CustomMixinName(
      size: size ?? _this.size,
      isEnabled: isEnabled ?? _this.isEnabled,
    );
  }

  @override
  ThemeExtension<CustomMixinName> lerp(
    ThemeExtension<CustomMixinName>? other,
    double t,
  ) {
    if (other is! CustomMixinName) {
      return this;
    }

    final _this = (this as CustomMixinName);

    return CustomMixinName(
      size: lerpDouble$(_this.size, other.size, t)!,
      isEnabled: t < 0.5 ? _this.isEnabled : other.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as CustomMixinName);
    final _other = (other as CustomMixinName);

    return _other.size == _this.size && _other.isEnabled == _this.isEnabled;
  }

  @override
  int get hashCode {
    final _this = (this as CustomMixinName);

    return Object.hash(runtimeType, _this.size, _this.isEnabled);
  }
}

extension CustomMixinNameBuildContext on BuildContext {
  CustomMixinName get customMixinName =>
      Theme.of(this).extension<CustomMixinName>()!;
}
''')
@ThemeExtensions()
class CustomMixinName extends ThemeExtension<CustomMixinName> with _$Custom {
  const CustomMixinName({
    required this.size,
    required this.isEnabled,
  });

  final double size;
  final bool isEnabled;
}
