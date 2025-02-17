import 'package:flutter/material.dart';

import 'theme/background.dart';
import 'theme/elevated_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          extensions: [
            ElevatedButtonThemeExtension(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              test: WidgetStateProperty.resolveWith((states) => Colors.red),
            ),
            const BackgroundThemeExtension(
              color: Colors.grey,
              radius: 6,
            ),
          ],
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.backgroundTheme.color,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('Increment'),
              ),
            ],
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      );
}
