extension StringCamelCase on String {
  String get camelCase {
    if (isEmpty) {
      return '';
    }

    var property = this[0].toLowerCase() + substring(1);

    if (property.endsWith('Extension')) {
      property = property.substring(0, property.length - 'Extension'.length);
    }

    return property;
  }
}

// extension StringNullable on String {
//   /// Returns a nullable version of the type if [f] is true.
//   String nullable({bool f = true}) {
//     if (!f) {
//       return this;
//     }

//     if (this == 'dynamic') {
//       return this;
//     }

//     if (endsWith('?')) {
//       return this;
//     }

//     return '$this?';
//   }
// }
