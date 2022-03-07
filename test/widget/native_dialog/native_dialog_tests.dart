import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  final labelOk = "OK";
  final labelCancel = "Cancel";

  bool? result;

  Widget confirmationDialogWidgetTree = MaterialApp(
    home: Scaffold(
      body: Builder(builder: (context) {
        return IconButton(
          icon: Icon(Icons.info),
          onPressed: () async {
            result = await showNativeDialog(
              context: context,
              title: "Title",
              content: "Content",
              textOk: labelOk,
              textCancel: labelCancel,
            );
          },
        );
      }),
    ),
  );

  Widget infoDialogWidgetTree = MaterialApp(
    home: Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (context) {
        return IconButton(
          icon: Icon(Icons.info),
          onPressed: () async {
            result = await showNativeDialog(
              context: context,
              title: "Title",
              content: "Content",
              textOk: labelOk,
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

    expect(find.text(labelOk), findsOneWidget);
    expect(find.text(labelCancel), findsOneWidget);
  });

  testWidgets(
      "Given NativeDialog, supplying only testOk argument renders only OK Button.",
      (WidgetTester tester) async {
    await tester.pumpWidget(infoDialogWidgetTree);

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    expect(find.text(labelOk), findsOneWidget);
    expect(find.text(labelCancel), findsNothing);
  });

  testWidgets(
      "Given a native confirmation dialog, pressing confirmation results in true.",
      (WidgetTester tester) async {
    await tester.pumpWidget(confirmationDialogWidgetTree);

    //show dialog
    await tester.tap(find.byType(IconButton));
    await tester.pump();

    //confirm action
    await tester.tap(find.text(labelOk));
    await tester.pump();

    expect(result, true);
  });

  testWidgets(
      "Given a native confirmation dialog, pressing cancel results in false.",
      (WidgetTester tester) async {
    await tester.pumpWidget(confirmationDialogWidgetTree);

    //show dialog
    await tester.tap(find.byType(IconButton));
    await tester.pump();

    //cancel action
    await tester.tap(find.text(labelCancel));
    await tester.pump();

    expect(result, false);
  });
}
