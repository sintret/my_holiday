import 'package:flutter/material.dart';
import 'package:my_holiday/menu_screen.dart';

class ScreenScaffold extends StatefulWidget{

  final Screen contentScreen;

  ScreenScaffold({
    this.contentScreen
});

  @override
  _ScreenScaffold createState() => new _ScreenScaffold();
}

class _ScreenScaffold extends State<ScreenScaffold>{

  createContentDisplay(){
    return new Container(
      decoration: new BoxDecoration(
          image: widget.contentScreen.decorationImage
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
              widget.contentScreen.title,
              style: new TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'Gugi'
              ),
            ),
          ),
          body: widget.contentScreen.widgetBuilder(context)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Stack(
      children: [
        new MenuScreen(),
        createContentDisplay()
      ],
    );
  }
}



class Screen{
  final String title;
  final DecorationImage decorationImage;
  final WidgetBuilder widgetBuilder;

  Screen({
    this.title,
    this.decorationImage,
    this.widgetBuilder
  });
}