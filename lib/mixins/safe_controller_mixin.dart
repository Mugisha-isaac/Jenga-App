import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Mixin that provides safe text controller handling for GetX controllers
mixin SafeControllerMixin on GetxController {
  bool _isControllerDisposed = false;
  
  /// Check if the controller is disposed
  bool get isControllerDisposed => _isControllerDisposed;
  
  /// Safely execute a function only if the controller is not disposed
  T? safeExecute<T>(T Function() fn) {
    if (_isControllerDisposed) return null;
    try {
      return fn();
    } catch (e) {
      print('SafeControllerMixin: Error executing function: $e');
      return null;
    }
  }
  
  /// Safely update an observable value
  void safeUpdate<T>(Rx<T> observable, T value) {
    if (!_isControllerDisposed) {
      observable.value = value;
    }
  }
  
  /// Safely call a void function
  void safeCall(VoidCallback fn) {
    if (!_isControllerDisposed) {
      try {
        fn();
      } catch (e) {
        print('SafeControllerMixin: Error calling function: $e');
      }
    }
  }
  
  @override
  void onClose() {
    _isControllerDisposed = true;
    super.onClose();
  }
}
