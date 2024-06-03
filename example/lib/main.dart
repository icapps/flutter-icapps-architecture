import 'package:example/screen/counter_screen.dart';
import 'package:example/screen/logger_screen.dart';
import 'package:example/screen/stream_builder_test_screen.dart';
import 'package:example/screen/stream_test_screen.dart';
import 'package:example/screen/touch_screen.dart';
import 'package:example/theme/theme.dart';
import 'package:example/util/locale/localization.dart';
import 'package:example/util/locale/localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

L _getLocale<L>(BuildContext context) => Localization.of(context) as L;

T _getTheme<T>(BuildContext context) => AppTheme.of(context) as T;

void main() {
  localizationLookup = _getLocale;
  themeLookup = _getTheme;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        LocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        'touch': (context) => TouchScreen(),
        'counter': (context) => CounterScreen(),
        'stream_test': (context) => StreamTestScreen(),
        'stream_builder_test': (context) => StreamBuilderTestScreen(),
        'logger': (context) => LoggerScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Touch example'),
              onPressed: () => Navigator.of(context).pushNamed('touch'),
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Counter example'),
              onPressed: () => Navigator.of(context).pushNamed('counter'),
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Logger example'),
              onPressed: () => Navigator.of(context).pushNamed('logger'),
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Stream with initial value example'),
              onPressed: () => Navigator.of(context).pushNamed('stream_test'),
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Stream builder with initial value example'),
              onPressed: () =>
                  Navigator.of(context).pushNamed('stream_builder_test'),
            ),
          ],
        ),
      ),
    );
  }
}
