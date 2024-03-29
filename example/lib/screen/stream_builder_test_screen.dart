import 'package:example/viewmodel/stream_test_viewmodel.dart';
import 'package:example/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';

class StreamBuilderTestScreen extends StatelessWidget {
  const StreamBuilderTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<StreamTestViewModel>(
      create: () => StreamTestViewModel()..init(),
      childBuilderWithViewModel: (context, viewModel, theme, localization) =>
          Scaffold(
        appBar: AppBar(
          title: Text('Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              StreamBuilder(
                stream: viewModel.counterStream,
                builder: (context, snapshot) => Text(
                  '${snapshot.data}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: theme.baseColor),
                ),
              ),
              TextButton(
                onPressed: viewModel.addStream,
                child: Text('Add stream'),
              )
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
