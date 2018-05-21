import 'package:flutter/material.dart';
import 'package:my_holiday/nature_screen.dart';
import 'package:my_holiday/planet_screen.dart';
import 'package:my_holiday/menu_screen.dart';
import 'package:my_holiday/screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(backgroundColor: Colors.indigoAccent),
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

  final Menu menu = new Menu(items: [
    MenuItem(id: 'menu1', title: 'HOME'),
    MenuItem(id: 'menu2', title: 'PLANETS'),
    MenuItem(id: 'menu3', title: 'PROFILE'),
    MenuItem(id: 'menu4', title: 'SETTINGS'),
    MenuItem(id: 'menu5', title: 'LOGOUT'),
  ]);

  var selectedMenuItemId = 'menu1';
  var activeState = natureScreen;

  @override
  Widget build(BuildContext context) {

    return new ScreenScaffold(
        menuScreen: new MenuScreen(
          menu: menu,
          selectedItemId: selectedMenuItemId,
          onMenuItemSelected: (String itemId) {
            selectedMenuItemId = itemId;
            //print('Menu Item Selected: $itemId');
            if(itemId == 'menu1'){
              setState(() => activeState = natureScreen);
            } else {
              setState(() => activeState = planetScreen);
            }
          },
        ),
        contentScreen: activeState
    );
  }
}
