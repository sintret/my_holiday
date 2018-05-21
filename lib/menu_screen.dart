import 'package:my_holiday/screen.dart';
import 'package:flutter/material.dart';

final menuScreenKey = new GlobalKey(debugLabel: 'menuScreen');

class MenuScreen extends StatefulWidget {

  final Menu menu;
  var selectedItemId;
  final Function(String) onMenuItemSelected;

  MenuScreen({
    this.menu,
    this.selectedItemId,
    this.onMenuItemSelected,
  }) : super(key:menuScreenKey);

  @override
  _MenuScreenState createState() => new _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {

  AnimationController titleAnimationController;
  RenderBox _selectedRenderBox;
  double selectorYTop = 250.0;
  double selectorYBottom = 300.0;

  setSelectedRenderBox(RenderBox newRenderBox) async {
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0,0.0)).dy;
    final newYBottom = newYTop + newRenderBox.size.height;

    if(newYTop != selectorYTop){
      setState(() {
        //_selectedRenderBox = newRenderBox;
        selectorYTop = newYTop;
        selectorYBottom = newYBottom;
      });
    }
  }

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

    print('selected render box y position is ${selectorYTop}');


    return new ScreenScaffoldMenuController(
        builder: (BuildContext context, MenuController menuController) {

          var shouldRenderSelector = true;
          var actualSelectorYTop = selectorYTop;
          var actualSelectorYBottom = selectorYBottom;
          var selectorOpacity = 1.0;

          if(menuController.state == MenuState.closed || menuController.state == MenuState.closing || selectorYTop ==null){
            final RenderBox menuScreenRenderBox = context.findRenderObject() as RenderBox;

            if(menuScreenRenderBox != null){
              final menuScreenHeight = menuScreenRenderBox.size.height;
              actualSelectorYTop = menuScreenHeight -50.0;
              actualSelectorYBottom = menuScreenHeight;
              selectorOpacity = 0.0;
            } else {
              shouldRenderSelector = false;
            }

          }
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
              createMenuItems(menuController),
              shouldRenderSelector ?
              new ItemSelector(
                topY: actualSelectorYTop,
                bottomY: actualSelectorYBottom,
                opacity: selectorOpacity,
              ) : new Container()
            ],
          ),
        ),
      );
    });
  }

  createMenuItems(MenuController menuController) {

    //final titles = ['HOME', 'PLANETS', 'PROFILE', 'SETTINGS','LOGOUT'];
    //final selectedIndex = 0;
    final List<Widget> listItems = [];
    final animationIntervalDuration = 0.5;
    final perListItemDelay = menuController.state != MenuState.closing ? 0.125 : 0.0;

    for (var i = 0; i < widget.menu.items.length; i++) {
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd = animationIntervalStart + animationIntervalDuration;
      final isSelected = widget.selectedItemId == widget.menu.items[i].id ? true : false;

      listItems.add(new AnimatedMenuListItem(
        menuState: menuController.state,
        isSelected: isSelected,
        duration: const Duration(milliseconds: 600),
        curve: new Interval(animationIntervalStart, animationIntervalEnd, curve: Curves.easeOut),
        menuListItems: new _MenuListItems(
            title: widget.menu.items[i].title,
            isSelected: isSelected,
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


class ItemSelector extends ImplicitlyAnimatedWidget {

  final double topY;
  final double bottomY;
  final double opacity;

  ItemSelector({
    this.topY,
    this.bottomY,
    this.opacity,
  }) : super(duration: const Duration(milliseconds: 250));


  @override
  _ItemSelectorState createState() => new _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {

  Tween<double> _topY;
  Tween<double> _bottomY;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {

    _topY = visitor(
      _topY,
      widget.topY,
    (dynamic value) => new Tween<double>(begin: value)
    );

    _bottomY = visitor(
        _bottomY,
        widget.bottomY,
            (dynamic value) => new Tween<double>(begin: value)
    );

    _opacity = visitor(
        _opacity,
        widget.opacity,
            (dynamic value) => new Tween<double>(begin: value)
    );

  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: _topY.evaluate(animation),
      child: new Opacity(
        opacity: _opacity.evaluate(animation),
        child: new Container(
          width: 5.0,
          height: 50.4,
          color: Colors.red,
        ),
      ),
    );
  }

}


class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItems menuListItems;
  final MenuState menuState;
  final Duration duration;
  final isSelected;

  AnimatedMenuListItem({
    this.menuListItems,
    this.menuState,
    this.isSelected,
    this.duration,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => new _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState extends AnimatedWidgetBaseState<AnimatedMenuListItem> {

  final double closedSlidePosition = 250.0;
  final double openSlidePosition = 0.0;

  Tween<double> _transalation;
  Tween<double> _opacity;

  updateSelectedRenderBox(){
    final renderBox = context.findRenderObject() as RenderBox;
    if(renderBox != null && widget.isSelected){
      print('My Render Box size id ${renderBox.localToGlobal(const Offset(0.0,0.0))}');
      (menuScreenKey.currentState as _MenuScreenState).setSelectedRenderBox(renderBox);
    }
  }

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

    updateSelectedRenderBox();

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
