<p align="middle">
<img src="https://raw.githubusercontent.com/AmrMAM/FlutterPackage_am_state/main/logo.png">
</p>

[![GitHub contributors](https://img.shields.io/github/contributors/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/contributors)
[![GitHub issues](https://img.shields.io/github/issues/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/issues)
[![GitHub forks](https://img.shields.io/github/forks/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/network)
[![GitHub stars](https://img.shields.io/github/stars/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/stargazers)
[![GitHub license](https://img.shields.io/github/license/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/blob/main/LICENSE)
<img src="https://img.shields.io/github/languages/count/AmrMAM/FlutterPackage_am_state" />
<img src="https://img.shields.io/github/languages/top/AmrMAM/FlutterPackage_am_state" />


# am_state
#### A state-management and data providing library. (Fast - Safe - Easy)
### `This lib gives (AmDataProvider<T>) as data provider and (AmRefreshWidget<T>) as wrapper to the widgets that must be changed when provider data changed.`

## Getting Started:

### To import am_state:
```Dart
import 'package:am_state/am_state.dart';
```

### To initialize data provider:
```Dart
final dataProvider = AmDataProvider<int>(
  initialData: 0,
  providerId: 'providerId',
);
dataProvider.initialize;  // you need to use this if you want to access the provider with its id instead of its name at first time.

// OR
final dataProvider = AmDataProvider<int>();  
// You can't access this with id and dying if disposed.
// You can only access this with its name ex:[dataProvider] if still alive.
// if you added a providerId the provider won't die.
```

### To get data anywhere after initializing the provider:
```Dart
int? num = AmDataProvider<int>.of('providerId').data;
```

### To Refresh widgets if data changed:
```Dart
class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AmRefreshWidget<int>(
        amDataProvider: AmDataProvider<int>.of('providerId'),
        builder: (ctx, value) {
          return Text('$value');
        },
      ),
    );
  }
}
```
### `Note: you could use one provider for multiple (AmRefreshWidget)s`
### To change the provider data without refresh states:
```Dart
    
    dataProvider.silentDataSet = dataProvider.data! + 1;
    // OR
    AmDataProvider<String>.of('providerId').silentDataSet = 'any data';

```

### To change provider data with refresh states:
```Dart

    dataProvider.data = dataProvider.data! + 1;
    // OR
    AmDataProvider<String>.of('providerId').data = 'Some Data';

```

### To instantinously excute some code and then refresh states:
```Dart

    dataProvider.activeFunction = () {
      //...Some Code....instantinously invoked then states refreshed
    };
    // OR
    AmDataProvider<String>.of('providerId').activeFunction = () {
      //...Some Code....instantinously invoked then states refreshed
    };

```

### To compare the data in the provider with data just before the last change:
```Dart

    if(dataProvider.data == dataProvider.previousData){
      //...Some Code...
    }else{
      //...Some Code...
    }

```
### To save and get data using AmMemory (Data go out when the program is closed):
### This feature is just to make data accessing more easier in the whole program files.
```Dart

  /// To save an object
  object.amSave(id);
  'Amr Mostafa'.amSave('userName123');              // Example

  /// To get the saved object if null the defaultObject is Returned
  /// Note: the saved object and the default object must be in the same type
  var data = defaultObject.amGet(id);
  var userName = 'Not found'.amGet('userName123');  //Example

  /// OR you can get saved data in that way
  /// Null is Returned if none is saved.
  var data = AmMemory.amGetIfSaved<DataType>(id);
  var userName = AmMemory.amGetIfSaved<String>('userName123') ?? 'Not found';   // Example

```

### To initialize function trigger:
```Dart
final listener = AmFunctionTrigger<int>(
  amDataProvider: AmDataProvider<int>.of('providerId'),
  function: (value){ ... some code ... }
);
listener.start;   // You need to use this line anywhere 
```

### To cancel function trigger listening:
```Dart
listener.cancel();
```

### To reactivate the listener:
```Dart
listener.activate();
```

### To control the [AmRefreshWidget] and adding states to it:
```Dart
child: AmRefreshWidget<int>(
  amDataProvider: dataProvider,
  builder: (ctx, value) {
    /// This controller you may send as a parameter anyway but you have rarely to do this_
    /// Because the [AmDataProvider] may do the same goal.
    var controller = AmRefreshWidgetController.of(ctx);

    /// When this code block is called this variable will have the last value.
    /// if it is the frist time to call this code, this variable will have 5 as initial value.
    var intState = controller.statePoint<int>(id: 1, initialValue: 5);
    
    ///Dummy Code to use the statePoint variable.
    intState.value = value! * (intState.value);
    return Text('${intState.value}');
  },
),
```

### Please star my repo and follow me 😍
https://github.com/AmrMAM/FlutterPackage_am_state


## <font color='6776FF'>Licence</font>
[BSD-3-Clause LICENCE](https://github.com/AmrMAM/FlutterPackage_am_state/blob/main/LICENSE)
