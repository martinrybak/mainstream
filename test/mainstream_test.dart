import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mainstream/mainstream.dart';

// ignore_for_file: missing_required_param

void main() {
  group('Constructor', () {
    testWidgets('throws assertion error if stream is null', (tester) async {
      expect(() => MainStream(), throwsAssertionError);
    });
  });

  group('Builders', () {
    testWidgets('initially shows busyBuilder', (tester) async {
      final text = 'busy';
      final stream = Stream.value(0);
      final widget = MaterialApp(
        home: MainStream(
          stream: stream,
          busyBuilder: (_) => Text(text),
        ),
      );
      await tester.pumpWidget(widget);
      expect(find.text(text), findsOneWidget);
    });

    testWidgets('initially shows default busy widget if busyBuilder is null', (tester) async {
      final stream = Stream.value(0);
      final widget = MaterialApp(
        home: MainStream(stream: stream),
      );
      await tester.pumpWidget(widget);
      expect(find.byWidgetPredicate((w) => w is CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('initially shows dataBuilder if initialData is not null', (tester) async {
      final initialData = 0;
      final nextData = 1;
      final stream = Stream.value(nextData);
      final widget = MaterialApp(
        home: MainStream(
          stream: stream,
          initialData: initialData,
          dataBuilder: (_, data) => Text(data.toString()),
        ),
      );
      await tester.pumpWidget(widget);
      expect(find.text(initialData.toString()), findsOneWidget);
    });

    testWidgets('shows dataBuilder after stream emits data', (tester) async {
      final initialData = 0;
      final nextData = 1;
      final stream = Stream.value(nextData);
      final widget = MaterialApp(
        home: MainStream(
          stream: stream,
          initialData: initialData,
          dataBuilder: (_, data) => Text(data.toString()),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      expect(find.text(nextData.toString()), findsOneWidget);
    });

    testWidgets('shows errorBuilder after stream emits error', (tester) async {
      final error = 'error';
      final stream = Stream.error(error);
      final widget = MaterialApp(
        home: MainStream(
          stream: stream,
          errorBuilder: (_, error) => Text(error),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
      expect(find.text(error), findsOneWidget);
    });
  });

  group('Callbacks', () {
    testWidgets('onData called after stream emits data', (tester) async {
      final data = 1;
      final stream = Stream.value(data);
      final widget = MaterialApp(
        home: MainStream(
          stream: stream,
          onData: expectAsync1((d) => expect(d, data)),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
    });

    testWidgets('onError called after stream emits error', (tester) async {
      final error = 'error';
      final stream = Stream.error(error);
      final widget = MaterialApp(
        home: MainStream(
          stream: stream,
          onError: expectAsync1((e) => expect(e, error)),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
    });

    testWidgets('onDone called after stream completes', (tester) async {
      final stream = Stream.value(0);
      final widget = MaterialApp(
        home: MainStream(
          stream: stream,
          onDone: expectAsync0(() {}),
        ),
      );
      await tester.pumpWidget(widget);
    });
  });
}
