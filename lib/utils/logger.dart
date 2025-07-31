import 'dart:developer' as developer;

class Logger {
  static const bool _debugMode = true; // Set to false for production builds

  static void debug(String message) {
    if (_debugMode) {
      developer.log(message, name: 'DEBUG');
    }
  }

  static void info(String message) {
    if (_debugMode) {
      developer.log(message, name: 'INFO');
    }
  }

  static void warning(String message) {
    if (_debugMode) {
      developer.log(message, name: 'WARNING');
    }
  }

  static void error(String message) {
    if (_debugMode) {
      developer.log(message, name: 'ERROR');
    }
  }
}
