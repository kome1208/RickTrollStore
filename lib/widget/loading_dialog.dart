import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadingDialog extends HookWidget {
  const LoadingDialog({super.key, required this.label});

  final String label;

  static void show(BuildContext context, String label) {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: LoadingDialog(label: label),
        );
      }
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      insetPadding: EdgeInsets.zero,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const Spacer(),
          Text(label),
          const Spacer(),
        ],
      ),
    );
  }
}