library am_state;

export '/src/src.dart';

import 'package:am_state/src/src.dart';
import 'package:flutter/material.dart';

final dataProvider = AmDataProvider<int>(
  initialData: 0,
  providerId: 'dataP_01',
);

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        AmRefreshWidget<int>(
          amDataProvider: AmDataProvider<int>.of('dataP_01'),
          // amDataProvider: dataProvider,                or use this
          builder: (ctx, value) {
            // builder: (ctx) {
            return Text(
              '${dataProvider.data}',
              // ${AmDataProvider.of('dataP_01').data}'   or use this
            );
          },
        ),
        Spacer(),
      ],
    );
  }
}
