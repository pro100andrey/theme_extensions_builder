import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'theme_extension.dart';

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
class SimpleTheme with _$SimpleTheme {
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
