import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mainstream/mainstream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

final myStream = Stream<int>.periodic(const Duration(seconds: 1), (x) => (x == 3) ? throw Exception('oops') : x).take(5);

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MainStream<int>(
          stream: myStream,
          onData: (data) => debugPrint(data.toString()),
          onError: (error) => _showAlert(context, error.toString()),
          onDone: () => debugPrint('Done!'),
          busyBuilder: (_) => const CircularProgressIndicator(),
          dataBuilder: (_, data) => Text(data.toString()),
          errorBuilder: (_, error) => Text(error.toString()),
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
