import 'package:flutter/cupertino.dart';

class CupertinoDialog extends StatelessWidget {
  final String title;
  final String content;
  final String textOK;
  final String textCancel;

  const CupertinoDialog({
    required this.title,
    required this.content,
    required this.textOK,
    required this.textCancel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(textOK),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(textCancel),
        ),
      ],
    );
  }
}