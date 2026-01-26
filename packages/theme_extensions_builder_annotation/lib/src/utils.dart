/// Utility functions for theme interpolation.
///
/// This library provides interpolation (lerp) functions used by the generated
/// theme code to smoothly transition between theme values during animations.
library;

// Ignore warnings about parameter assignments in lerp functions
// ignore_for_file: parameter_assignments

/// Linearly interpolates between two numbers.
///
/// Performs linear interpolation from [a] to [b] using the interpolation
/// factor [t]. The [t] value typically ranges from 0.0 (returns [a]) to 1.0
/// (returns [b]), but can be outside this range for extrapolation.
///
/// Special cases:
/// - If [a] and [b] are equal or both NaN, returns [a]
/// - Null values are treated as 0.0
/// - All values must be finite (asserts in debug mode)
///
/// Formula: `a * (1 - t) + b * t`
///
/// Example:
/// ```dart
/// lerpDouble$(10.0, 20.0, 0.5) // 15.0
/// lerpDouble$(null, 100.0, 0.25) // 25.0
/// lerpDouble$(50.0, 50.0, 0.7) // 50.0
/// ```
///
/// Throws [AssertionError] in debug mode if any value is infinite or if [t]
/// is not finite.
double? lerpDouble$(num? a, num? b, double t) {
  if (a == b || (a?.isNaN ?? false) && (b?.isNaN ?? false)) {
    return a?.toDouble();
  }

  a ??= 0.0;
  b ??= 0.0;

  assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(t.isFinite, 't must be finite when interpolating between values');

  return a * (1.0 - t) + b * t;
}

/// Linearly interpolates between two durations.
///
/// Performs linear interpolation from [a] to [b] using the interpolation
/// factor [t]. The [t] value typically ranges from 0.0 (returns [a]) to 1.0
/// (returns [b]), but can be outside this range for extrapolation.
///
/// Special cases:
/// - If [a] and [b] are equal, returns [a]
/// - Null values are treated as [Duration.zero]
/// - The [t] value must be finite (asserts in debug mode)
///
/// The interpolation is performed at microsecond precision and the result
/// is rounded to the nearest microsecond.
///
/// Example:
/// ```dart
/// lerpDuration$(
///   Duration(seconds: 1),
///   Duration(seconds: 3),
///   0.5,
/// ) // Duration(seconds: 2)
///
/// lerpDuration$(
///   null,
///   Duration(milliseconds: 500),
///   0.25,
/// ) // Duration(milliseconds: 125)
/// ```
///
/// Throws [AssertionError] in debug mode if [t] is not finite.
Duration? lerpDuration$(Duration? a, Duration? b, double t) {
  if (a == b) {
    return a;
  }

  a ??= Duration.zero;
  b ??= Duration.zero;

  assert(t.isFinite, 't must be finite when interpolating between values');

  return Duration(
    microseconds: (a.inMicroseconds * (1.0 - t) + b.inMicroseconds * t).round(),
  );
}
