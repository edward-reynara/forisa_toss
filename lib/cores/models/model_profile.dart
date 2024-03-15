// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  UserData userData;
  ProfileData profileData;
  String sisaCuti;
  List<InsuranceDatum> insuranceData;

  Profile({
    required this.userData,
    required this.profileData,
    required this.sisaCuti,
    required this.insuranceData,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        userData: UserData.fromJson(json["user_data"]),
        profileData: ProfileData.fromJson(json["profile_data"]),
        sisaCuti: json["sisa_cuti"],
        insuranceData: List<InsuranceDatum>.from(
            json["insurance_data"].map((x) => InsuranceDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_data": userData.toJson(),
        "profile_data": profileData.toJson(),
        "sisa_cuti": sisaCuti,
        "insurance_data":
            List<dynamic>.from(insuranceData.map((x) => x.toJson())),
      };
}

class InsuranceDatum {
  String insuranceCode;
  String insuranceCategory;
  String insuranceNo;
  String? insuranceVal1;
  String? insuranceVal2;
  String? insuranceVal3;
  String insuranceName;
  String? insuranceDesc;

  InsuranceDatum({
    required this.insuranceCode,
    required this.insuranceCategory,
    required this.insuranceNo,
    this.insuranceVal1,
    this.insuranceVal2,
    this.insuranceVal3,
    required this.insuranceName,
    this.insuranceDesc,
  });

  factory InsuranceDatum.fromJson(Map<String, dynamic> json) => InsuranceDatum(
        insuranceCode: json["InsuranceCode"],
        insuranceCategory: json["InsuranceCategory"],
        insuranceNo: json["InsuranceNo"],
        insuranceVal1: json["InsuranceVal1"],
        insuranceVal2: json["InsuranceVal2"],
        insuranceVal3: json["InsuranceVal3"],
        insuranceName: json["InsuranceName"],
        insuranceDesc:
            json["InsuranceDesc"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "InsuranceCode": insuranceCode,
        "InsuranceCategory": insuranceCategory,
        "InsuranceNo": insuranceNo,
        "InsuranceVal1": insuranceVal1,
        "InsuranceVal2": insuranceVal2,
        "InsuranceVal3": insuranceVal3,
        "InsuranceName": insuranceName,
        "InsuranceDesc": insuranceDesc ?? '',
      };
}

class ProfileData {
  String employeeNo;
  String employeeName;
  String email;
  String position;
  String empLevel;
  DateTime joinDate;

  ProfileData({
    required this.employeeNo,
    required this.employeeName,
    required this.email,
    required this.position,
    required this.empLevel,
    required this.joinDate,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        employeeNo: json["EmployeeNo"],
        employeeName: json["EmployeeName"],
        email: json["Email"],
        position: json["Position"],
        empLevel: json["EmpLevel"],
        joinDate: DateTime.parse(json["JoinDate"]),
      );

  Map<String, dynamic> toJson() => {
        "EmployeeNo": employeeNo,
        "EmployeeName": employeeName,
        "Email": email,
        "Position": position,
        "EmpLevel": empLevel,
        "JoinDate":
            "${joinDate.year.toString().padLeft(4, '0')}-${joinDate.month.toString().padLeft(2, '0')}-${joinDate.day.toString().padLeft(2, '0')}",
      };
}

class UserData {
  String loginId;
  String groupId;
  String userName;
  String displayName;
  String pwd;
  String sts;
  String modAct;
  String modBy;
  DateTime? modDate;

  UserData({
    required this.loginId,
    required this.groupId,
    required this.userName,
    required this.displayName,
    required this.pwd,
    required this.sts,
    required this.modAct,
    required this.modBy,
    this.modDate,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        loginId: json["LoginId"],
        groupId: json["GroupId"],
        userName: json["UserName"],
        displayName: json["DisplayName"],
        pwd: json["Pwd"],
        sts: json["Sts"],
        modAct: json["ModAct"],
        modBy: json["ModBy"],
        modDate:
            json["ModDate"] != null ? DateTime.parse(json["ModDate"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "LoginId": loginId,
        "GroupId": groupId,
        "UserName": userName,
        "DisplayName": displayName,
        "Pwd": pwd,
        "Sts": sts,
        "ModAct": modAct,
        "ModBy": modBy,
        "ModDate": modDate?.toIso8601String(),
      };
}
