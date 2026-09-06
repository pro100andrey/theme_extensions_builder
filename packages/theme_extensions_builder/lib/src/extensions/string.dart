/// Extension for converting strings to camelCase format.
extension StringCamelCase on String {
  /// Converts the string to camelCase, optionally dropping a suffix.
  ///
  /// This method:
  /// - Returns an empty string if the input is empty
  /// - Converts the first character to lowercase
  /// - Removes [suffixToRemove] from the end when it is present
  ///
  /// Examples:
  /// ```dart
  /// 'HelloWorld'.camelCase() // 'helloWorld'
  /// 'theme'.camelCase() // 'theme'
  /// ''.camelCase() // ''
  /// 'MyThemeExtension'.camelCase(suffixToRemove: 'Extension') // 'myTheme'
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
