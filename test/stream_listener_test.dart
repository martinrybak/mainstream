import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mainstream/mainstream.dart';

void main() {
  group('Child', () {
    testWidgets('shows child widget if not null', (tester) async {
      const text = 'busy';
      const widget = MaterialApp(
        home: StreamListener(
          stream: Stream.empty(),
          child: Text(text),
        ),
      );
      await tester.pumpWidget(widget);
      expect(find.text(text), findsOneWidget);
    });

    testWidgets('shows default widget if null', (tester) async {
      const widget = MaterialApp(
        home: StreamListener(stream: Stream.empty()),
      );
      await tester.pumpWidget(widget);
      expect(find.byWidgetPredicate((w) => w is SizedBox), findsOneWidget);
    });
  });

  group('Callbacks', () {
    testWidgets('onData called after stream emits data', (tester) async {
      const data = 1;
      final stream = Stream.value(data);
      final widget = MaterialApp(
        home: StreamListener(
          stream: stream,
          onData: expectAsync1((d) => expect(d, data)),
        ),
      );
      await tester.pumpWidget(widget);
      await tester.pump();
    });

    testWidgets('onError called after stream emits error', (tester) async {
      const error = 'error';
      final stream = Stream.error(error);
      final widget = MaterialApp(
        home: StreamListener(
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
        home: StreamListener(
          stream: stream,
          onDone: expectAsync0(() {}),
        ),
      );
      await tester.pumpWidget(widget);
    });
  });
}
