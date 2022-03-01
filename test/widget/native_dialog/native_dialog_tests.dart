import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  final labelOK = "OK";
  final labelCancel = "Cancel";

  Widget confirmationDialogWidgetTree = MaterialApp(
    home: Scaffold(
      body: Builder(builder: (context) {
        return IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            NativeDialog.showNativeDialog(
              context: context,
              title: "Title",
              content: "Content",
              textOK: labelOK,
              textCancel: labelCancel,
            );
          },
        );
      }),
    ),
  );

  Widget infoDialogWidgetTree = MaterialApp(
    home: Scaffold(
      body: Builder(builder: (context) {
        return IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            NativeDialog.showNativeDialog(
              context: context,
              title: "Title",
              content: "Content",
              textOK: labelOK,
            );
          },
        );
      }),
    ),
  );

  testWidgets(
      "Given NativeDialog, supplying both testOk and testCancel arguments renders two buttons ",
      (WidgetTester tester) async {
    await tester.pumpWidget(confirmationDialogWidgetTree);

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    expect(find.text(labelOK), findsOneWidget);
    expect(find.text(labelCancel), findsOneWidget);
  });

  testWidgets(
      "Given NativeDialog, supplying only testOk argument renders only OK Button.",
      (WidgetTester tester) async {
    await tester.pumpWidget(infoDialogWidgetTree);

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    expect(find.text(labelOK), findsOneWidget);
    expect(find.text(labelCancel), findsNothing);
  });

  //TODO: add tests that check if for given platform the correct dialog type is rendered.
}
