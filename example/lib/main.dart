import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mainstream/mainstream.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

final myStream = Stream<int>.periodic(Duration(seconds: 1), (x) => (x == 3) ? throw Exception('oops') : x).take(5);

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MainStream<int>(
          stream: myStream,
          onData: (data) => print(data),
          onError: (error) => _showAlert(context, error.toString()),
          onDone: () => print('Done!'),
          busyBuilder: (_) => CircularProgressIndicator(),
          dataBuilder: (_, data) => Text(data.toString()),
          errorBuilder: (_, error) => Text(error.toString()),
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, String text) {
    showDialog(
      context: context,
      child: AlertDialog(
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
