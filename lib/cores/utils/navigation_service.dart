import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(PageRoute pageRoute) {
    return navigatorKey.currentState!.push(pageRoute);
  }
}