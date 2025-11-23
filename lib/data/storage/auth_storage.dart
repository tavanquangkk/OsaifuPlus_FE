import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await storage.write(key: "accessToken", value: token);
  }

  Future<String?> readAccessToken() async {
    return await storage.read(key: "accessToken");
  }

  Future<void> saveRfreshAccessToken(String token) async {
    await storage.write(key: "refreshAccessToken", value: token);
  }

  Future<String?> readRfreshAccessToken() async {
    return await storage.read(key: "refreshAccessToken");
  }
}
