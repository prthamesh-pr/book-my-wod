import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

Future<void> showSnackbar(BuildContext context, String message,
    {SnackbarType type = SnackbarType.info}) async {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: type == SnackbarType.success
          ? Colors.green
          : type == SnackbarType.error
              ? Colors.red
              : type == SnackbarType.warning
                  ? Colors.orange
                  : Colors.blue,
    ),
  );
}
