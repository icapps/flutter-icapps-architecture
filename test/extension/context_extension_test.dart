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
  });
}
