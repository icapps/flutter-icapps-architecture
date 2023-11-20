import 'package:example/viewmodel/logger_viewmodel.dart';
import 'package:example/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';

class LoggerScreen extends StatelessWidget {
  const LoggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<LoggerViewModel>(
      create: () => LoggerViewModel()..init(),
      childBuilderWithViewModel: (context, viewModel, theme, localization) =>
          Scaffold(
        appBar: AppBar(
          title: Text('Logger test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Log: ${viewModel.logLine}',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${viewModel.current}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
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
