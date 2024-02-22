// To parse this JSON data, do
//
//     final badgeNotifModel = badgeNotifModelFromJson(jsonString);

import 'dart:convert';

BadgeNotifModel badgeNotifModelFromJson(String str) => BadgeNotifModel.fromJson(json.decode(str));

String badgeNotifModelToJson(BadgeNotifModel data) => json.encode(data.toJson());

class BadgeNotifModel {
    BadgeNotifModel({
        this.responseCode,
        this.responseMsg,
        this.data,
    });

    String? responseCode;
    String? responseMsg;
    Data? data;

    factory BadgeNotifModel.fromJson(Map<String, dynamic> json) => BadgeNotifModel(
        responseCode: json["response_code"] == null ? null : json["response_code"],
        responseMsg: json["response_msg"] == null ? null : json["response_msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response_code": responseCode == null ? null : responseCode,
        "response_msg": responseMsg == null ? null : responseMsg,
        "data": data == null ? null : data!.toJson(),
    };
}

class Data {
    Data({
        this.title,
        this.notifQty,
        this.link,
    });

    String? title;
    String? notifQty;
    String? link;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["Title"] == null ? null : json["Title"],
        notifQty: json["NotifQty"] == null ? null : json["NotifQty"],
        link: json["Link"] == null ? null : json["Link"],
    );

    Map<String, dynamic> toJson() => {
        "Title": title == null ? null : title,
        "NotifQty": notifQty == null ? null : notifQty,
        "Link": link == null ? null : link,
    };
}
