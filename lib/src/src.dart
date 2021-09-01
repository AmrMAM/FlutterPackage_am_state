import 'dart:async';
import 'package:flutter/material.dart';

enum ProviderDoFirst {
  UpdateStatesFirst,
  FireTriggerFunctionFirst,
}

/// A wrapper for widgets that must be changed as its provider data is changed.
class AmRefreshWidget<T> extends StatefulWidget {
  /// A wrapper for widgets that must be changed as its provider data is changed.

  const AmRefreshWidget(
      {Key? key, required this.builder, required this.amDataProvider})
      : super(key: key);

  /// Takes [AmDataProvider<T>] to refresh state if the provider data is changed.
  final AmDataProvider<T> amDataProvider;

  /// A function gives you context and the provider data as parameters and returns the child of this widget(AmRefreshWidget).
  final Widget Function(BuildContext ctx, T? value) builder;

  @override
  _AmRefreshStateState<T> createState() => _AmRefreshStateState<T>();
}

class _AmRefreshStateState<T> extends State<AmRefreshWidget<T>> {
  final key = UniqueKey();

  @override
  void initState() {
    widget.amDataProvider._callSetState.add(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.amDataProvider._data);
  }

  @override
  void dispose() {
    widget.amDataProvider._callSetState.removeWhere((e) => e.key == key);
    super.dispose();
  }
}

/// Fires a function when the given provider data is changed
class AmFunctionTrigger<T> {
  final _key = UniqueKey();

  /// Takes [AmDataProvider<T>] to fire the function if the provider data is changed.
  final AmDataProvider<T> amDataProvider;

  /// A function to fire when the provider data is changed
  final void Function(T? value) function;

  /// Fires a function when the given provider data is changed
  AmFunctionTrigger({required this.amDataProvider, required this.function}) {
    amDataProvider._callFunctions[_key] = this;
  }

  /// Cancels listening the provider.
  void cancel() =>
      amDataProvider._callFunctions.removeWhere((key, value) => key == _key);

  /// Reactivates listening the provider.
  void activate() => amDataProvider._callFunctions[_key] = this;

  /// you need to use this getter to start listening.
  void get start => false;
}

/// A data provider accessed in the whole program if it's created with id.
/// You can access its data by [AmDataProvider<T>.of("providerId").data]
class AmDataProvider<T> {
  static final Map<String, AmDataProvider> _instances = {};
  T? _data;
  final List<_AmRefreshStateState<T>> _callSetState = [];
  final Map<Key, AmFunctionTrigger<T>> _callFunctions = {};

  /// To get the provider id.
  final String? providerId;
  ProviderDoFirst doFirst;

  /// Receives a function that instantinously called then (RefreshWidget)s related to this provider are refreshed.
  set activeFunction(void Function() fn) {
    fn();
    _refresh();
  }

  /// Changes the provider data then (RefreshWidget)s related to this provider are refreshed.
  set data(T? value) {
    _data = value;
    _refresh();
  }

  /// Changes the provider data only (No [RefreshWidget] is refreshed).
  set silentDataSet(T? value) => _data = value;
  T? get data => _data;

  /// Fires all TriggerFunctions and Refreshes all (RefreshWidget)s related to this provider.
  void refresh() => _refresh();

  void _refresh() {
    if (doFirst == ProviderDoFirst.FireTriggerFunctionFirst) {
      if (_callFunctions.isNotEmpty) {
        _callFunctions.forEach((key, value) => value.function(_data));
      }
      if (_callSetState.isNotEmpty) {
        _callSetState.forEach((f) {
          Timer.periodic(Duration(milliseconds: 5), (_) {
            if (f.mounted) {
              _.cancel();
              // ignore: invalid_use_of_protected_member
              f.setState(() {});
            }
          });
        });
      }
    } else {
      if (_callSetState.isNotEmpty) {
        _callSetState.forEach((f) {
          Timer.periodic(Duration(milliseconds: 5), (_) {
            if (f.mounted) {
              _.cancel();
              // ignore: invalid_use_of_protected_member
              f.setState(() {});
            }
          });
        });
      }
      if (_callFunctions.isNotEmpty) {
        _callFunctions.forEach((key, value) => value.function(_data));
      }
    }
  }

  /// Returns a provider by it's id.
  /// The provider must be initialized first otherwise it returns a new provider with no id.
  factory AmDataProvider.of(String providerId) {
    return (_instances[providerId] ?? AmDataProvider<T>._instance())
        as AmDataProvider<T>;
  }

  /// Creates a provider.
  /// You may initialize its data or leave it null.
  /// If you want to access this provider in other pages you should create it with Id.
  factory AmDataProvider({
    T? initialData,
    String? providerId,
    ProviderDoFirst providerDoFirst = ProviderDoFirst.FireTriggerFunctionFirst,
  }) {
    if (providerId != null) {
      if (_instances[providerId] != null) {
        return _instances[providerId] as AmDataProvider<T>;
      } else {
        _instances[providerId] = AmDataProvider<T>._instance(
          initialData: initialData,
          providerId: providerId,
          doFirst: providerDoFirst,
        );
        return _instances[providerId] as AmDataProvider<T>;
      }
    } else {
      return AmDataProvider<T>._instance(
        initialData: initialData,
        doFirst: providerDoFirst,
      );
    }
  }

  /// you need to use this getter if you want to access the provider with its id at first time.
  void get initialize => false;

  AmDataProvider._instance({
    T? initialData,
    this.providerId,
    this.doFirst = ProviderDoFirst.FireTriggerFunctionFirst,
  }) {
    _data = initialData;
    // if (providerId != null) {
    //   _instances[providerId] = this;
    // }
  }
}
