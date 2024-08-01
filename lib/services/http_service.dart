import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HTTPService {
  final Dio _dio = Dio();

  HTTPService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: "https://api.cryptorank.io/v1/",
      queryParameters: {
        "api_key": dotenv.env['CRYPTO_RANK_API_KEY'],
      },
    );
  }

  Future<dynamic> get({required String path}) async {
    try {
      Response res = await _dio.get(path);
      return res.data;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
