import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() =>
    const AndroidOptions(encryptedSharedPreferences: true);
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

Future<void> saveAccessToken(String token) async {
  await storage.write(key: "accessToken", value: token);
}

Future<void> readAccessToken(String token) async {
  await storage.read(key: "accessToken");
}

Future<void> saveRfreshAccessToken(String token) async {
  await storage.write(key: "refreshAccessToken", value: token);
}

Future<void> readRfreshAccessToken(String token) async {
  await storage.read(key: "refreshAccessToken");
}
