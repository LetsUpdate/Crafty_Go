import 'dart:developer';

import 'package:craftycommander/CraftyAPI/craftyAPI.dart';
import 'package:craftycommander/CraftyAPI/static/models/hotstStat.dart';
import 'package:craftycommander/CraftyAPI/static/models/serverStat.dart';

class User {
  CraftyClient client;
  List<ServerStat> serverStats;
  HostStat hostStats;

  User(String apiKey, String url) {
    client = new CraftyClient(apiKey, url);
    updateHostStats();
    updateServerStats();
  }

  Future<bool> updateServerStats() async {
    serverStats = await client.getServerStats();
    return (serverStats == null);
  }

  Future<bool> updateHostStats() async {
    hostStats = await client.getHostStats();
    return (hostStats == null);
  }

  Future<bool> updateAll() async {
    bool isError = false;
    try {
      isError = (await updateServerStats() || await updateHostStats());
    } catch (e) {
      log(e.toString());
      isError = true;
    }
    return isError;
  }

  ServerStat getServersStatById(int serverId){
    return serverStats.where((element) => element.serverId==serverId).toList().first;
  }

  User.fromJson(Map<String, dynamic> json)
      : serverStats = serverStatFromJson(json['serverStats']),
        hostStats = hostStatFromJson(json['hostStats']),
        client = CraftyClient.fromJson(json['client']);
  Map<String, dynamic> toJson() => {
        'serverStats': serverStatToJson(serverStats),
        'hostStats': hostStatToJson(hostStats),
        'client': client.toJson(),
      };
}
