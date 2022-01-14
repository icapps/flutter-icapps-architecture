import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

import '../../test_util.dart';

class TestWidget extends StatefulWidget {
  final VoidCallback afterLayoutCalled;

  const TestWidget({
    required this.afterLayoutCalled,
    Key? key,
  }) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with AfterLayout {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 32,
        height: 32,
        color: Colors.green,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    widget.afterLayoutCalled();
  }
}

void main() {
  group('After layout tests', () {
    testWidgets('Test after layout called', (tester) async {
      var afterLayoutCalled = 0;
      final widget = await TestUtil.loadWidgetWithText(
        tester,
        TestWidget(afterLayoutCalled: () => ++afterLayoutCalled),
      );
      await TestUtil.takeScreenshotForAllSizes(
          tester, widget, 'after_layout_called');
      expect(afterLayoutCalled, 1);
    });
  });
}
