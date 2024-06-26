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
### It has an easy technique to implement (Model, View, Controller) for flutter Pages
### `This lib gives (AmDataProvider<T>) as data provider and (AmRefreshWidget<T>) as wrapper to the widgets that must be changed when provider data changed.`

# Getting Started:
  ### it will be great if you installed [am-state] extension in vsCode 
  https://marketplace.visualstudio.com/items?itemName=Amr-MAM.am-state

  ### To import am_state:
  ```Dart
  import 'package:am_state/am_state.dart';
  ```

## For well-organized code; we need to create 3 dart files for each screen
  - ### The 1st dart file is for State model class extends nothing
    - `we need to create a normal class which has all properity we need to display in the UI page`
    ###
  - ### The 2nd file is for the Controller Class and we extend from [AmController<StateModelClass>]
    - `we need to create a class for the controller extended from [AmController<State_Class>]`
    ###
  - ### The 3rd dart file is for UI and we extend from this class [AmViewWidget<ControllerClass>]

  ## It is time for an easy example for the home page  
  - ### `The 1st step` ==> Creating State dart file `home_state.dart` and adding this code
    ```Dart
    class HomeState {
      int number = 0;
      String title = 'hello';
    }
    ```
  - ### `The 2nd step` ==> Creating Controller dart file `home_controller.dart` and adding this code
      #### Easily if you installed the extension you can write `amcont` then choose the snippet code and fill the fields
      ```Dart
      class HomeController extends AmController<HomeState> {
        HomeController(super.state);

        void increaseby1() {
          state.number++;
          refresh();
        }

        void decreaseby1() {
          state.number--;
          refresh();
        }

        void changeTitle() {
          state.title = '${state.title} Hi;\n';
          refresh();
        }
        
        // use the command 'refresh();' inside functions to update the view widget
        // ---------------------------------------------------------------------------
        @override
        void onDispose() {}

        @override
        void onInit() {}
      }

      ```


  - ### `The 3rd step` ==> Creating UI dart file `home_ui.dart` and adding this code
      #### Easily if you installed the extension you can write `amview` then choose the snippet code and fill the fields
      ```Dart 

      class MyHomePage extends AmViewWidget<HomeController> {
        const MyHomePage({super.key});

        @override
        Widget build(BuildContext context, am) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Hi Am State App Test'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  'Wow ${am.state.title}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'num ---- ${am.state.number}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => am.increaseby1(),
                  child: const Icon(Icons.plus_one),
                ),
                ElevatedButton(
                  onPressed: () => am.decreaseby1(),
                  child: const Icon(Icons.remove),
                ),
                ElevatedButton(
                  onPressed: () => am.changeTitle(),
                  child: const Icon(Icons.change_circle),
                ),
              ],
            ),
          );
        }

        @override
        get config => HomeController(HomeModel());
      }
      ```

  #### And that is all you need to do to create a page in well-organized clean code

## To Send And Get data by [AmChannel] in the whole app
### To create a channel and save data in it
```Dart
    AmChannel<String>.of('/home/adminName').amSend = 'Amr Mostafa';
```

### To get the last value saved in a channel
```Dart
    print(AmChannel<String>.of('/home/adminName').amGet);
```

### To get the last previous value saved in a channel
```Dart
    print(AmChannel<String>.of('/home/adminName').amGetPrevious);
```

### To Delete the channel
```Dart
    AmChannel.of('/home/adminName').delete();
```

## For inner widgets working and [AmDataProvider] and [AmRefreshWidget]
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
#### This feature is just to make data accessing more easier in the whole program files.
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

## Additional Tools
  - ### to generate unique id in milli seconds resolution
    ```Dart
      import 'package:am_state/am_state.dart';

      var uid = AmTools.genUniqueId();
    ```
  
  - ### to generate unique id in micro seconds resolution
    ```Dart
      import 'package:am_state/am_state.dart';

      var uid = AmTools.genUniqueIdMicro();
    ```
  
  - ### to calculate the MD5 hash of the given [String]
    ```Dart
      import 'package:am_state/am_state.dart';

      var hash = AmTools.calculateMD5Hash(" ------- string ------");
    ```
  
  - ### to calculate the MD5 hash of the given [File]
    ```Dart
      import 'package:am_state/am_state.dart';

      var hash = AmTools.calculateMD5HashFromFile(file);
    ```  
  
  - ### to calculate the MD5 hash of the given bytes [Uint8List]
    ```Dart
      import 'package:am_state/am_state.dart';

      var hash = AmTools.calculateMD5HashFromBytes(byteList);
    ```

  - ### some extra extensions
    ```Dart
      import 'package:am_state/am_state.dart';

      bool x = "true ".toBool();

      String x = date.amDateFormatYYMMDD();
      String x = date.amTimeFormatHHMMSS();
      String x = date.amTimeFormatHHMMPMam();

      String x = duration.convertToString();
      String x = duration.convertToWatchString();

      String x = file.getFileName;
      String x = file.getFileExtension;

      /// ex. split [1, 2, 3, 3, 4, 5, 3, 3, 6, 7] for [3, 3]
      /// result => [[1, 2], [4, 5], [6, 7]]
      List<List<T>> x = list.splitList(delimiterList);
    ```


### Please star my repo and follow me 😍
https://github.com/AmrMAM/FlutterPackage_am_state


## <font color='6776FF'>Licence</font>
[BSD-3-Clause LICENCE](https://github.com/AmrMAM/FlutterPackage_am_state/blob/main/LICENSE)
