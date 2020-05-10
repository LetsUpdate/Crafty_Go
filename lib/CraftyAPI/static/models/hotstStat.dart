// To parse this JSON data, do
//
//     final hostStat = hostStatFromJson(jsonString);

import 'dart:convert';

HostStat hostStatFromJson(String str) => HostStat.fromJson(json.decode(str));

String hostStatToJson(HostStat data) => json.encode(data.toJson());
class HostStat {
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

  HostStat({
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

  factory HostStat.fromJson(Map<String, dynamic> json) => HostStat(
    id: json["id"],
    bootTime: DateTime.parse(json["boot_time"]),
    cpuUsage: json["cpu_usage"].toDouble(),
    cpuCores: json["cpu_cores"],
    cpuCurFreq: json["cpu_cur_freq"].toDouble(),
    cpuMaxFreq: json["cpu_max_freq"],
    memPercent: json["mem_percent"],
    memUsage: json["mem_usage"],
    memTotal: json["mem_total"],
    diskPercent: json["disk_percent"].toDouble(),
    diskUsage: json["disk_usage"],
    diskTotal: json["disk_total"],
  );

  Map<String, dynamic> toJson() => {
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
