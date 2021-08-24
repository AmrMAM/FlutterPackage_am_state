import 'package:flutter/material.dart';

class AmRefreshWidget<T> extends StatefulWidget {
  const AmRefreshWidget(
      {Key? key, required this.builder, required this.amDataProvider})
      : super(key: key);

  final AmDataProvider<T> amDataProvider;
  final Widget Function(BuildContext ctx, T? value) builder;

  @override
  _AmRefreshStateState<T> createState() => _AmRefreshStateState<T>();
}

class _AmRefreshStateState<T> extends State<AmRefreshWidget<T>> {
  @override
  void didChangeDependencies() {
    widget.amDataProvider._callSetState = setState;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.amDataProvider._data);
  }
}

class AmDataProvider<T> {
  static final _instances = <String, dynamic>{};
  T? _data;
  void Function(void Function())? _callSetState;
  set activeFunction(void Function() fn) {
    if (_callSetState != null) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
        _callSetState!(() => fn());
      });
    } else {
      fn();
    }
  }

  set data(T? value) {
    if (_callSetState != null) {
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
        _callSetState!(() => _data = value);
      });
    } else
      _data = value;
  }

  set silentDataSet(T? value) => _data = value;
  T? get data => _data;
  void refresh() => _callSetState!(() {});
  factory AmDataProvider.of(String providerId) {
    return (_instances[providerId] ?? AmDataProvider._instance())
        as AmDataProvider<T>;
  }

  factory AmDataProvider({T? initialData, String? providerId}) {
    if (providerId != null) {
      if (_instances[providerId] != null) {
        return _instances[providerId] as AmDataProvider<T>;
      } else {
        return AmDataProvider._instance(
          initialData: initialData,
          providerId: providerId,
        );
      }
    } else {
      return AmDataProvider._instance(
        initialData: initialData,
        providerId: providerId,
      );
    }
  }
  AmDataProvider._instance({T? initialData, String? providerId}) {
    _data = initialData;
    if (providerId != null) {
      _instances[providerId] = this;
    }
  }
}
