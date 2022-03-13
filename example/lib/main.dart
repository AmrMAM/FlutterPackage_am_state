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
