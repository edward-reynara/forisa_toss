import '../models/model_menu.dart';

class CacheModel {
  late MenuItem _menuItem;

  MenuItem get menuUtama => _menuItem;

  set menuUtama(MenuItem menuItem) => _menuItem = menuItem;
}