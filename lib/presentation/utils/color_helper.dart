import 'package:flutter/material.dart';

import 'type_message_enum.dart';

class ColorHelper {
  static Color getColorForType(TypeMessage type) {
    switch (type) {
      case TypeMessage.success:
        return Colors.green;
      case TypeMessage.fail:
        return Colors.red;
      case TypeMessage.undo:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
