// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.responseCode,
        this.responseMsg,
        this.data,
    });

    String? responseCode;
    String? responseMsg;
    Data? data;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        responseCode: json["response_code"],
        responseMsg: json["response_msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "response_msg": responseMsg,
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        this.username,
        this.token,
    });

    String? username;
    String? token;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        username: json["username"] == null ? null : json["username"],
        token: json["token"] == null ? null : json["token"],
    );

    Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "token": token == null ? null : token,
    };
}
