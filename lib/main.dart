import 'package:flutter/material.dart';
import 'package:my_holiday/nature_screen.dart';
import 'package:my_holiday/planet_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        backgroundColor: Colors.indigoAccent
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var activeState = natureScreen;
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          image: activeState.decorationImage
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: (){
                // TODO:
              }
          ),
          title: new Text(
            activeState.title,
            style: new TextStyle(
                fontSize: 23.0,
                fontFamily: 'Gugi'
            ),
          ),
        ),
        body: activeState.widgetBuilder(context)
      ),
    );
  }
}
