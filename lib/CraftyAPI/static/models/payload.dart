// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'dart:convert';

CraftyResponse craftyResponseFromJson(String str) =>
    CraftyResponse.fromJson(json.decode(str));

String craftyResponseToJson(CraftyResponse data) => json.encode(data.toJson());

class CraftyResponse {
  final int status;
  final Data data;
  final Data errors;
  final Data messages;

  const CraftyResponse({
    this.status,
    this.data,
    this.errors,
    this.messages,
  });

  factory CraftyResponse.fromJson(Map<String, dynamic> json) => CraftyResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        errors: Data.fromJson(json["errors"]),
        messages: Data.fromJson(json["messages"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "errors": errors.toJson(),
        "messages": messages.toJson(),
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
