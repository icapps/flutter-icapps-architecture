import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  group('Context extension tests', () {
    testWidgets('Detect android theme', (tester) async {
      await tester.pumpWidget(Theme(
        data: ThemeData(platform: TargetPlatform.android),
        child: Builder(builder: (context) {
          expect(context.isAndroidTheme, true);
          expect(context.isIOSTheme, false);
          return Placeholder();
        }),
      ));
    });
    testWidgets('Detect ios theme', (tester) async {
      await tester.pumpWidget(Theme(
        data: ThemeData(platform: TargetPlatform.iOS),
        child: Builder(builder: (context) {
          expect(context.isIOSTheme, true);
          expect(context.isAndroidTheme, false);
          return Placeholder();
        }),
      ));
    });

    testWidgets('Is Tablet on phone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(builder: (context, _) {
          expect(context.isTablet, false);
          return Placeholder();
        }),
      );
    });
    testWidgets('Is Tablet on tablet', (tester) async {
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(size: Size.square(700)),
        child: Builder(builder: (context) {
          expect(context.isTablet, true);
          return Placeholder();
        }),
      ));
    });
    testWidgets('Is portrait', (tester) async {
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(size: Size(400, 500)),
        child: Builder(builder: (context) {
          expect(context.isLandscape, false);
          return Placeholder();
        }),
      ));
    });
    testWidgets('Is landscape', (tester) async {
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(size: Size(500, 400)),
        child: Builder(builder: (context) {
          expect(context.isLandscape, true);
          return Placeholder();
        }),
      ));
    });
  });
}
