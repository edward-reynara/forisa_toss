import 'package:flutter/material.dart';

class CounterInfo {
  String title;
  String qty;
  Color? fromColor = Colors.white;
  Color? toColor = Colors.white;
  Function()? onClick;

  CounterInfo({
    required this.title,
    required this.qty,
    this.fromColor,
    this.toColor,
    this.onClick,
  });
}
