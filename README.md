# Number Ticker
[![pub package](https://img.shields.io/pub/v/number_ticker.svg)](https://pub.dartlang.org/packages/number_ticker)

Number_ticker is a dart package that provides a Robinhood-like number ticker widget for displaying changing number.

![m](https://user-images.githubusercontent.com/7277662/109929939-e5040680-7c7b-11eb-809a-53f84298cefd.gif)

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:number_ticker/number_ticker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = NumberTickerController();
  final controller1 = NumberTickerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Number Ticker Demo"),
      ),
      body: ListView(
        children: [
          NumberTicker(controller: controller1, initialNumber: 123, textStyle: TextStyle(fontSize: 24),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(onPressed: (){
                controller1.number = controller1.number - 1;
              }, child: Text('-'),),
              RaisedButton(onPressed: (){
                controller1.number = controller1.number + 1;
              }, child: Text('+'),),
              RaisedButton(onPressed: (){
                controller1.number = controller1.number - 10;
              }, child: Text('- 10'),),
              RaisedButton(onPressed: (){
                controller1.number = controller1.number + 10;
              }, child: Text('+ 10'),),
            ],
          ),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

```

