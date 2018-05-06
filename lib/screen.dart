import 'package:flutter/material.dart';
import 'package:my_holiday/menu_screen.dart';

class ScreenScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Screen contentScreen;

  ScreenScaffold({this.menuScreen, this.contentScreen});

  @override
  _ScreenScaffold createState() => new _ScreenScaffold();
}

class _ScreenScaffold extends State<ScreenScaffold> {
  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = new MenuController()..addListener(() => setState((){}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  createContentDisplay() {
    return zoomAndSlideContent(new Container(
      decoration:
          new BoxDecoration(image: widget.contentScreen.decorationImage),
      child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: new IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () {
                  menuController.toggle();
                  // TODO:
                }),
            title: new Text(
              widget.contentScreen.title,
              style: new TextStyle(fontSize: 23.0, fontFamily: 'Gugi'),
            ),
          ),
          body: widget.contentScreen.widgetBuilder(context)),
    ));
  }

  zoomAndSlideContent(Widget content) {
    final slideAmount = 235.0 * (menuController.percentOpen);
    final contentScale = 1.0 - (0.2 * menuController.percentOpen);
    final cornerRadius = 10.0 * menuController.percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
              color: const Color(0x44000000),
              offset: const Offset(0.0, 0.5),
              blurRadius: 20.0,
              spreadRadius: 10.0)
        ]),
        child: new ClipRRect(
          borderRadius: new BorderRadius.circular(cornerRadius),
          child: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Stack(
      children: [widget.menuScreen, createContentDisplay()],
    );
  }
}


class ScreenScaffoldMenuController extends StatelessWidget {

  final ScreenScaffoldBuilder builder;

  ScreenScaffoldMenuController({
    this.builder
  });
  
  @override
  Widget build(BuildContext context) {
    return builder(context, getMenuController(context));
  }

  MenuController getMenuController(BuildContext context) {

    final ScreenScaffold = context.ancestorStateOfType(
        new TypeMatcher<_ScreenScaffold>()
    ) as _ScreenScaffold;

    return ScreenScaffold.menuController;
  }
}

typedef ScreenScaffoldBuilder(BuildContext context, MenuController menuController);

class Screen {
  final String title;
  final DecorationImage decorationImage;
  final WidgetBuilder widgetBuilder;

  Screen({this.title, this.decorationImage, this.widgetBuilder});
}

class MenuController extends ChangeNotifier {
  MenuState state = MenuState.closed;
  double percentOpen = 0.0;

  open() {
    state = MenuState.open;
    percentOpen = 1.0;

    notifyListeners();
  }

  close() {
    state = MenuState.closed;
    percentOpen = 0.0;

    notifyListeners();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if(state == MenuState.closed){
      open();
    }
  }
}

enum MenuState { closed, opening, open, closing }
