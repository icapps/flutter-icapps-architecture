import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

/// Displays a dialog above the current contents of the app.
/// On Android devices, this will resolve to a Material dialog, on iOS this to a Cupertino dialog.
///
/// The dialog has a title [title] and subtitle [content].
///
/// [textOk] is used for confirmation button label, [textCancel] for the rejection label.
/// When no [textCancel] is supplied, no rejection button will be displayed.
///
/// Returns a [Future] that resolves to [true] if the primary (affirmative) option was chosen, [false] for rejection (cancel) and [null] when returning without pressing a dialog button (eg. back button press)
Future<bool?> showNativeDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String textOk,
  String? textCancel,
}) async {
  if (textCancel != null && textCancel.isNotEmpty) {
    return NativeConfirmDialog.showNativeConfirmDialog(
      context: context,
      title: title,
      content: content,
      textOk: textOk,
      textCancel: textCancel,
    );
  }
  return NativeInfoDialog.showNativeInfoDialog(
    context: context,
    title: title,
    content: content,
    textOK: textOk,
  );
}
