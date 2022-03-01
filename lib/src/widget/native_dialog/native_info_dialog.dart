import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:icapps_architecture/src/widget/native_dialog/cupertino_info_dialog.dart';

class NativeInfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final String textOK;

  const NativeInfoDialog({
    required this.title,
    required this.content,
    required this.textOK,
    Key? key,
  }) : super(key: key);

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
          textOK: textOK,
        ),
      );
    }
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoInfoDialog(
        title: title,
        content: content,
        textOK: textOK,
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
      ],
    );
  }
}