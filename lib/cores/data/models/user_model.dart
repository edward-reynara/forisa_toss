// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.loginId,
    this.groupId,
    this.groupName,
    this.userName,
    this.displayName,
    this.pwd,
    this.salt,
    this.email,
    this.verifyToken,
    this.verifyTokenExpired,
    this.openId,
    this.totalArea,
    this.areaCode,
    this.areaName,
    this.employeeNo,
    this.employeeName,
    this.position,
    this.resellerId,
    this.resellerName,
    this.gradeCode,
  });

  String? loginId;
  String? groupId;
  String? groupName;
  String? userName;
  String? displayName;
  String? pwd;
  String? salt;
  String? email;
  String? verifyToken;
  String? verifyTokenExpired;
  String? openId;
  int? totalArea;
  String? areaCode;
  String? areaName;
  String? employeeNo;
  String? employeeName;
  String? position;
  String? resellerId;
  String? resellerName;
  String? gradeCode;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        loginId: json["LoginId"] == null ? null : json["LoginId"],
        groupId: json["GroupId"] == null ? null : json["GroupId"],
        groupName: json["GroupName"] == null ? null : json["GroupName"],
        userName: json["UserName"] == null ? null : json["UserName"],
        displayName: json["DisplayName"] == null ? null : json["DisplayName"],
        pwd: json["Pwd"] == null ? null : json["Pwd"],
        salt: json["Salt"] == null ? null : json["Salt"],
        email: json["Email"] == null ? null : json["Email"],
        verifyToken: json["VerifyToken"] == null ? null : json["VerifyToken"],
        verifyTokenExpired: json["VerifyTokenExpired"] == null
            ? null
            : json["VerifyTokenExpired"],
        openId: json["OpenId"] == null ? null : json["OpenId"],
        totalArea: json["TotalArea"] == null ? null : json["TotalArea"],
        areaCode: json["AreaCode"] == null ? null : json["AreaCode"],
        areaName: json["AreaName"] == null ? null : json["AreaName"],
        employeeNo: json["EmployeeNo"] == null ? null : json["EmployeeNo"],
        employeeName:
            json["EmployeeName"] == null ? null : json["EmployeeName"],
        position: json["Position"] == null ? null : json["Position"],
        resellerId: json["ResellerId"] == null ? null : json["ResellerId"],
        resellerName:
            json["ResellerName"] == null ? null : json["ResellerName"],
        gradeCode: json["GradeCode"] == null ? null : json["GradeCode"],
      );

  Map<String, dynamic> toJson() => {
        "LoginId": loginId == null ? null : loginId,
        "GroupId": groupId == null ? null : groupId,
        "GroupName": groupName == null ? null : groupName,
        "UserName": userName == null ? null : userName,
        "DisplayName": displayName == null ? null : displayName,
        "Pwd": pwd == null ? null : pwd,
        "Salt": salt == null ? null : salt,
        "Email": email == null ? null : email,
        "VerifyToken": verifyToken == null ? null : verifyToken,
        "VerifyTokenExpired":
            verifyTokenExpired == null ? null : verifyTokenExpired,
        "OpenId": openId == null ? null : openId,
        "TotalArea": totalArea == null ? null : totalArea,
        "AreaCode": areaCode == null ? null : areaCode,
        "AreaName": areaName == null ? null : areaName,
        "EmployeeNo": employeeNo == null ? null : employeeNo,
        "EmployeeName": employeeName == null ? null : employeeName,
        "Position": position == null ? null : position,
        "ResellerId": resellerId == null ? null : resellerId,
        "ResellerName": resellerName == null ? null : resellerName,
        "GradeCode": gradeCode == null ? null : gradeCode,
      };
}
