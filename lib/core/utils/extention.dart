extension on Iterable? {
  bool get isEmptyOrNull => this == null || this!.isEmpty;
  bool get isNullValue => this == null;
  bool get isNotNullValue => this != null;
  bool get isNotEmptyOrNotNull => this != null || this!.isNotEmpty;
  bool get isEmptyAndNull => this == null && this!.isEmpty;
  bool get isNotEmptyAndNotNull => this != null && this!.isNotEmpty;
}
