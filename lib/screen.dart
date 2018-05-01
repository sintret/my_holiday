import 'package:flutter/material.dart';

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