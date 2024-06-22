import 'package:flutter/material.dart';

class OverlayMenuWrap extends StatelessWidget {
  const OverlayMenuWrap({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: child,
      ),
    );
  }
}
