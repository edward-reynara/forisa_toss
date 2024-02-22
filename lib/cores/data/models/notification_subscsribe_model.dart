// To parse this JSON data, do
//
//     final notificationSubscribeModel = notificationSubscribeModelFromJson(jsonString);

import 'dart:convert';

NotificationSubscribeModel notificationSubscribeModelFromJson(String str) => NotificationSubscribeModel.fromJson(json.decode(str));

String notificationSubscribeModelToJson(NotificationSubscribeModel data) => json.encode(data.toJson());

class NotificationSubscribeModel {
    NotificationSubscribeModel({
        this.responseCode,
        this.responseMsg,
        this.data,
    });

    String? responseCode;
    String? responseMsg;
    Data? data;

    factory NotificationSubscribeModel.fromJson(Map<String, dynamic> json) => NotificationSubscribeModel(
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
        this.loginId,
        this.deviceId,
        this.deviceType,
        this.extDeviceId,
        this.registerDate,
        this.isDefault,
        this.isSubscribed,
        this.extInfo1,
        this.extInfo2,
        this.extInfo3,
        this.extInfo4,
        this.extInfo5,
    });

    String? loginId;
    String? deviceId;
    String? deviceType;
    String? extDeviceId;
    DateTime? registerDate;
    String? isDefault;
    String? isSubscribed;
    String? extInfo1;
    String? extInfo2;
    String? extInfo3;
    String? extInfo4;
    String? extInfo5;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        loginId: json["LoginId"] == null ? null : json["LoginId"] is int ? json["LoginId"].toString(): json["LoginId"],
        deviceId: json["DeviceId"] == null ? null : json["DeviceId"],
        deviceType: json["DeviceType"] == null ? null : json["DeviceType"],
        extDeviceId: json["ExtDeviceId"] == null ? null : json["ExtDeviceId"],
        registerDate: json["RegisterDate"] == null ? null : DateTime.parse(json["RegisterDate"]),
        isDefault: json["IsDefault"] == null ? null : json["IsDefault"] is int ? json["IsDefault"].toString(): json["IsDefault"],
        isSubscribed: json["IsSubscribed"] == null ? null : json["IsSubscribed"] is int ? json["IsSubscribed"].toString(): json["IsSubscribed"],
        extInfo1: json["ExtInfo1"] == null ? null : json["ExtInfo1"],
        extInfo2: json["ExtInfo2"] == null ? null : json["ExtInfo2"],
        extInfo3: json["ExtInfo3"] == null ? null : json["ExtInfo3"],
        extInfo4: json["ExtInfo4"] == null ? null : json["ExtInfo4"],
        extInfo5: json["ExtInfo5"] == null ? null : json["ExtInfo5"],
    );

    Map<String, dynamic> toJson() => {
        "LoginId": loginId == null ? null : loginId,
        "DeviceId": deviceId == null ? null : deviceId,
        "DeviceType": deviceType == null ? null : deviceType,
        "ExtDeviceId": extDeviceId == null ? null : extDeviceId,
        "RegisterDate": registerDate == null ? null : "${registerDate!.year.toString().padLeft(4, '0')}-${registerDate!.month.toString().padLeft(2, '0')}-${registerDate!.day.toString().padLeft(2, '0')}",
        "IsDefault": isDefault == null ? null : isDefault,
        "IsSubscribed": isSubscribed == null ? null : isSubscribed,
        "ExtInfo1": extInfo1 == null ? null : extInfo1,
        "ExtInfo2": extInfo2 == null ? null : extInfo2,
        "ExtInfo3": extInfo3 == null ? null : extInfo3,
        "ExtInfo4": extInfo4 == null ? null : extInfo4,
        "ExtInfo5": extInfo5 == null ? null : extInfo5,
    };
}
