import 'dart:async';
import 'package:flutter/material.dart';

/// A [StreamBuilder] alternative that provides builder and event callbacks.
class MainStream<T> extends StreamBuilderBase<T, AsyncSnapshot<T>> {
  final ValueChanged<T>? onData;
  final ValueChanged<Object>? onError;
  final VoidCallback? onDone;
  final T? initialData;
  final WidgetBuilder? busyBuilder;
  final Widget Function(BuildContext, T)? dataBuilder;
  final Widget Function(BuildContext, Object)? errorBuilder;

  const MainStream({
    Key? key,
    required Stream<T> stream,
    this.onData,
    this.onError,
    this.onDone,
    this.initialData,
    this.busyBuilder,
    this.dataBuilder,
    this.errorBuilder,
  }) : super(key: key, stream: stream);

  @override
  AsyncSnapshot<T> initial() {
    if (initialData != null) {
      return AsyncSnapshot<T>.withData(ConnectionState.none, initialData as T);
    }
    return const AsyncSnapshot.nothing();
  }

  @override
  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    if (onData != null) onData!(data);
    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<T> afterError(
      AsyncSnapshot<T> current, Object error, StackTrace stackTrace) {
    if (onError != null) onError!(error);
    return AsyncSnapshot<T>.withError(
        ConnectionState.active, error, stackTrace);
  }

  @override
  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) {
    if (onDone != null) onDone!();
    return current.inState(ConnectionState.done);
  }

  @override
  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> currentSummary) {
    switch (currentSummary.connectionState) {
      case ConnectionState.waiting:
        return _handleBusy(context);
      case ConnectionState.active:
      case ConnectionState.done:
        return _handleSnapshot(context, currentSummary);
      default:
        return _defaultWidget();
    }
  }

  Widget _handleBusy(BuildContext context) {
    if (initialData != null) {
      return _handleData(context, initialData as T);
    }
    if (busyBuilder == null) {
      return _defaultBusyWidget();
    }
    return busyBuilder!(context);
  }

  Widget _handleData(BuildContext context, T data) {
    if (dataBuilder != null) {
      return dataBuilder!(context, data);
    }
    return _defaultWidget();
  }

  Widget _handleSnapshot(BuildContext context, AsyncSnapshot<T> snapshot) {
    if (snapshot.hasError) {
      return _handleError(context, snapshot.error!);
    }
    return _handleData(context, snapshot.data as T);
  }

  Widget _handleError(BuildContext context, Object error) {
    if (errorBuilder != null) {
      return errorBuilder!(context, error);
    }
    return _defaultWidget();
  }

  Widget _defaultBusyWidget() =>
      const Center(child: CircularProgressIndicator());

  Widget _defaultWidget() => const SizedBox.shrink();
}
