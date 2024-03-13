// To parse this JSON data, do
//
//     final defaultModel = defaultModelFromJson(jsonString);

import 'dart:convert';

DefaultModel defaultModelFromJson(String str) =>
    DefaultModel.fromJson(json.decode(str));

String defaultModelToJson(DefaultModel data) => json.encode(data.toJson());

class DefaultModel {
  int status;
  String msg;

  DefaultModel({
    required this.status,
    required this.msg,
  });

  factory DefaultModel.fromJson(Map<String, dynamic> json) => DefaultModel(
        status: json["status"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
      };
}
