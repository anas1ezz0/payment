import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response> post(
      {required String url,
      required String token,
      Map<String, String>? headers,
      required body,
      String? contentType}) async {
    var response = await dio.post(url,
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: headers ?? {'Authorization': 'Bearer $token'},
        ));
    return response;
  }
}
