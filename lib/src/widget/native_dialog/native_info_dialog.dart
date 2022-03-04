import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/widget/native_dialog/cupertino_info_dialog.dart';

/// Widget for displaying an info dialog above the current contents of the app.
/// On Android devices, this will resolve to a Material dialog, on iOS this to a Cupertino dialog.
class NativeInfoDialog extends StatelessWidget {
  // Title of the confirmation dialog.
  final String title;

  // Content text of the confirmation dialog.
  final String content;

  // Label on the confirmation button.
  final String textOk;

  const NativeInfoDialog({
    required this.title,
    required this.content,
    required this.textOk,
    Key? key,
  }) : super(key: key);

  /// Displays an info dialog with confirmation button above the current contents of the app.
  /// On Android devices, this will resolve to a Material dialog, on iOS this to a Cupertino dialog.
  ///
  /// The dialog has a title [title] and subtitle [content].
  /// [textOk] is used for the confirmation button label.
  ///
  /// Returns a [Future] that resolves to [True] when the confirmation button was pressed.
  static Future<bool?> showNativeInfoDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String textOK,
  }) async {
    if (isDeviceAndroid) {
      return showDialog(
        context: context,
        builder: (context) => NativeInfoDialog(
          title: title,
          content: content,
          textOk: textOK,
        ),
      );
    }
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoInfoDialog(
        title: title,
        content: content,
        textOk: textOK,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(textOk),
        ),
      ],
    );
  }
}
