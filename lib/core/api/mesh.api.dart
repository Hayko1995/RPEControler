import 'package:http/http.dart' as http;
import 'package:rpe_c/app/routes/api.routes.dart';

class MeshAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };

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
}
