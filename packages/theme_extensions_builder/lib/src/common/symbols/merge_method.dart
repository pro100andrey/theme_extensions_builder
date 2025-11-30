sealed class MergeMethod {
  const MergeMethod();

  @override
  String toString() => 'MergeMethod()';
}

final class NoMergeMethod extends MergeMethod {
  const NoMergeMethod();

  @override
  String toString() => 'NoMergeMethod()';
}

final class StaticMergeMethod extends MergeMethod {
  const StaticMergeMethod();

  @override
  String toString() => 'StaticMergeMethod()';
}

final class InstanceMergeMethod extends MergeMethod {
  const InstanceMergeMethod();

  @override
  String toString() => 'InstanceMergeMethod()';
}
