import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  final dio = Dio();

  ApiClient() {
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
          responseBody: true, requestBody: true, request: true));
    }
  }
}
