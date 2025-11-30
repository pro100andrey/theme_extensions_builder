sealed class MergeMethod {
  const MergeMethod();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'MergeMethod()';
}

final class NoMergeMethod extends MergeMethod {
  const NoMergeMethod();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'NoMergeMethod()';
}

final class StaticMergeMethod extends MergeMethod {
  const StaticMergeMethod();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'StaticMergeMethod()';
}

final class InstanceMergeMethod extends MergeMethod {
  const InstanceMergeMethod();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'InstanceMergeMethod()';
}
