// To parse this JSON data, do
//
//     final homeMenuModel = homeMenuModelFromJson(jsonString);

import 'dart:convert';

HomeMenuModel homeMenuModelFromJson(String str) => HomeMenuModel.fromJson(json.decode(str));

String homeMenuModelToJson(HomeMenuModel data) => json.encode(data.toJson());

class HomeMenuModel {
    HomeMenuModel({
        this.responseCode,
        this.responseMsg,
        this.data,
    });

    String? responseCode;
    String? responseMsg;
    Data? data;

    factory HomeMenuModel.fromJson(Map<String, dynamic> json) => HomeMenuModel(
        responseCode: json["response_code"] == null ? null : json["response_code"],
        responseMsg: json["response_msg"] == null ? null : json["response_msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response_code": responseCode == null ? null : responseCode,
        "response_msg": responseMsg == null ? null : responseMsg,
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        this.arrdata,
    });

    List<Arrdatum>? arrdata;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        arrdata: json["arrdata"] == null ? null : List<Arrdatum>.from(json["arrdata"].map((x) => Arrdatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "arrdata": arrdata == null ? null : List<dynamic>.from(arrdata!.map((x) => x.toJson())),
    };
}

class Arrdatum {
    Arrdatum({
        this.groupId,
        this.appCode,
        this.menuId,
        this.menuLvl,
        this.parentId,
        this.menuName,
        this.menuDisplayName,
        this.link,
        this.menuOrder,
        this.parentMenuName,
        this.parentMenuDisplayName,
        this.isHasChild,
        this.isShowChild,
        this.icon,
        this.position,
        this.menuRender,
    });

    String? groupId;
    String? appCode;
    String? menuId;
    String? menuLvl;
    String? parentId;
    String? menuName;
    String? menuDisplayName;
    String? link;
    String? menuOrder;
    String? parentMenuName;
    String? parentMenuDisplayName;
    String? isHasChild;
    String? isShowChild;
    String? icon;
    String? position;
    String? menuRender;

    factory Arrdatum.fromJson(Map<String, dynamic> json) => Arrdatum(
        groupId: json["GroupId"] == null ? null : json["GroupId"],
        appCode: json["AppCode"] == null ? null : json["AppCode"],
        menuId: json["MenuId"] == null ? null : json["MenuId"],
        menuLvl: json["MenuLvl"] == null ? null : json["MenuLvl"],
        parentId: json["ParentId"] == null ? null : json["ParentId"],
        menuName: json["MenuName"] == null ? null : json["MenuName"],
        menuDisplayName: json["MenuDisplayName"] == null ? null : json["MenuDisplayName"],
        link: json["Link"] == null ? null : json["Link"],
        menuOrder: json["MenuOrder"] == null ? null : json["MenuOrder"],
        parentMenuName: json["ParentMenuName"] == null ? null : json["ParentMenuName"],
        parentMenuDisplayName: json["ParentMenuDisplayName"] == null ? null : json["ParentMenuDisplayName"],
        isHasChild: json["IsHasChild"] == null ? null : json["IsHasChild"],
        isShowChild: json["IsShowChild"] == null ? null : json["IsShowChild"],
        icon: json["Icon"] == null ? null : json["Icon"],
        position: json["Position"] == null ? null : json["Position"],
        menuRender: json["MenuRender"] == null ? null : json["MenuRender"],
    );

    Map<String, dynamic> toJson() => {
        "GroupId": groupId == null ? null : groupId,
        "AppCode": appCode == null ? null : appCode,
        "MenuId": menuId == null ? null : menuId,
        "MenuLvl": menuLvl == null ? null : menuLvl,
        "ParentId": parentId == null ? null : parentId,
        "MenuName": menuName == null ? null : menuName,
        "MenuDisplayName": menuDisplayName == null ? null : menuDisplayName,
        "Link": link == null ? null : link,
        "MenuOrder": menuOrder == null ? null : menuOrder,
        "ParentMenuName": parentMenuName == null ? null : parentMenuName,
        "ParentMenuDisplayName": parentMenuDisplayName == null ? null : parentMenuDisplayName,
        "IsHasChild": isHasChild == null ? null : isHasChild,
        "IsShowChild": isShowChild == null ? null : isShowChild,
        "Icon": icon == null ? null : icon,
        "Position": position == null ? null : position,
        "MenuRender": menuRender == null ? null : menuRender,
    };
}