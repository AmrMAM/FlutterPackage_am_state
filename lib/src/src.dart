import 'dart:async';

import 'package:flutter/material.dart';

enum ProviderDoFirst {
  /// Updates [AmRefreshWidget]s frist then Update [AmFunctionTrigger]s
  UpdateStatesFirst,

  /// Updates [AmFunctionTrigger]s frist then Update [AmRefreshWidget]s
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
  Map<int, _AmState> _states = {};

  _AmState<K> _getState<K>({required int id, required K initialValue}) {
    if (_states[id] != null) {
      return _states[id] as _AmState<K>;
    } else {
      _states[id] = _AmState<K>(value: initialValue);
      return _states[id] as _AmState<K>;
    }
  }

  _AmState<K?> _getStateNullable<K>({required int id, K? initialValue}) {
    if (_states[id] != null) {
      return _states[id] as _AmState<K?>;
    } else {
      if (initialValue != null) {
        _states[id] = _AmState<K?>(value: initialValue);
      } else {
        _states[id] = _AmState<K?>(value: null);
      }
      return _states[id] as _AmState<K?>;
    }
  }

  @override
  void initState() {
    widget.amDataProvider._callSetState.add(this);
    AmRefreshWidgetController._instances[context] =
        AmRefreshWidgetController._inst(
      statePoint: _getState,
      key: key,
      nullableStatePoint: _getStateNullable,
      refresh: widget.amDataProvider._refresh,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget.amDataProvider._data,
    );
  }

  @override
  void dispose() {
    widget.amDataProvider._callSetState.removeWhere((e) => e.key == key);
    // AmRefreshWidgetController._instances
    //     .removeWhere((key, value) => key == context);
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

class _AmState<T> {
  T value;
  _AmState({required this.value});
}

/// Gets The Controller for the [AmRefreshWidget].
/// you may add state variables or Refresh the current state or ..etc.
class AmRefreshWidgetController {
  static final Map<BuildContext, AmRefreshWidgetController> _instances = {};

  /// Save or Get a state variable related to this widget
  final _AmState<T> Function<T>({required int id, required T initialValue})
      statePoint;

  /// Save or Get a nullable state variable related to this widget
  final _AmState<T?> Function<T>({required int id, T? initialValue})
      nullableStatePoint;

  /// Fires all TriggerFunctions and Refreshes all (RefreshWidget)s related to the given provider
  /// Considering all StatePoints
  final void Function() refresh;

  final UniqueKey key;

  /// Gets The Controller for the [AmRefreshWidget] ==> Use the context given in the builder.
  /// if the context is not for an activated [AmRefreshWidget] there will be an error.
  factory AmRefreshWidgetController.of(BuildContext ctx) => _instances[ctx]!;

  AmRefreshWidgetController._inst({
    required this.statePoint,
    required this.key,
    required this.nullableStatePoint,
    required this.refresh,
  });
}

/// A data provider accessed in the whole program if it's created with id.
/// You can access its data by [AmDataProvider<T>.of("providerId").data]
class AmDataProvider<T> {
  static final Map<String, AmDataProvider> _instances = {};
  T? _data;
  T? _prvData;
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

  /// Changes the provider data then [RefreshWidget]s related to this provider are refreshed.
  set data(T? value) {
    _prvData = _data;
    _data = value;
    _refresh();
  }

  /// Changes the provider data only (No [RefreshWidget] is refreshed).
  set silentDataSet(T? value) {
    _prvData = _data;
    _data = value;
  }

  /// To get the data stored in the provider.
  T? get data => _data;

  /// To get the data stored in the provider just before the last update.
  T? get previousData => _prvData;

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

extension AmMemory<T> on T {
  static final _stmem = {};

  /// Returns the object saved and associated with this id;
  /// if nothing is saved it Returns this parent object;
  T amGet(id) {
    if (_stmem[id] == null) {
      return this;
    } else {
      return _stmem[id];
    }
  }

  /// to Get the saved object associated with this id;
  /// Returns null if there is nothing saved;
  static K? amGetIfSaved<K>(id) {
    if (_stmem[id] == null) {
      return null;
    } else {
      return _stmem[id];
    }
  }

  /// to Save this object with an id;
  void amSave(id) => _stmem[id] = this;
}

//==============================================================================

/// to create a data channel to send and recieve data in easy way in the whole app
class AmChannel<T> {
  static final _stmem = {};
  T? _currentValue;
  T? _previousValue;
  final dynamic route;
  final Map<String, void Function(T?)> _recEvents = {};
  final Map<String, void Function(T)> _changeEvents = {};

  AmChannel._internal(this.route);
  factory AmChannel.of(route) {
    if (_stmem[route] != null) {
      return _stmem[route];
    } else {
      final me = AmChannel<T>._internal(route);
      _stmem[route] = me;
      return me;
    }
  }

  /// to get the last value saved to this channel
  T? get amGet => _currentValue;

  /// to get the previous value saved to this channel
  /// (just the value before the last value)
  T? get amGetPrevious => _previousValue;

  /// to set a value to the current channel route;
  set amSend(T object) {
    _previousValue = _currentValue;
    _currentValue = object;

    // for recieve events
    try {
      for (var ev in _recEvents.values) {
        try {
          ev(object);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {}

    // for changing current value events
    if (_currentValue != _previousValue) {
      try {
        for (var ev in _changeEvents.values) {
          try {
            ev(object);
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {}
    }
  }

  void get invokeEvents {
    // for recieve events
    try {
      for (var ev in _recEvents.values) {
        try {
          ev(_currentValue);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {}
  }

  /// to add an event for [On Recieve a value].
  /// returns the event id.
  String addEventOnRecieve(Function(T?) event) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _recEvents[id] = event;
    return id;
  }

  /// to remove an event for [On Recieve a value].
  void removeEventOnRecieve(eventID) {
    _recEvents.remove(eventID);
  }

  /// to add an event for [On Change the current value].
  /// returns the event id.
  String addEventOnChange(Function(T) event) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _changeEvents[id] = event;
    return id;
  }

  /// to remove an event for [On Change the current value].
  void removeEventOnChange(eventID) {
    _changeEvents.remove(eventID);
  }

  /// to delete the channel for this route (to freeup memory)
  void delete() => _stmem.remove(route);
}

///=============================================================================
///           AmViewWidget      AmController       Model
///=============================================================================

/// A wrapper for widgets that must be changed as its controller [refresh] method is invoked.
abstract class AmViewWidget<T extends AmController> extends StatefulWidget {
  /// A wrapper for widgets that must be changed as its controller [refresh] method is invoked.
  const AmViewWidget({Key? key}) : super(key: key);

  T get config;
  Widget build(BuildContext context, T am);

  @override
  _AmViewWstate<T> createState() => _AmViewWstate<T>();
}

class _AmViewWstate<T extends AmController> extends State<AmViewWidget<T>> {
  final key = UniqueKey();
  T? _controller;

  @override
  void initState() {
    // widget.amDataProvider._callSetState.add(this);
    // AmRefreshWidgetController._instances[context] =
    //     AmRefreshWidgetController._inst(
    //   statePoint: _getState,
    //   key: key,
    //   nullableStatePoint: _getStateNullable,
    //   refresh: widget.amDataProvider._refresh,
    // );

    _controller = widget.config;
    (_controller! as dynamic)._refresh =
        () => Timer.periodic(Duration(milliseconds: 5), (_) {
              if (mounted) {
                _.cancel();
                // ignore: invalid_use_of_protected_member
                setState(() {});
              }
            });

    (_controller as dynamic)._ctx = context;
    (_controller as dynamic).onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, _controller!);
  }

  @override
  void dispose() {
    // widget.amDataProvider._callSetState.removeWhere((e) => e.key == key);
    // AmRefreshWidgetController._instances
    //     .removeWhere((key, value) => key == context);
    (_controller as dynamic).onDispose();
    super.dispose();
  }
}

// /// A wrapper for widgets that must be changed as its controller [refresh] method is invoked.
// class AmStateWidget<T extends AmController> extends StatefulWidget {
//   /// A wrapper for widgets that must be changed as its controller [refresh] method is invoked.
//   const AmStateWidget(
//       {Key? key, required this.builder, required this.amController})
//       : // assert(amController is AmController),
//         super(key: key);

//   /// Takes [AmController] to refresh state if the [refresh] method is invoked.
//   final T amController;

//   /// A function gives you context and the controller with state as parameters and returns the widget you build.
//   final Widget Function(BuildContext ctx, T am) builder;

//   @override
//   _AmStateWstate<T> createState() => _AmStateWstate<T>();
// }

// class _AmStateWstate<T extends AmController> extends State<AmStateWidget<T>> {
//   final key = UniqueKey();
//   T? _controller;

//   @override
//   void initState() {
//     // widget.amDataProvider._callSetState.add(this);
//     // AmRefreshWidgetController._instances[context] =
//     //     AmRefreshWidgetController._inst(
//     //   statePoint: _getState,
//     //   key: key,
//     //   nullableStatePoint: _getStateNullable,
//     //   refresh: widget.amDataProvider._refresh,
//     // );

//     _controller = widget.amController;
//     // (_controller! as dynamic)._refresh = () => setState(() {});
//     (_controller! as dynamic)._refresh =
//         () => Timer.periodic(Duration(milliseconds: 5), (_) {
//               if (mounted) {
//                 _.cancel();
//                 // ignore: invalid_use_of_protected_member
//                 setState(() {});
//               }
//             });

//     (_controller as dynamic)._ctx = context;
//     (_controller as dynamic).onInit();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.builder(context, _controller!);
//   }

//   @override
//   void dispose() {
//     // widget.amDataProvider._callSetState.removeWhere((e) => e.key == key);
//     // AmRefreshWidgetController._instances
//     //     .removeWhere((key, value) => key == context);
//     (_controller as dynamic).onDispose();
//     super.dispose();
//   }
// }

abstract class _Cstate<T> {
  final T state;
  _Cstate(this.state);
}

abstract class AmController<T> extends _Cstate<T> {
  void Function()? _refresh;
  BuildContext? _ctx;
  // bool? _isMounted;
  AmController(T model) : super(model);

  void onInit();
  void onDispose();

  void Function() get refresh {
    if (_refresh != null) return _refresh!;
    throw 'AM_State: the [AmStateWidget] is not initialized for this controller [${this.runtimeType}]';
  }

  // bool get readyToRefresh {
  //   if (_isMounted != null) return _isMounted!;
  //   throw 'AM_State: the [AmStateWidget] is not initialized for this controller [${this.runtimeType}]';
  // }

  BuildContext get context {
    if (_ctx != null) return _ctx!;
    throw 'AM_State: the [AmStateWidget] is not initialized for this controller [${this.runtimeType}]';
  }
}
