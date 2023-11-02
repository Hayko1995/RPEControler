import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:rpe_c/app/routes/api.routes.dart';
import "package:hex/hex.dart";
import 'package:convert/convert.dart';

class MeshAPI {
  final client = http.Client();
  final headers = {'Content-Type': 'application/text; charset=utf-8'};

  Future meshUpdate() async {
    //todo add problem response failure situation
    const subUrl = '/mesh/update';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    try {
      final http.Response response = await client.get(
        uri,
        headers: headers,
      );
      final body = response.body;
      return body;
    } catch (e) {
      print("service = internet problem");
      return Null;
    }
  }

  Future meshInit() async {
    String pktHdr = "E1FF060001FA";
    var result = [];

    for (var i = 0; i < pktHdr.length; i += 2) {
      result.add(int.parse(pktHdr.substring(i, i + 2), radix: 16));
    }
    //todo add problem response failure situation
    final Uri uri = Uri.parse("http://192.168.8.1:80");

    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: result);
      final body = response.body;
      return body;
    } catch (e) {
      print("service = internet problem");
      return Null;
    }
  }
}
