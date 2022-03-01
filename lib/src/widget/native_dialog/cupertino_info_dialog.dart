import 'package:flutter/cupertino.dart';

class CupertinoInfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final String textOK;

  const CupertinoInfoDialog({
    required this.title,
    required this.content,
    required this.textOK,
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
      ],
    );
  }
}