// To parse this JSON data, do
//
//     final logLine = logLineFromJson(jsonString);

import 'dart:convert';

List<LogLine> logLineFromJson(String str) => List<LogLine>.from(json.decode(str).map((x) => LogLine.fromJson(x)));

String logLineToJson(List<LogLine> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LogLine {
  final int lineNum;
  final String message;

  LogLine({
    this.lineNum,
    this.message,
  });

  factory LogLine.fromJson(Map<String, dynamic> json) => LogLine(
    lineNum: json["line_num"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "line_num": lineNum,
    "message": message,
  };
}