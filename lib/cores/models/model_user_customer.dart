// To parse this JSON data, do
//
//     final userCustomer = userCustomerFromJson(jsonString);

import 'dart:convert';

UserCustomer userCustomerFromJson(String str) => UserCustomer.fromJson(json.decode(str));

String userCustomerToJson(UserCustomer data) => json.encode(data.toJson());

class UserCustomer {
    List<DataMapping>? dataMapping;

    UserCustomer({
        this.dataMapping,
    });

    factory UserCustomer.fromJson(Map<String, dynamic> json) => UserCustomer(
        dataMapping: json["data_mapping"] == null ? null : List<DataMapping>.from(json["data_mapping"].map((x) => DataMapping.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data_mapping": dataMapping == null ? null : List<dynamic>.from(dataMapping!.map((x) => x.toJson())),
    };
}

class DataMapping {
    String? custNo;
    String? custName;
    String? city;
    String? chooseFlag;
    String? employeeName;

    DataMapping({
        this.custNo,
        this.custName,
        this.city,
        this.chooseFlag,
        this.employeeName,
    });

    factory DataMapping.fromJson(Map<String, dynamic> json) => DataMapping(
        custNo: json["CustNo"],
        custName: json["CustName"],
        city: json["City"],
        chooseFlag: json["ChooseFlag"],
        employeeName: json["EmployeeName"],
    );

    Map<String, dynamic> toJson() => {
        "CustNo": custNo,
        "CustName": custName,
        "City": city,
        "ChooseFlag": chooseFlag,
        "EmployeeName": employeeName,
    };
}
