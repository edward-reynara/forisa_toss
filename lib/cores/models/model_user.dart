// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String loginId;
  String groupId;
  String userName;
  String displayName;
  String pwd;
  // String sts;
  // String modAct;
  // String modBy;
  // DateTime modDate;

  User({
    required this.loginId,
    required this.groupId,
    required this.userName,
    required this.displayName,
    required this.pwd,
    // this.sts,
    // this.modAct,
    // this.modBy,
    // this.modDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        loginId: json["LoginId"],
        groupId: json["GroupId"],
        userName: json["UserName"],
        displayName: json["DisplayName"],
        pwd: json["Pwd"],
        // sts: json["Sts"],
        // modAct: json["ModAct"],
        // modBy: json["ModBy"],
        // modDate: DateTime.parse(json["ModDate"]),
      );

  Map<String, dynamic> toJson() => {
        "LoginId": loginId,
        "GroupId": groupId,
        "UserName": userName,
        "DisplayName": displayName,
        "Pwd": pwd,
        // "Sts": sts,
        // "ModAct": modAct,
        // "ModBy": modBy,
        // "ModDate": modDate.toIso8601String(),
      };
}
