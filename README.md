# am_state
#### A state-management and data providing library. 
#### ---No stateful widgets needed---


## Getting Started

### To initialize data provider
```Dart
import 'package:am_state/am_state.dart';

final dataProvider = AmDataProvider<int>(
  initialData: 0,
  providerId: 'dataP_01',
);

// OR
final dataProvider = AmDataProvider<int>();     // You can't access this with id
```

### To get data any where after initializing the provider
```Dart
int? num = AmDataProvider<int>.of('dataP_01').data;
```

### To Refresh widgets if data changed
```Dart
class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AmRefreshWidget<int>(
        amDataProvider: AmDataProvider<int>.of('providerId'),
        builder: (ctx, value) {
          return Text(
            '$value',
          );
        },
      ),
    );
  }
}
```

### To change the provider data without refresh states
```Dart
    
    dataProvider.silentDataSet = dataProvider.data! + 1;
    // OR
    AmDataProvider<String>.of('providerId').silentDataSet = 'any data';

```

### To change provider data with refresh states
```Dart

    dataProvider.data = dataProvider.data! + 1;
    // OR
    AmDataProvider<String>.of('providerId').data = 'Some Data';

```

### To instantinously excute some code and then refresh states
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
