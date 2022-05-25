import 'package:flutter/cupertino.dart';

/// Widget for displaying a Cupertino confirmation dialog.
class CupertinoConfirmDialog extends StatelessWidget {
  // Title of the info dialog.
  final String title;

  // Content text of the info dialog.
  final String content;

  // Label on the confirmation button.
  final String textOk;

  // Label on the rejection button.
  final String textCancel;

  /// Widget for displaying a Cupertino confirmation dialog.
  const CupertinoConfirmDialog({
    required this.title,
    required this.content,
    required this.textOk,
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
          child: Text(textOk),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(textCancel),
        ),
      ],
    );
  }
}
