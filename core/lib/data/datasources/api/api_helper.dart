import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class ApiHelper {
  static ApiHelper? _apiHelper;
  ApiHelper._instance() {
    _apiHelper = this;
  }

  factory ApiHelper() => _apiHelper ?? ApiHelper._instance();

  static HttpClient? _apiClient;

  Future<HttpClient?> get apiClient async {
    _apiClient ??= await _initClient();
    return _apiClient;
  }

  Future<HttpClient> _initClient() async {
    final sslCert = await rootBundle.load('certificates/certificates.cer');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    final client = HttpClient(context: securityContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return client;
  }

  Future<Response> get(Uri url) async {
    final client = await apiClient;
    final ioClient = IOClient(client);
    final response = await ioClient.get(url);
    return response;
  }
}
