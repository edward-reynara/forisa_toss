// To parse this JSON data, do
//
//     final statusSummary = statusSummaryFromJson(jsonString);

import 'dart:convert';

StatusSummary statusSummaryFromJson(String str) =>
    StatusSummary.fromJson(json.decode(str));

String statusSummaryToJson(StatusSummary data) => json.encode(data.toJson());

class StatusSummary {
  Period? period;
  List<ArrResult>? arrResult;

  StatusSummary({
    this.period,
    this.arrResult,
  });

  factory StatusSummary.fromJson(Map<String, dynamic> json) => StatusSummary(
        period: json["Period"] == null ? null : Period.fromJson(json["Period"]),
        arrResult: json["arr_result"] == null
            ? null
            : List<ArrResult>.from(
                json["arr_result"].map((x) => ArrResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Period": period?.toJson(),
        "arr_result": arrResult == null
            ? null
            : List<dynamic>.from(arrResult!.map((x) => x.toJson())),
      };
}

class ArrResult {
  String? typeName;
  String? qty;

  ArrResult({
    this.typeName,
    this.qty,
  });

  factory ArrResult.fromJson(Map<String, dynamic> json) => ArrResult(
        typeName: json["TypeName"],
        qty: json["Qty"],
      );

  Map<String, dynamic> toJson() => {
        "TypeName": typeName,
        "Qty": qty,
      };
}

class Period {
  DateTime? startDate;
  DateTime? endDate;

  Period({
    this.startDate,
    this.endDate,
  });

  factory Period.fromJson(Map<String, dynamic> json) => Period(
        startDate: json["StartDate"] == null
            ? null
            : DateTime.parse(json["StartDate"]),
        endDate:
            json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
      );

  Map<String, dynamic> toJson() => {
        "StartDate": startDate == null
            ? null
            : "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "EndDate": endDate == null
            ? null
            : "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
      };
}
