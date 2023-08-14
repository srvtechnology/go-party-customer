import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class CustomDioClient {
  late Dio _client;

  // Private constructor to prevent instantiation from outside the class.
  CustomDioClient._privateConstructor() {
    _client = Dio();
    _client.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  // Singleton instance variable
  static CustomDioClient? _instance;

  // Factory constructor to provide access to the singleton instance
  factory CustomDioClient() {
    _instance ??= CustomDioClient._privateConstructor();
    return _instance!;
  }

  Dio get client => _client;
}

CustomDioClient customDioClient = CustomDioClient();