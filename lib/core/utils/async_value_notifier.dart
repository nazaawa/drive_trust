import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AsyncValueNotifier<T> extends ChangeNotifier {
  AsyncValueNotifier(this._asyncValue);

  AsyncValue<T> _asyncValue;

  AsyncValue<T> get asyncValue => _asyncValue;

  void update(AsyncValue<T> newValue) {
    if (newValue != _asyncValue) {
      _asyncValue = newValue;
      notifyListeners();
    }
  }
}
