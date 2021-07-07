import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

import '../../test_util.dart';

void main() {
  testWidgets('TouchFeedBack on Android', (tester) async {
    final sut = Theme(
      data: ThemeData(platform: TargetPlatform.android),
      child: TouchFeedBack(
        child: Container(
          color: Colors.amber.withOpacity(0.5),
        ),
        onClick: () {},
      ),
    );
    await TestUtil.loadWidgetWithText(tester, sut);
    await TestUtil.takeScreenshot(tester, 'touch_feedback_android');
  });

  testWidgets('TouchFeedBack on Android empty', (tester) async {
    final sut = Theme(
      data: ThemeData(platform: TargetPlatform.android),
      child: TouchFeedBack(
        child: Container(
          color: Colors.amber.withOpacity(0.5),
        ),
        onClick: null,
      ),
    );
    await TestUtil.loadWidgetWithText(tester, sut);
    await TestUtil.takeScreenshot(tester, 'touch_feedback_android_empty');
  });

  testWidgets('TouchFeedBack on iOS', (tester) async {
    final sut = Theme(
      data: ThemeData(platform: TargetPlatform.iOS),
      child: TouchFeedBack(
        child: Container(
          color: Colors.amber.withOpacity(0.5),
        ),
        onClick: () {},
      ),
    );
    await TestUtil.loadWidgetWithText(tester, sut);
    await TestUtil.takeScreenshot(tester, 'touch_feedback_ios');
  });

  group('Click', () {
    testWidgets('TouchFeedBack on Android with click', (tester) async {
      var onClickCalled = false;
      final sut = Theme(
        data: ThemeData(platform: TargetPlatform.android),
        child: TouchFeedBack(
          child: Container(
            color: Colors.amber.withOpacity(0.5),
          ),
          onClick: () {
            onClickCalled = true;
          },
        ),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      final finder = find.byType(TouchFeedBack);
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(onClickCalled, true);
    });

    testWidgets('TouchFeedBack on iOS with click', (tester) async {
      var onClickCalled = false;
      final sut = Theme(
        data: ThemeData(platform: TargetPlatform.iOS),
        child: TouchFeedBack(
          child: Container(
            color: Colors.amber.withOpacity(0.5),
          ),
          onClick: () {
            onClickCalled = true;
          },
        ),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      final finder = find.byType(TouchFeedBack);
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(onClickCalled, true);
    });
    testWidgets('TouchFeedBack on iOS with click', (tester) async {
      var onClickCalled = false;
      final sut = Theme(
        data: ThemeData(platform: TargetPlatform.iOS),
        child: TouchFeedBack(
          child: Container(
            color: Colors.amber.withOpacity(0.5),
          ),
          onClick: () {
            onClickCalled = true;
          },
        ),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      final finder = find.byType(TouchFeedBack);
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pumpAndSettle();
      expect(onClickCalled, true);
    });
    testWidgets('TouchFeedBack on iOS with down and cancel', (tester) async {
      var onClickCalled = false;
      final sut = Theme(
        data: ThemeData(platform: TargetPlatform.iOS),
        child: TouchFeedBack(
          child: Container(
            color: Colors.amber.withOpacity(0.5),
          ),
          onClick: () {
            onClickCalled = true;
          },
        ),
      );
      await TestUtil.loadWidgetWithText(tester, sut);
      final finder = find.byType(TouchFeedBack);
      expect(finder, findsOneWidget);
      await tester.touchAndCancel(finder);
      await tester.pumpAndSettle();
      expect(onClickCalled, false);
    });
  });
}
