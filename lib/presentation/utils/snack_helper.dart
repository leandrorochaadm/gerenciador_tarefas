import 'package:flutter/material.dart';

import 'color_helper.dart';
import 'type_message_enum.dart';

class SnackBarHelper {
  static void show(
    BuildContext context, {
    required TypeMessage type,
    required String message,
    void Function()? onUndo,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorHelper.getColorForType(type),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: _getSnackBarAction(type, onUndo),
      ),
    );
  }

  static SnackBarAction? _getSnackBarAction(
      TypeMessage type, void Function()? onUndo) {
    if (type == TypeMessage.undo) {
      return SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.yellowAccent,
        onPressed: onUndo ?? () {},
      );
    }
    return null; // Sem ação para outros tipos
  }
}
