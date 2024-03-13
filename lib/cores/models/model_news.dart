// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
  String msgId;
  String msgType;
  DateTime msgDate;
  String msgSubject;
  String msgDetail;
  String photoUrl;
  String msgPhoto;
  String attachment;
  String isRead;

  News({
    required this.msgId,
    required this.msgType,
    required this.msgDate,
    required this.msgSubject,
    required this.msgDetail,
    required this.photoUrl,
    required this.msgPhoto,
    required this.attachment,
    required this.isRead,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        msgId: json["MsgId"],
        msgType: json["MsgType"],
        msgDate: DateTime.parse(json["MsgDate"]),
        msgSubject: json["MsgSubject"],
        msgDetail: json["MsgDetail"],
        photoUrl: json["PhotoUrl"],
        msgPhoto: json["MsgPhoto"],
        attachment: json["Attachment"],
        isRead: json["IsRead"],
      );

  Map<String, dynamic> toJson() => {
        "MsgId": msgId,
        "MsgType": msgType,
        "MsgDate": msgDate.toIso8601String(),
        "MsgSubject": msgSubject,
        "MsgDetail": msgDetail,
        "PhotoUrl": photoUrl,
        "MsgPhoto": msgPhoto,
        "Attachment": attachment,
        "IsRead": isRead,
      };
}
