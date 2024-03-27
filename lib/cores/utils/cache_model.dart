import '../models/model_menu_item.dart';

class CacheModel {
  late MenuItem _menuItem;

  MenuItem get mainMenuCache => _menuItem;

  set mainMenuCache(MenuItem menuItem) => _menuItem = menuItem;
}
