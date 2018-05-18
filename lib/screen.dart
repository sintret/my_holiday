import 'package:flutter/material.dart';
import 'package:my_holiday/menu_screen.dart';

class ScreenScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Screen contentScreen;

  ScreenScaffold({this.menuScreen, this.contentScreen});

  @override
  _ScreenScaffoldState createState() => new _ScreenScaffoldState();
}

class _ScreenScaffoldState extends State<ScreenScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;

  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 0.1, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 0.1, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 0.1, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(vsync: this)
      ..addListener(() => setState(() {}));
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
    var slidePercent, scalePercent;

    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    final slideAmount = 235.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
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

  ScreenScaffoldMenuController({this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, getMenuController(context));
  }

  MenuController getMenuController(BuildContext context) {
    final ScreenScaffold =
        context.ancestorStateOfType(new TypeMatcher<_ScreenScaffoldState>())
            as _ScreenScaffoldState;

    return ScreenScaffold.menuController;
  }
}

typedef ScreenScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Screen {
  final String title;
  final DecorationImage decorationImage;
  final WidgetBuilder widgetBuilder;

  Screen({this.title, this.decorationImage, this.widgetBuilder});
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;

  MenuState state = MenuState.closed;

  MenuController({this.vsync})
      : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;

          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;

          case AnimationStatus.completed:
            state = MenuState.open;
            break;

          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 0 and 1
  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState { closed, opening, open, closing }
