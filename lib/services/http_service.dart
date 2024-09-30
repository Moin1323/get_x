import 'package:dio/dio.dart';
import 'package:getx/const.dart';

class HttpService {
  final Dio _dio = Dio();

  HttpService() {
    _configureDio();
  }

  _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: "https://api.cryptorank.io/v1/",
      queryParameters: {
        "api_key": CRYPTO_RANK_API_KEY,
      },
    );
  }

  Future<dynamic> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
