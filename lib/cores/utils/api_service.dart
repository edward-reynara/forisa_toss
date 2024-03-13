import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../configs/config.dart';

class ApiService {
  late Dio dio;
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  Dio getApiClient({context, bool useToken = true}) {
    Duration time_10s = const Duration(seconds: 10);
    Duration time_100s = const Duration(seconds: 100);
    BaseOptions options = BaseOptions(
        baseUrl: Config.apiUrl,
        connectTimeout: time_10s,
        receiveTimeout: time_100s,
        headers: {
          "Accept": "application/json",
        });
    dio = Dio(options);

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient httpClient) {
    //   httpClient.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    // };

    // dio.interceptors.add(getCacheManager().interceptor);
    dio.interceptors.add(
      InterceptorsWrapper(onResponse: (response, handler) {
        print('On Response : ${response.statusCode}-${response.statusMessage}');

        return handler.next(response);
      }, onRequest: (options, handler) async {
        print('On Request : ${options.uri.path}');

        String? token = await flutterSecureStorage.read(key: 'token');
        String? deviceId = await flutterSecureStorage.read(key: 'device_id');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (deviceId != null) {
          options.headers['DeviceId'] = deviceId;
        }
        return handler.next(options);
      }, onError: (DioException e, handler) {
        // Here intercept error
        return handler.next(e);
      }),
    );

    return dio;
  }
}
