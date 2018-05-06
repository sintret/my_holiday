import 'package:my_holiday/screen.dart';
import 'package:flutter/material.dart';
import 'package:my_holiday/main.dart';

class MenuScreen extends StatefulWidget{

  @override
  _MenuScreen createState() => new _MenuScreen();
}

class _MenuScreen extends State<MenuScreen>{

  @override
  Widget build(BuildContext context) {
    return new ScreenScaffoldMenuController(
      builder: (BuildContext context, MenuController menuController){
        return  new Container(
          width: double.infinity,
          height: double.infinity,
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage('images/black_bc.jpg'),
                  fit: BoxFit.cover)
          ),
          child: new Material(
            color: Colors.transparent,
            child: new Stack(
              children: [
                createMenuTitle(),
                createMenuItems(menuController)
              ],
            ),
          ),
        );
      }
    );

  }
  createMenuItems(MenuController menuController) {
    return new Transform(
      transform: new Matrix4.translationValues(0.0, 250.0, 0.0),
      child: new Column(
          children: [
            new _MenuListItems(title:'HOME', isSelected: true, onTap: (){ menuController.close();}),
            new _MenuListItems(title:'PROFILE', isSelected: false, onTap: (){ menuController.close();}),
            new _MenuListItems(title:'ABOUT', isSelected: false, onTap: (){ menuController.close();}),
            new _MenuListItems(title:'SETTING', isSelected: false, onTap: (){ menuController.close();}),

          ]),
    ) ;
  }

  createMenuTitle() {
    return new Transform(
      transform: new Matrix4.translationValues(-100.0, 0.0, 0.0),
      child: new OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: new Padding(
          padding: const EdgeInsets.all(30.0),
          child: new Text(
            'Menu',
            style:
            new TextStyle(fontSize: 230.0, color: const Color(0x88444444)),
            softWrap: false,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}


class _MenuListItems extends StatelessWidget{

  final String title;
  final bool isSelected;
  final Function onTap;

  _MenuListItems({this.title,this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null: onTap,
      child: new Container(
        width: double.infinity,
        child: new Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: new Text(
            title,
            style: new TextStyle(
                fontSize: 25.0, letterSpacing: 2.0, color: isSelected ? Colors.red : Colors.white),
          ),
        ),
      ),
    );
  }
}