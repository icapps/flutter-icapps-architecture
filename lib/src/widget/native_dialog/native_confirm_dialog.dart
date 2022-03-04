import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/widget/native_dialog/cupertino_confirm_dialog.dart';

/// Widget for displaying a confirmation dialog above the current contents of the app.
/// On Android devices, this will resolve to a Material dialog, on iOS this to a Cupertino dialog.
class NativeConfirmDialog extends StatelessWidget {
  // Title of the confirmation dialog.
  final String title;

  // Content text of the confirmation dialog.
  final String content;

  // Label on the confirmation button.
  final String textOK;

  // Label on the rejection button.
  final String textCancel;

  /// Widget for displaying a confirmation dialog above the current contents of the app.
  /// On Android devices, this will resolve to a Material dialog, on iOS this to a Cupertino dialog.
  const NativeConfirmDialog({
    required this.title,
    required this.content,
    required this.textOK,
    required this.textCancel,
    Key? key,
  }) : super(key: key);

  /// Displays a confirmation dialog above the current contents of the app.
  /// On Android devices, this will resolve to a Material dialog, on iOS this to a Cupertino dialog.
  ///
  /// The dialog has a title [title] and subtitle [content].
  /// [textOk] is used for the confirmation button label.
  /// [textCancel] is used for the rejection button label.
  ///
  /// Returns a [Future] that resolves to [True] when the confirmation button was pressed, [False] for rejection.
  static Future<bool?> showNativeConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String textOk,
    required String textCancel,
  }) async {
    if (isDeviceAndroid) {
      return showDialog(
        context: context,
        builder: (context) => NativeConfirmDialog(
          title: title,
          content: content,
          textOK: textOk,
          textCancel: textCancel,
        ),
      );
    }
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoConfirmDialog(
        title: title,
        content: content,
        textOk: textOk,
        textCancel: textCancel,
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
          child: Text(textOK),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(textCancel),
        ),
      ],
    );
  }
}
