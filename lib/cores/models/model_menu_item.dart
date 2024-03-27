// To parse this JSON data, do
//
//     final menuItem = menuItemFromJson(jsonString);

import 'dart:convert';

MenuItem menuItemFromJson(String str) => MenuItem.fromJson(json.decode(str));

String menuItemToJson(MenuItem data) => json.encode(data.toJson());

class MenuItem {
  List<Menu> mainMenu;
  List<Menu> footerMenu;

  MenuItem({
    required this.mainMenu,
    required this.footerMenu,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    mainMenu:
    List<Menu>.from(json["mainmenu"].map((x) => Menu.fromJson(x))),
    footerMenu:
    List<Menu>.from(json["footermenu"].map((x) => Menu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mainmenu": List<dynamic>.from(mainMenu.map((x) => x.toJson())),
    "footermenu": List<dynamic>.from(mainMenu.map((x) => x.toJson())),
  };
}

class Menu {
  String menuId;
  String menuDisplayName;
  String link;
  String icon;

  Menu({
    required this.menuId,
    required this.menuDisplayName,
    required this.link,
    required this.icon,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    menuId: json["MenuId"],
    menuDisplayName: json["MenuDisplayName"],
    link: json["Link"],
    icon: json["Icon"],
  );

  Map<String, dynamic> toJson() => {
    "MenuId": menuId,
    "MenuDisplayName": menuDisplayName,
    "Link": link,
    "Icon": icon,
  };
}
