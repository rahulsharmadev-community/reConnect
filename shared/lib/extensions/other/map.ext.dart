import 'package:cloud_firestore/cloud_firestore.dart';

extension MapExt on Map<String, dynamic> {
  Map<String, dynamic> difference(Map<String, dynamic> oldValue,
      [bool pure = true]) {
    Map<String, dynamic> map = {};

    this.forEach((key, value) {
      if (oldValue.containsKey(key)) {
        var diff = _recursiveDifference(value, oldValue[key], pure);
        if (diff != null) map[key] = diff;
      } else {
        map[key] = value;
      }
    });

    return map;
  }

  dynamic _recursiveDifference(dynamic newValue, dynamic oldValue, bool pure) {
    if (newValue is Map && oldValue is Map) {
      var diff = {};
      newValue.forEach((key, value) {
        var nestedDiff = _recursiveDifference(value, oldValue[key], pure);
        if (nestedDiff != null) {
          diff[key] = nestedDiff;
        }
      });
      return diff.isNotEmpty ? diff : null;
    } else if (newValue is List && oldValue is List) {
      if (newValue.isEmpty && oldValue.isEmpty) return null;

      if (!pure) {
        if (ListEquality().equals(newValue, oldValue)) return null;
        return newValue;
      }
      Set<dynamic> _new = Set<dynamic>.from(newValue);
      Set<dynamic> _old = Set<dynamic>.from(oldValue);
      return _new.difference(_old).toList();
    } else if (newValue != oldValue) {
      return newValue;
    }
    return null;
  }
}
