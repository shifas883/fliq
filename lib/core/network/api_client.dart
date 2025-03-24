import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required String baseUrl})
      : dio = Dio(BaseOptions(
    baseUrl: 'https://test.myfliqapp.com/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> get(String path) async {
    return await dio.get(path);
  }
}
