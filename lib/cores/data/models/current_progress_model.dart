// To parse this JSON data, do
//
//     final currentProgressModel = currentProgressModelFromJson(jsonString);

import 'dart:convert';

CurrentProgressModel currentProgressModelFromJson(String str) => CurrentProgressModel.fromJson(json.decode(str));

String currentProgressModelToJson(CurrentProgressModel data) => json.encode(data.toJson());

class CurrentProgressModel {
    CurrentProgressModel({
        this.responseCode,
        this.responseMsg,
        this.data,
    });

    String? responseCode;
    String? responseMsg;
    List<Datum>? data;

    factory CurrentProgressModel.fromJson(Map<String, dynamic> json) => CurrentProgressModel(
        responseCode: json["response_code"] == null ? null : json["response_code"],
        responseMsg: json["response_msg"] == null ? null : json["response_msg"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "response_code": responseCode == null ? null : responseCode,
        "response_msg": responseMsg == null ? null : responseMsg,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.title,
        this.notifQty,
        this.link,
    });

    String? title;
    String? notifQty;
    String? link;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
