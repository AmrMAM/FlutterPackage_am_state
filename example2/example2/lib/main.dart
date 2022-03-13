import 'package:flutter/material.dart';
import 'package:am_state/am_state.dart';

final intProvider = AmDataProvider<int>(
  initialData: 1,
  providerId: 'cNum',
);
final amProviders = List.generate(
  10,
  (i) => AmDataProvider<int>(
    initialData: 1,
    providerId: 'cNum$i',
  ),
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
  runApp(const MyApp());
}

final objList = AmDataProvider(
    initialData: List.generate(
  10,
  (i) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      ElevatedButton(
        child: const Text('change text'),
        onPressed: () => amProviders[i].data = amProviders[i].data! + 1,
      ),
      Column(
        children: [
          AmRefreshWidget<int>(
            amDataProvider: amProviders[i],
            builder: (ctx, value, tools) {
              var factor = tools.nullableStatePoint<int>(id: 1);
              factor.value = value! * (factor.value ?? 1);
              return Text('${factor.value}');
            },
          ),
        ],
      ),
      ElevatedButton(
        child: const Text('change primary color'),
        onPressed: () {
          colorProvider.data =
              colorProvider.data == Colors.red ? Colors.blue : Colors.red;
        },
      ),
    ],
  ),
));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AmRefreshWidget<MaterialColor>(
      amDataProvider: AmDataProvider<MaterialColor>.of('primarySwatchColor'),
      // amDataProvider: colorProvider, // or you can get the provider by name
      builder: (ctx, value, tools) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'example',
        home: const Home(),
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
          title: const Text('example'),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: AmRefreshWidget<List<Column>>(
            amDataProvider: objList,
            builder: (ctx, value, tools) => Column(children: value!),
          ),
        )));
  }
}
