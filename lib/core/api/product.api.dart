import 'package:http/http.dart' as http;
import 'package:rpe_c/app/routes/api.routes.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class ProductAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };

  Future fetchProducts() async {
    const subUrl = '/product';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    final http.Response response = await client.get(
      uri,
      headers: headers,
    );
    final body = response.body;
    return body;
  }

  Future fetchProductDetail({required dynamic id}) async {
    var subUrl = '/product/details/$id';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);

    final http.Response response = await client.get(
      uri,
      headers: headers,
    );
    final body = response.body;
    return body;
  }

  Future fetchProductCategory({required dynamic categoryName}) async {
    var subUrl = '/product/category/$categoryName';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);

    final http.Response response = await client.get(
      uri,
      headers: headers,
    );
    final body = response.body;
    return body;
  }

  Future searchProduct({required dynamic productName}) async {
    var subUrl = '/product/search/$productName';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);

    final http.Response response = await client.get(
      uri,
      headers: headers,
    );
    final body = response.body;
    return body;
  }

  Future updateData() async {
    //todo add problem response failure situation
    const subUrl = '/';
    List<String> lint = [];
    final Uri uri = Uri.parse(ApiRoutes.esp32Url + subUrl);
    try {
      final http.Response response = await client.post(
        uri,
        headers: headers,
      );
      final body = response.body;
      // print(body);

      var stringList = body.split(' ');
      print(stringList);
      stringList.removeLast();

      for (int i = 0; i < stringList.length; i++) {
        int _integerData = int.parse(stringList[i]);
        lint.add(_integerData.toRadixString(16));
      }
      print(lint);
      return body;
    } catch (e) {
      print("service = internet problem");
      return Null;
    }
  }
}
