import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
    tester.view.physicalSize = screen.size;
    expect(widget.runtimeType, equals(TestWrapper));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await takeScreenshot(tester, '${snapshotName}_${screen.name}');
    tester.view.resetPhysicalSize();
  }

  static Future<void> takeScreenshot(
      WidgetTester tester, String snapshotName) async {
    expect(find.byType(TestWrapper), findsOneWidget);
    goldenFileComparator = GoldenDiffComparator('img/$snapshotName.png');
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

extension WidgetControllerExtension on WidgetController {
  Future<void> touchAndCancel(Finder finder,
      {int? pointer, int buttons = kPrimaryButton}) {
    final location = getCenter(finder);
    return TestAsyncUtils.guard<void>(() async {
      final TestGesture gesture =
          await startGesture(location, pointer: pointer, buttons: buttons);
      await gesture.cancel();
    });
  }
}

extension MockExtensions on VerificationResult {
  void calledOnce() => called(1);

  void calledTwice() => called(2);

  void called3Times() => called(3);

  void called4Times() => called(4);
}

class GoldenDiffComparator extends LocalFileComparator {
  final double _kGoldenDiffTolerance = 0.01;

  GoldenDiffComparator(String testFile) : super(Uri.parse(testFile));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent > _kGoldenDiffTolerance) {
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    if (!result.passed) {
      print(
          'A tolerable difference of ${result.diffPercent * 100}% was found when comparing $golden.');
    }
    return result.passed || result.diffPercent <= _kGoldenDiffTolerance;
  }
}
