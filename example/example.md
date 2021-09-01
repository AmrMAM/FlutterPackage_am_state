# example


## 📱 <font color='6776FF'>Screenshots</font>

<p align="middle">
  <img src="https://raw.githubusercontent.com/AmrMAM/FlutterPackage_am_state/main/example/screenshots/1.png" style="margin: 0px 20px 0px 20px;"  height="600px"/>
  <img src="https://raw.githubusercontent.com/AmrMAM/FlutterPackage_am_state/main/example/screenshots/2.png" style="margin: 0px 20px 0px 20px;"  height="600px"/>
</p>

## Getting Started

### ---> to initialize data providers
```Dart
import 'package:flutter/material.dart';
import 'package:am_state/am_state.dart';

final intProvider = AmDataProvider<int>(
  initialData: 1,
  providerId: 'cNum',
);

final colorProvider = AmDataProvider<MaterialColor>(
  initialData: Colors.blue,
  providerId: 'primarySwatchColor',
);

void initializeProviders() {
  intProvider.initialize;
  colorProvider.initialize;
}

void main() {
  initializeProviders();
  runApp(MyApp());
}
```

### ---> using [AmRefreshWidget] to change theme color when data is changed
```Dart

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    return AmRefreshWidget<MaterialColor>(
      amDataProvider: AmDataProvider<MaterialColor>.of('primarySwatchColor'),
      // amDataProvider: colorProvider, // or you can get the provider by name
      builder: (ctx, value) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'example',
        home: Home(),
        theme: ThemeData(primarySwatch: value),
      ),
    );
  }
}
```

### ---> body and AppBar Implementation
```Dart
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('change text'),
              onPressed: () => intProvider.data = intProvider.data! + 1,
            ),
            AmRefreshWidget<int>(
              amDataProvider: intProvider,
              builder: (ctx, value) {
                return Text('$value');
              },
            ),
            ElevatedButton(
              child: Text('change primary color'),
              onPressed: () {
                colorProvider.data =
                    colorProvider.data == Colors.red ? Colors.blue : Colors.red;
              },
            ),
          ],
        ),
      ),
    );
  }
}
```
### ---> note: we used [AmRefreshWidget] before text to change its string when data is changed
```Dart
            AmRefreshWidget<int>(
              amDataProvider: intProvider,
              builder: (ctx, value) {
                return Text('$value');
              },
            ),
```

### Please star my repo and follow me 😍
https://github.com/AmrMAM/FlutterPackage_am_state