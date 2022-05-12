import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  testWidgets(
      "Given LifecycleWidget, App lifecycleStateChanges are propagated to the correct callback. ",
      (WidgetTester tester) async {
    var onResumeCalled = 0;
    var onPauseCalled = 0;
    var onDetachedCalled = 0;
    var onInactiveCalled = 0;

    await tester.pumpWidget(LifecycleWidget(
      onResume: () => ++onResumeCalled,
      onPause: () => ++onPauseCalled,
      onDetached: () => ++onDetachedCalled,
      onInactive: () => ++onInactiveCalled,
      child: Container(),
    ));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);

    expect(onResumeCalled, 1);
    expect(onPauseCalled, 2);
    expect(onDetachedCalled, 3);
    expect(onInactiveCalled, 4);
  });
}
