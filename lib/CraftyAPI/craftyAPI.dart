import 'package:craftycontroller/CraftyAPI/static/routes.dart' as routes;
import 'package:http/http.dart' as http;

import 'static/models/payload.dart';

class CraftyClient {
  final String API_TOKEN;
  final String URL;

  const CraftyClient(this.API_TOKEN, this.URL);

  CraftyResponse _unpackResponse(http.Response response) {
    return craftyResponseFromJson(response.body);
  }

  Future<CraftyResponse> _make_get_request(String apiRoute,
      Map<String, String> params) async {
    if (params == null) params = Map();
    params.addAll({"token": API_TOKEN});
    var uri = Uri.https(URL, apiRoute, params);
    return _unpackResponse(await http.get(uri));
  }

  Future<String> _make_post_request(String apiRoute, Map<String, String> params,
      String body) async {
    if (params == null) params = Map();
    params.addAll({"token": API_TOKEN});
    var uri = Uri.https(URL, apiRoute, params);
    //return _unpackResponse(await http.post(uri,body: body));
  }

  Future<String> getServerList() async {
    CraftyResponse response = await _make_get_request(
        routes.MCAPIRoutes.LIST, null);
  }

}