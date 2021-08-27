<p align="middle">
<img src="https://raw.githubusercontent.com/AmrMAM/FlutterPackage_am_state/main/logo.png">
</p>

[![GitHub contributors](https://img.shields.io/github/contributors/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/contributors)
[![GitHub issues](https://img.shields.io/github/issues/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/issues)
[![GitHub forks](https://img.shields.io/github/forks/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/network)
[![GitHub stars](https://img.shields.io/github/stars/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/stargazers)
[![GitHub license](https://img.shields.io/github/license/AmrMAM/FlutterPackage_am_state)](https://github.com/AmrMAM/FlutterPackage_am_state/blob/main/LICENSE)
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

### Please star my repo and follow me 😍
https://github.com/AmrMAM/FlutterPackage_am_state


## <font color='6776FF'>Licence</font>
[MIT LICENCE](https://github.com/AmrMAM/FlutterPackage_am_state/blob/main/LICENSE)
