import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'inherited_theme.g.theme.dart';

/// Satisfied by [InheritedTheme] itself, so nothing it declares may be
/// collected: an `implements` clause carries no state to construct.
abstract class HasVersion {
  int get version;
}

/// Declares the fields [InheritedTheme] inherits.
class BaseTheme {
  const BaseTheme({required this.inherited, required this.replaced});

  final int inherited;
  final String? replaced;
}

/// Theme covering the field collection rules: an inherited field is kept, a
/// private one is not a valid named argument so it is left out, `@ignore` on a
/// redeclaration also drops the inherited declaration, and an interface
/// contributes nothing.
@ShouldGenerateFile(
  'goldens/inherited_theme.g.theme.dart',
  partOfCurrent: true,
)
@themeGen
final class InheritedTheme extends BaseTheme
    with _$InheritedTheme
    implements HasVersion {
  InheritedTheme({required super.inherited}) : super(replaced: null);

  final _hidden = 0;

  @ignore
  @override
  // Redeclaring the inherited field is the point of this fixture.
  // ignore: overridden_fields
  final String? replaced = null;

  @override
  int get version => _hidden;

  @override
  bool get canMerge => true;

  static InheritedTheme? lerp(
    InheritedTheme? a,
    InheritedTheme? b,
    double t,
  ) => _$InheritedTheme.lerp(a, b, t);
}
