import 'package:flutter/cupertino.dart';

/// Widget for displaying a Cupertino info dialog.
class CupertinoInfoDialog extends StatelessWidget {
  // Title of the info dialog.
  final String title;

  // Content text of the info dialog.
  final String content;

  // Label on the confirmation button.
  final String textOk;

  /// Widget for displaying a Cupertino info dialog.
  const CupertinoInfoDialog({
    required this.title,
    required this.content,
    required this.textOk,
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
          child: Text(textOk),
        ),
      ],
    );
  }
}
