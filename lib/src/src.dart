import 'package:flutter/material.dart';

/// A wrapper for widgets that must be changed as its provider data is changed.
class AmRefreshWidget<T> extends StatefulWidget {
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
  @override
  void initState() {
    widget.amDataProvider._callSetState.add(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.amDataProvider._data);
  }

  @override
  void dispose() {
    widget.amDataProvider._callSetState.remove(setState);
    super.dispose();
  }
}

/// A data provider accessed in the whole program if it's created with id.
/// You can access its data by [AmDataProvider<T>.of("providerId").data]
class AmDataProvider<T> {
  static Map<String, AmDataProvider> _instances = {};
  T? _data;
  final List<void Function(void Function())> _callSetState = [];

  /// To get the provider id.
  final String? providerId;

  /// Receives a function that instantinously called then (RefreshWidget)s related to this provider are refreshed.
  set activeFunction(void Function() fn) {
    if (_callSetState.isNotEmpty) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
        fn();
        _callSetState.forEach((f) => f(() {}));
      });
    } else {
      fn();
    }
  }

  /// Changes the provider data then (RefreshWidget)s related to this provider are refreshed.
  set data(T? value) {
    if (_callSetState.isNotEmpty) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
        _data = value;
        _callSetState.forEach((f) => f(() {}));
      });
    } else
      _data = value;
  }

  /// Changes the provider data only (No [RefreshWidget] is refreshed).
  set silentDataSet(T? value) => _data = value;
  T? get data => _data;

  /// Refreshes all (RefreshWidget)s related to this provider.
  void refresh() => _callSetState.forEach((f) => f(() {}));

  /// Returns a provider by it's id.
  /// The provider must be initialized first otherwise it returns a new provider with no id.
  factory AmDataProvider.of(String providerId) {
    return (_instances[providerId] ?? AmDataProvider<T>()) as AmDataProvider<T>;
  }

  /// Creates a provider.
  /// You may initialize its data or leave it null.
  /// If you want to access this provider in other pages you should create it with Id.
  factory AmDataProvider({T? initialData, String? providerId}) {
    if (providerId != null) {
      if (_instances[providerId] != null) {
        return _instances[providerId] as AmDataProvider<T>;
      } else {
        _instances[providerId] = AmDataProvider<T>._instance(
          initialData: initialData,
          providerId: providerId,
        );
        return _instances[providerId] as AmDataProvider<T>;
      }
    } else {
      return AmDataProvider<T>._instance(
        initialData: initialData,
      );
    }
  }

  /// you need to use this getter if you want to access the provider with its id at first time.
  void get initialize => false;

  AmDataProvider._instance({T? initialData, this.providerId}) {
    _data = initialData;
    // if (providerId != null) {
    //   _instances[providerId] = this;
    // }
  }
}
