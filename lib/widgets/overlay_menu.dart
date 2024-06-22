import 'package:flutter/material.dart';

class OverlayMenu extends StatelessWidget {
  const OverlayMenu({
    super.key,
    required this.content,
    required this.title,
  });

  final List<Widget> content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              ...content,
            ],
          ),
        ),
      ),
    );
  }
}
