import 'package:craftycommander/CraftyAPI/craftyAPI.dart';
import 'package:craftycommander/CraftyAPI/static/models/hotstStat.dart';
import 'package:craftycommander/CraftyAPI/static/models/serverStat.dart';

class User{
  CraftyClient client;
  List<ServerStat> serverStats;
  HostStat hostStats;

  User(String apiKey, String url){
    client = new CraftyClient(apiKey, url);
    updateHostStats();
    updateServerStats();
  }

  Future<bool> updateServerStats()async{
    serverStats= await client.getServerStats();
    return (serverStats==null);
  }

  Future<bool> updateHostStats()async{
    hostStats=await client.getHostStats();
    return(hostStats==null);
  }
}