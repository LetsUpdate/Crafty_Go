// To parse this JSON data, do
//
//     final serverList = serverListFromJson(jsonString);

import 'dart:convert';

ServerList serverListFromJson(String str) =>
    ServerList.fromJson(json.decode(str));

String serverListToJson(ServerList data) => json.encode(data.toJson());

class ServerList {
  final int status;
  final Data data;
  final Errors errors;
  final Errors messages;

  ServerList({
    this.status,
    this.data,
    this.errors,
    this.messages,
  });

  factory ServerList.fromJson(Map<String, dynamic> json) => ServerList(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        errors: Errors.fromJson(json["errors"]),
        messages: Errors.fromJson(json["messages"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "errors": errors.toJson(),
        "messages": messages.toJson(),
      };
}

class Data {
  final String code;
  final List<Server> servers;

  Data({
    this.code,
    this.servers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        code: json["code"],
        servers:
            List<Server>.from(json["servers"].map((x) => Server.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "servers": List<dynamic>.from(servers.map((x) => x.toJson())),
      };
}

class Server {
  final int id;
  final String name;
  final bool running;
  final bool crashed;
  final bool autoStart;

  Server({
    this.id,
    this.name,
    this.running,
    this.crashed,
    this.autoStart,
  });

  factory Server.fromJson(Map<String, dynamic> json) => Server(
        id: json["id"],
        name: json["name"],
        running: json["running"],
        crashed: json["crashed"],
        autoStart: json["auto_start"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "running": running,
        "crashed": crashed,
        "auto_start": autoStart,
      };
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<String, dynamic> json) => Errors();

  Map<String, dynamic> toJson() => {};
}
