import 'package:example/theme/theme.dart';
import 'package:example/viewmodel/counter_viewmodel.dart';
import 'package:example/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

T _getTheme<T>(BuildContext context) => AppTheme.of(context) as T;

void main() {
  themeLookup = _getTheme;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    required this.title,
    Key? key,
  }) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showNativePopup() async {
    final showConfirmationDialog = await showNativeDialog(
      context: context,
      title: "This is a confirmation dialog.",
      content: "Show information popup?",
      textOk: "Yes",
      textCancel: "No",
    );
    if (showConfirmationDialog == true) {
      await showNativeDialog(
        context: context,
        title: "This is an information dialog.",
        content: "You can only agree.",
        textOk: "OK",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CounterViewModel>(
      create: () => CounterViewModel(),
      childBuilderWithViewModel: (context, viewModel, theme) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: _showNativePopup,
              icon: Icon(Icons.info),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${viewModel.current}',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: theme.baseColor),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: viewModel.onIncrementTapped,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
