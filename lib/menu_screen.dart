import 'package:my_holiday/screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {

  final Menu menu;
  final Function(String) onMenuItemSelected;

  MenuScreen({
    this.menu,
    this.onMenuItemSelected,
  });

  @override
  _MenuScreen createState() => new _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> with TickerProviderStateMixin {

  AnimationController titleAnimationController;

  @override
  void initState() {
    super.initState();
    titleAnimationController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new ScreenScaffoldMenuController(
        builder: (BuildContext context, MenuController menuController) {
      return new Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage('images/black_bc.jpg'),
                fit: BoxFit.cover)),
        child: new Material(
          color: Colors.transparent,
          child: new Stack(
            children: [
              createMenuTitle(menuController),
              createMenuItems(menuController)
            ],
          ),
        ),
      );
    });
  }

  createMenuItems(MenuController menuController) {

    //final titles = ['HOME', 'PLANETS', 'PROFILE', 'SETTINGS','LOGOUT'];
    final selectedIndex = 0;
    final List<Widget> listItems = [];
    final animationIntervalDuration = 0.5;
    final perListItemDelay = menuController.state != MenuState.closing ? 0.125 : 0.0;

    for (var i = 0; i < widget.menu.items.length; i++) {
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd = animationIntervalStart + animationIntervalDuration;

      listItems.add(new AnimatedMenuListItem(
        menuState: menuController.state,
        duration: const Duration(milliseconds: 600),
        curve: new Interval(animationIntervalStart, animationIntervalEnd, curve: Curves.easeOut),
        menuListItems: new _MenuListItems(
            title: widget.menu.items[i].title,
            isSelected: selectedIndex == i ? true : false,
            onTap: () {
              widget.onMenuItemSelected(widget.menu.items[i].id);
              menuController.close();
            }),
      ));
    }

    return new Transform(
      transform: new Matrix4.translationValues(0.0, 225.0, 0.0),
      child: Column(children: listItems),
    );
  }

  createMenuTitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closing:
      case MenuState.closed:
        titleAnimationController.reverse();
        break;
    }

    return new AnimatedBuilder(
        animation: titleAnimationController,
        child: new OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.topLeft,
          child: new Padding(
            padding: const EdgeInsets.all(30.0),
            child: new Text(
              'Menu',
              style: new TextStyle(
                  fontSize: 230.0, color: const Color(0x88444444)),
              softWrap: false,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return new Transform(
              transform: new Matrix4.translationValues(
                  250.0 * (1.0 - titleAnimationController.value) - 100.0,
                  0.0,
                  0.0),
              child: child);
        });
  }
}

class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItems menuListItems;
  final MenuState menuState;
  final Duration duration;

  AnimatedMenuListItem({
    this.menuListItems,
    this.menuState,
    this.duration,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => new _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 250.0;
  final double openSlidePosition = 0.0;

  Tween<double> _transalation;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.closing:
      case MenuState.closed:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;

      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }

    _transalation = visitor(_transalation, slide,
        (dynamic value) => new Tween<double>(begin: value));

    _opacity = visitor(
        _opacity, opacity, (dynamic value) => new Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    return new Opacity(
      opacity: _opacity.evaluate(animation),
      child: new Transform(
        transform: new Matrix4.translationValues(
            0.0, _transalation.evaluate(animation), 0.0),
        child: widget.menuListItems,
      ),
    );
  }
}

class _MenuListItems extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;

  _MenuListItems({this.title, this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : onTap,
      child: new Container(
        width: double.infinity,
        child: new Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: new Text(
            title,
            style: new TextStyle(
                fontSize: 25.0,
                letterSpacing: 2.0,
                color: isSelected ? Colors.red : Colors.white),
          ),
        ),
      ),
    );
  }
}


class Menu {
  final List<MenuItem> items;

  Menu({
    this.items
  });
}

class MenuItem{
  final String id;
  final String title;

  MenuItem({
    this.id,
    this.title
  });

}
