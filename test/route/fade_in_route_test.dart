import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

import '../test_util.dart';

void main() {
  group('Route tests', () {
    testWidgets('Fade in route test', (tester) async {
      final widget = await TestUtil.loadWidgetWithText(
        tester,
        Navigator(
          initialRoute: '',
          onGenerateRoute: (_) => FadeInRoute(
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );
      await TestUtil.takeScreenshotForAllSizes(tester, widget, 'fade_in_route');
    });
  });
}
