/// Utility methods for the theme extensions builder.
library;

// ignore_for_file: parameter_assignments

/// Linearly interpolate between two numbers, `a` and `b`, by an extrapolation
/// factor `t`.
///
/// When `a` and `b` are equal or both NaN, `a` is returned.  Otherwise,
/// `a`, `b`, and `t` are required to be finite or null, and the result of `a +
/// (b - a) * t` is returned, where nulls are defaulted to 0.0.

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

/// Linearly interpolate between two Durations, `a` and `b`, by an extrapolation
/// factor `t`.
/// When `a` and `b` are equal, `a` is returned.  Otherwise, `a`, `b`, and `t`
/// are required to be finite or null, and the result of `a + (b - a) * t` is
/// returned, where nulls are defaulted to Duration.zero.
Duration? lerpDuration$(Duration? a, Duration? b, double t) {
  if (a == b) {
    return a;
  }

  a ??= Duration.zero;
  b ??= Duration.zero;

  if (a == b) {
    return a;
  }

  assert(t.isFinite, 't must be finite when interpolating between values');

  return Duration(
    microseconds: (a.inMicroseconds * (1.0 - t) + b.inMicroseconds * t).round(),
  );
}
