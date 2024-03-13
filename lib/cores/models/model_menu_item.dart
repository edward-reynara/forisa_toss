// To parse this JSON data, do
//
//     final menuItem = menuItemFromJson(jsonString);

import 'dart:convert';

MenuItem menuItemFromJson(String str) => MenuItem.fromJson(json.decode(str));

String menuItemToJson(MenuItem data) => json.encode(data.toJson());

class MenuItem {
  List<Menu> mainmenu;
  List<Menu> footermenu;

  MenuItem({
    required this.mainmenu,
    required this.footermenu,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        mainmenu:
            List<Menu>.from(json["mainmenu"].map((x) => Menu.fromJson(x))),
        footermenu:
            List<Menu>.from(json["footermenu"].map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mainmenu": List<dynamic>.from(mainmenu.map((x) => x.toJson())),
        "footermenu": List<dynamic>.from(footermenu.map((x) => x.toJson())),
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
