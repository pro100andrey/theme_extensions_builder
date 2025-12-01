/// Extension for converting strings to camelCase format.
extension StringCamelCase on String {
  /// Converts the string to camelCase, with special handling for 'Extension'
  /// suffix.
  ///
  /// This getter:
  /// - Returns empty string if the input is empty
  /// - Converts the first character to lowercase
  /// - Removes 'Extension' suffix if present (e.g., 'MyExtension' → 'my')
  ///
  /// Examples:
  /// ```dart
  /// 'HelloWorld'.camelCase // 'helloWorld'
  /// 'MyThemeExtension'.camelCase // 'myTheme'
  /// 'theme'.camelCase // 'theme'
  /// ''.camelCase // ''
  /// ```
  String camelCase({String? suffixToRemove}) {
    if (isEmpty) {
      return '';
    }

    // Convert first character to lowercase and keep the rest unchanged
    final property = '${this[0].toLowerCase()}${substring(1)}';

    // Remove suffix if present

    if (suffixToRemove == null || suffixToRemove.isEmpty) {
      return property;
    }

    return property.endsWith(suffixToRemove)
        ? property.substring(0, property.length - suffixToRemove.length)
        : property;
  }
}
