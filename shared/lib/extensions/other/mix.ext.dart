import 'dart:ffi';

extension StringExt on String? {
  bool get isNotNull => this != null;
}

extension intExt on num? {
  bool get isNotNull => this != null;
}

extension ObjectExt on Object? {
  bool get isNotNull => this != null;
}

extension DynamicExt on dynamic {
  bool get isNotNull => this != null;
}
