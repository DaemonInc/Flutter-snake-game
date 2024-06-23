import 'package:flutter/material.dart';

/// A service that listens to app lifecycle changes
class LifecycleService {
  LifecycleService({
    required void Function() onFocusLost,
  }) {
    _appLifecycleListener = AppLifecycleListener(onStateChange: (state) {
      if (state != AppLifecycleState.resumed) {
        onFocusLost();
      }
    });
  }

  late final AppLifecycleListener _appLifecycleListener;

  void dispose() {
    _appLifecycleListener.dispose();
  }
}
