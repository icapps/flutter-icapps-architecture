import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class TouchScreen extends StatefulWidget {
  const TouchScreen({super.key});

  @override
  State<TouchScreen> createState() => _TouchScreenState();
}

class _TouchScreenState extends State<TouchScreen> {
  Map<Color, int> _counters = Colors.primaries.asMap().map(
        (key, value) => MapEntry(
          value,
          0,
        ),
      );

  bool forceAndroid = false;
  bool forceIOS = false;
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Touch'),
      ),
      body: Center(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: forceAndroid,
                  onChanged: (value) => setState(() => forceAndroid = value ?? false),
                ),
                Text('Force Android'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: forceIOS,
                  onChanged: (value) => setState(() => forceIOS = value ?? false),
                ),
                Text('Force iOS'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isDark,
                  onChanged: (value) => setState(() => isDark = value ?? false),
                ),
                Text('Is Dark'),
              ],
            ),
            Center(
              child: Text(
                'You have pushed the buttons this many times:',
              ),
            ),
            ..._counters.entries.map(
              (entry) {
                final color = entry.key;
                final count = entry.value;
                return Center(
                  child: Text(
                    '0x${color.value.toRadixString(16).padLeft(8, '0')}: $count',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: color),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: _createButtons(_counters),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TouchFeedBack(
                    isDark: isDark,
                    onClick: () {},
                    child: Icon(
                      Icons.plus_one,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TouchFeedBack(
                    isDark: isDark,
                    onClick: () {},
                    child: Text(
                      'Tap me',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _createButtons(Map<Color, int> counters) {
    if (counters.isEmpty) return const SizedBox();
    return TouchFeedBack(
      forceAndroid: forceAndroid,
      forceIOS: forceIOS,
      isDark: isDark,
      onClick: () {
        setState(() {
          _counters.update(counters.keys.first, (value) => value + 1);
        });
      },
      child: Container(
        color: counters.entries.first.key,
        padding: const EdgeInsets.all(16),
        child: _createButtons(
          counters.entries.skip(1).toList().asMap().map(
                (key, value) => MapEntry(
                  value.key,
                  value.value,
                ),
              ),
        ),
      ),
    );
  }
}
