import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum ScreenType { IPHONE11, IPADPRO }

extension ScreenTypeProperties on ScreenType {
  Size get size {
    switch (this) {
      case ScreenType.IPHONE11:
        return Size(828 * 1.5, 1792 * 1.5 - getStatusBarHeight);
      case ScreenType.IPADPRO:
        return Size(2048 * 1.5, 2732 * 1.5 - getStatusBarHeight);
      default:
        return const Size(500, 500);
    }
  }

  int get getStatusBarHeight {
    switch (this) {
      case ScreenType.IPHONE11:
        return 88;
      case ScreenType.IPADPRO:
        return 40;
      default:
        return 48;
    }
  }

  String get name {
    switch (this) {
      case ScreenType.IPHONE11:
        return 'iphone_11';
      case ScreenType.IPADPRO:
        return 'ipad_pro';
      default:
        return 'unknown_device';
    }
  }
}

class TestUtil {
  // This method should be used when taking screenshot tests of a widget that should not display text
  // Widget snapshot tests
  static Future<Widget> loadWidget(WidgetTester tester, Widget widget) async {
    return _internalLoadWidget(tester, Center(child: widget));
  }

  // This method should be used when taking screenshot tests of a widget that should display text
  // Widget snapshot tests
  static Future<Widget> loadWidgetWithText(
      WidgetTester tester, Widget widget) async {
    return _internalLoadWidget(
      tester,
      MaterialApp(
        theme: ThemeData(),
        home: Center(
          child: Material(
            child: widget,
            color: Colors.transparent,
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  // This method should be used when taking screenshot tests of a single screen
  // Screen integration tests
  static Future<Widget> loadScreen(WidgetTester tester, Widget widget) async {
    return _internalLoadWidget(
      tester,
      widget,
    );
  }

  static Future<Widget> _internalLoadWidget(
      WidgetTester tester, Widget widget) async {
    final testWidget = TestWrapper(child: widget);
    await tester.pumpWidget(testWidget);
    return testWidget;
  }

  static Future<void> takeScreenshotForAllSizes(
      WidgetTester tester, Widget widget, String snapshotName) async {
    for (final screen in ScreenType.values) {
      await takeScreenshotForScreenType(tester, widget, snapshotName,
          screen: screen);
    }
  }

  static Future<void> takeScreenshotForScreenType(
      WidgetTester tester, Widget widget, String snapshotName,
      {ScreenType screen = ScreenType.IPHONE11}) async {
    tester.binding.window.physicalSizeTestValue = screen.size;
    expect(widget.runtimeType, equals(TestWrapper));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await takeScreenshot(tester, '${snapshotName}_${screen.name}');
    tester.binding.window.clearPhysicalSizeTestValue();
  }

  static Future<void> takeScreenshot(
      WidgetTester tester, String snapshotName) async {
    expect(find.byType(TestWrapper), findsOneWidget);
    await expectLater(
      find.byType(TestWrapper),
      matchesGoldenFile('img/$snapshotName.png'),
    );
  }

  static Future<void> pumpAndSettleWithDuration(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  static String getVariableString() {
    return 'Title';
  }
}

class TestWrapper extends StatelessWidget {
  final Widget child;

  const TestWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: RepaintBoundary(
        child: child,
      ),
    );
  }
}
