// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'dart:convert';

CraftyResponse craftyResponseFromJson(String str) =>
    CraftyResponse.fromJson(json.decode(str));

String craftyResponseToJson(CraftyResponse data) => json.encode(data.toJson());

class CraftyResponse {
  final int status;
  final String data;
  final String errors;
  final String messages;

  const CraftyResponse({
    this.status,
    this.data,
    this.errors,
    this.messages,
  });

  factory CraftyResponse.fromJson(Map<String, dynamic> json) => CraftyResponse(
        status: json["status"],
    data: json["data"],
    errors: json["errors"],
    messages: json["messages"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
    "data": data,
    "errors": errors,
    "messages": messages,
      };
}

