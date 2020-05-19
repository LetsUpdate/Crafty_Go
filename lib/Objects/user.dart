import 'dart:developer';

import 'package:craftycommander/CraftyAPI/craftyAPI.dart';
import 'package:craftycommander/CraftyAPI/static/models/hotstStat.dart';
import 'package:craftycommander/CraftyAPI/static/models/McServer.dart';

class User {
  CraftyClient client;
  List<McServer> serverStats;
  HostStat hostStats;
  DateTime lastUpdated;
  bool isCached =true;

  String getLastUpdated(){
    return "${lastUpdated.year.toString()}-${lastUpdated.month.toString().padLeft(2,'0')}-${lastUpdated.day.toString().padLeft(2,'0')} ${lastUpdated.hour.toString().padLeft(2,'0')}:${lastUpdated.minute.toString().padLeft(2,'0')}";
  }

  User(String apiKey, String url) {
    client = new CraftyClient(apiKey, url);
    updateAll().then((value) => isCached=value);
  }

  Future<bool> updateServerStats() async {
    serverStats = await client.getServerStats();
    bool isError=serverStats == null;
    afterUpdate(isError);
    return isError;
  }
  void afterUpdate(bool isError){
    isCached=isError;
    if(!isError)
      lastUpdated=DateTime.now();
  }

  Future<bool> updateHostStats() async {
    hostStats = await client.getHostStats();
    bool isError=hostStats == null;
    afterUpdate(isError);
    return isError;
  }

  Future<bool> updateAll() async {
    bool isError = false;
    try {
      isError = (await updateServerStats() || await updateHostStats());
    } catch (e) {
      log(e.toString());
      isError = true;
      afterUpdate(true);
    }
    return isError;
  }

  McServer getServersStatById(int serverId){
    return serverStats.where((element) => element.serverId==serverId).toList().first;
  }

  User.fromJson(Map<String, dynamic> json)
      : serverStats = serverStatFromJson(json['serverStats']),
        hostStats = hostStatFromJson(json['hostStats']),
        client = CraftyClient.fromJson(json['client']),
        lastUpdated=DateTime.parse(json['lastUpdated']??'0000-00-00');
  Map<String, dynamic> toJson() => {
        'serverStats': serverStatToJson(serverStats),
        'hostStats': hostStatToJson(hostStats),
        'client': client.toJson(),
        'lastUpdated':lastUpdated.toString(),
      };
}
