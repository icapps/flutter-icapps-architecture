import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class NativeDialog {
  const NativeDialog();

  static Future<bool?> showNativeDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String textOK,
    String? textCancel,
  }) async {
    if (textCancel != null && textCancel.isNotEmpty) {
      return NativeConfirmDialog.showNativeConfirmDialog(
        context: context,
        title: title,
        content: content,
        textOK: textOK,
        textCancel: textCancel,
      );
    }
    return NativeInfoDialog.showNativeInfoDialog(
      context: context,
      title: title,
      content: content,
      textOK: textOK,
    );
  }
}
