// To parse this JSON data, do
//
//     final serverStat = serverStatFromJson(jsonString);

import 'dart:convert';

ServerStat serverStatFromJson(String str) =>
    ServerStat.fromJson(json.decode(str));

String serverStatToJson(ServerStat data) => json.encode(data.toJson());

class ServerStat {
  final int status;
  final List<Stat> serverStat;
  final Errors errors;
  final Errors messages;

  ServerStat({
    this.status,
    this.serverStat,
    this.errors,
    this.messages,
  });

  factory ServerStat.fromJson(Map<String, dynamic> json) =>
      ServerStat(
        status: json["status"],
        serverStat: List<Stat>.from(json["data"].map((x) => Stat.fromJson(x))),
        errors: Errors.fromJson(json["errors"]),
        messages: Errors.fromJson(json["messages"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(serverStat.map((x) => x.toJson())),
    "errors": errors.toJson(),
    "messages": messages.toJson(),
  };
}

class Stat {
  final int id;
  final int serverId;
  final String serverStartTime;
  final double cpuUsage;
  final String memoryUsage;
  final int maxPlayers;
  final int onlinePlayers;
  final String players;
  final String motd;
  final bool serverRunning;
  final String serverVersion;
  final String worldName;
  final String worldSize;
  final String serverIp;
  final int serverPort;
  final String name;

  Stat({
    this.id,
    this.serverId,
    this.serverStartTime,
    this.cpuUsage,
    this.memoryUsage,
    this.maxPlayers,
    this.onlinePlayers,
    this.players,
    this.motd,
    this.serverRunning,
    this.serverVersion,
    this.worldName,
    this.worldSize,
    this.serverIp,
    this.serverPort,
    this.name,
  });

  factory Stat.fromJson(Map<String, dynamic> json) =>
      Stat(
        id: json["id"],
        serverId: json["server_id"],
        serverStartTime: json["server_start_time"],
        cpuUsage: json["cpu_usage"].toDouble(),
        memoryUsage: json["memory_usage"],
        maxPlayers: json["max_players"],
        onlinePlayers: json["online_players"],
        players: json["players"],
        motd: json["motd"],
        serverRunning: json["server_running"],
        serverVersion: json["server_version"],
        worldName: json["world_name"],
        worldSize: json["world_size"],
        serverIp: json["server_ip"],
        serverPort: json["server_port"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "server_id": serverId,
    "server_start_time": serverStartTime,
    "cpu_usage": cpuUsage,
    "memory_usage": memoryUsage,
    "max_players": maxPlayers,
    "online_players": onlinePlayers,
    "players": players,
    "motd": motd,
    "server_running": serverRunning,
    "server_version": serverVersion,
    "world_name": worldName,
    "world_size": worldSize,
    "server_ip": serverIp,
    "server_port": serverPort,
    "name": name,
  };
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<String, dynamic> json) =>
      Errors(
      );

  Map<String, dynamic> toJson() =>
      {
      };
}

// To parse this JSON data, do
//
//     final hostStat = hostStatFromJson(jsonString);


HostStat hostStatFromJson(String str) => HostStat.fromJson(json.decode(str));

String hostStatToJson(HostStat data) => json.encode(data.toJson());

class HostStat {
  final int status;
  final HostStatData data;
  final Errors errors;
  final Errors messages;

  HostStat({
    this.status,
    this.data,
    this.errors,
    this.messages,
  });

  factory HostStat.fromJson(Map<String, dynamic> json) =>
      HostStat(
        status: json["status"],
        data: HostStatData.fromJson(json["data"]),
        errors: Errors.fromJson(json["errors"]),
        messages: Errors.fromJson(json["messages"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "status": status,
        "data": data.toJson(),
        "errors": errors.toJson(),
        "messages": messages.toJson(),
      };
}

class HostStatData {
  final int id;
  final DateTime bootTime;
  final double cpuUsage;
  final int cpuCores;
  final double cpuCurFreq;
  final double cpuMaxFreq;
  final double memPercent;
  final String memUsage;
  final String memTotal;
  final double diskPercent;
  final String diskUsage;
  final String diskTotal;

  HostStatData({
    this.id,
    this.bootTime,
    this.cpuUsage,
    this.cpuCores,
    this.cpuCurFreq,
    this.cpuMaxFreq,
    this.memPercent,
    this.memUsage,
    this.memTotal,
    this.diskPercent,
    this.diskUsage,
    this.diskTotal,
  });

  factory HostStatData.fromJson(Map<String, dynamic> json) =>
      HostStatData(
        id: json["id"],
        bootTime: DateTime.parse(json["boot_time"]),
        cpuUsage: json["cpu_usage"].toDouble(),
        cpuCores: json["cpu_cores"],
        cpuCurFreq: json["cpu_cur_freq"].toDouble(),
        cpuMaxFreq: json["cpu_max_freq"],
        memPercent: json["mem_percent"].toDouble(),
        memUsage: json["mem_usage"],
        memTotal: json["mem_total"],
        diskPercent: json["disk_percent"].toDouble(),
        diskUsage: json["disk_usage"],
        diskTotal: json["disk_total"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "boot_time": bootTime.toIso8601String(),
        "cpu_usage": cpuUsage,
        "cpu_cores": cpuCores,
        "cpu_cur_freq": cpuCurFreq,
        "cpu_max_freq": cpuMaxFreq,
        "mem_percent": memPercent,
        "mem_usage": memUsage,
        "mem_total": memTotal,
        "disk_percent": diskPercent,
        "disk_usage": diskUsage,
        "disk_total": diskTotal,
      };
}


