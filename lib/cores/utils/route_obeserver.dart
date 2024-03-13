import 'package:flutter/material.dart';

class RouteObserverService {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  String currentPage= '';

  void setCurrentPage(String currentPage){
    this.currentPage = currentPage;
  }
}