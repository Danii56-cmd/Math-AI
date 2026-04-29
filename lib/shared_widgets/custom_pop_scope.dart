import 'package:flutter/material.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class CustomPopScope extends StatelessWidget {
  final Widget child;
  const CustomPopScope({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // ← ADD THIS LINE
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final nav = context.read<NavigationProvider>();
          // Return to solver (index 2), NOT solver's parent (camera)
          nav.changeIndex(0);
        }
      },
      child: child,
    );
  }
}
