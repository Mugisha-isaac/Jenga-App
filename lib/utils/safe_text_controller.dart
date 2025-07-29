import 'package:flutter/material.dart';

/// A wrapper around TextEditingController that provides safe disposal handling
class SafeTextController {
  late final TextEditingController _controller;
  bool _isDisposed = false;

  SafeTextController({String? text}) {
    _controller = TextEditingController(text: text);
  }

  /// Get the underlying controller if not disposed
  TextEditingController? get controller => _isDisposed ? null : _controller;

  /// Get the current text safely
  String get text => _isDisposed ? '' : _controller.text;

  /// Set text safely
  set text(String value) {
    if (!_isDisposed) {
      _controller.text = value;
    }
  }

  /// Clear text safely
  void clear() {
    if (!_isDisposed) {
      _controller.clear();
    }
  }

  /// Check if the controller is disposed
  bool get isDisposed => _isDisposed;

  /// Dispose the controller safely
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _controller.dispose();
    }
  }

  /// Add a listener safely
  void addListener(VoidCallback listener) {
    if (!_isDisposed) {
      _controller.addListener(listener);
    }
  }

  /// Remove a listener safely
  void removeListener(VoidCallback listener) {
    if (!_isDisposed) {
      _controller.removeListener(listener);
    }
  }
}
