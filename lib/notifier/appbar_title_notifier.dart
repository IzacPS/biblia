import 'package:flutter/foundation.dart';

class ForceValueNotifier<T> extends ValueNotifier<T> {
  ForceValueNotifier(super.value);

  void forceSet(T newValue) {
    value = newValue;
    if (value == newValue) {
      notifyListeners();
    }
  }

  void forceNotify() {
    notifyListeners();
  }
}
