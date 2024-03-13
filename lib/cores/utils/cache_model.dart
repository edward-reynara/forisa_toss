import '../models/model_menu.dart';

class CacheModel {
  late MenuItem _menuItem;

  MenuItem get menuUtama => this._menuItem;

  set menuUtama(MenuItem menuItem) => this._menuItem = menuItem;
}