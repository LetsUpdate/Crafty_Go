import 'dart:developer';

import 'package:craftycontroller/CraftyAPI/static/routes.dart' as routes;
import 'package:http/http.dart' as http;

import 'static/models/payload.dart';

class CraftyClient {
  final String API_TOKEN;
  final String URL;

  CraftyClient(this.API_TOKEN, this.URL) {
    // anwser to certificate: https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req
  }


  CraftyResponse _unpackResponse(http.Response response) {
    return craftyResponseFromJson(response.body);
  }

  Future<CraftyResponse> _makeGetRequest(String apiRoute,
      Map<String, String> params) async {
    if (params == null) params = Map();
    params.addAll({"token": API_TOKEN});
    var uri = Uri.https(URL, apiRoute, params);
    return _unpackResponse(await http.get(uri));
  }

  Future<CraftyResponse> _makePostRequest(String apiRoute,
      Map<String, String> params, String body) async {
    if (params == null) params = Map();
    params.addAll({"token": API_TOKEN});
    var uri = Uri.https(URL, apiRoute, params);
    return _unpackResponse(await http.post(uri, body: body));
  }

  Future<String> getServerList() async {
    CraftyResponse response =
    await _makeGetRequest(routes.MCAPIRoutes.LIST, null);
    log(response.data);
    return response.data;
  }
}
