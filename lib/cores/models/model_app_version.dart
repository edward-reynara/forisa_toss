// To parse this JSON data, do
//
//     final appVersion = appVersionFromJson(jsonString);

import 'dart:convert';

AppVersion appVersionFromJson(String str) =>
    AppVersion.fromJson(json.decode(str));

String appVersionToJson(AppVersion data) => json.encode(data.toJson());

class AppVersion {
  int minVersion;
  int version;
  String appUrl;

  AppVersion({
    required this.minVersion,
    required this.version,
    required this.appUrl,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
        minVersion: json["min_version"],
        version: json["version"],
        appUrl: json["app_url"],
      );

  Map<String, dynamic> toJson() => {
        "min_version": minVersion,
        "version": version,
        "app_url": appUrl,
      };
}
