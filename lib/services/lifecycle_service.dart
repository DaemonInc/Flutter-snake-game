import 'package:flutter/material.dart';

class LifecycleService {
  LifecycleService({
    required void Function() pauseGame,
  }) {
    _appLifecycleListener = AppLifecycleListener(onStateChange: (state) {
      if (state != AppLifecycleState.resumed) {
        pauseGame();
      }
    });
  }

  late final AppLifecycleListener _appLifecycleListener;

  void dispose() {
    _appLifecycleListener.dispose();
  }
}
