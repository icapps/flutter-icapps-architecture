import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/widget/native_dialog/cupertino_dialog.dart';

class NativeDialog extends StatelessWidget {
  final String title;
  final String content;
  final String textOK;
  final String textCancel;

  const NativeDialog({
    required this.title,
    required this.content,
    required this.textOK,
    required this.textCancel,
    Key? key,
  }) : super(key: key);

  static Future<bool?> showNativeDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String textOK,
    required String textCancel,
  }) async {
    if (isDeviceAndroid) {
      return showDialog(
        context: context,
        builder: (context) => NativeDialog(
          title: title,
          content: content,
          textOK: textOK,
          textCancel: textCancel,
        ),
      );
    }
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoDialog(
        title: title,
        content: content,
        textOK: textOK,
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

