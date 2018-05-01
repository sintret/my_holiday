import 'package:flutter/material.dart';
import 'package:my_holiday/screen.dart';

final Screen planetScreen = new Screen(
  title: 'OUTER PLANETS',
  decorationImage: new DecorationImage(image: new AssetImage('images/blue_bg.jpg'),fit: BoxFit.cover),
  widgetBuilder: (BuildContext context){
    return new Container(
      child: new Column(
        children: [
          new Image.asset(
            'images/planet.jpg',
            fit: BoxFit.cover,
            height: 300.0,
            width: double.infinity,

          )
        ],
      ),
    );

  }
);