import 'dart:convert';
import 'dart:io';
import 'package:flutter_basic_01/data/storage/auth_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final TokenStorage _tokenStorage = TokenStorage();

String get BASE_URL {
  // .envから取得、なければデフォルト値を使用
  String baseUrl = dotenv.env['BASE_API_URL'] ?? '';

  if (baseUrl.isEmpty) {
    // プラットフォームに応じて適切なURLを設定
    if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:8080/api/v1'; // Androidエミュレーター用
    } else if (Platform.isIOS) {
      baseUrl = 'http://localhost:8080/api/v1'; // iOSシミュレーター用
    } else {
      baseUrl = 'http://localhost:8080/api/v1'; // Web/Desktop用
    }
  }

  return baseUrl;
}

Future<Map<String, dynamic>> register(
  String email,
  String username,
  String password,
) async {
  try {
    final url = Uri.parse('$BASE_URL/auth/register');

    print('Register API URL: $url');
    print(
      'Request body: ${jsonEncode({'email': email, 'username': username, 'password': password})}',
    );

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'username': username,
            'password': password,
          }),
        )
        .timeout(Duration(seconds: 10));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      String errorMessage = '登録に失敗しました';
      try {
        final errorBody = jsonDecode(response.body);
        errorMessage = errorBody['message'] ?? errorMessage;
      } catch (e) {
        errorMessage = 'サーバーエラー: ${response.statusCode}';
      }
      throw Exception(errorMessage);
    }
  } catch (e) {
    print('Register error: $e');
    rethrow;
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final url = Uri.parse('$BASE_URL/auth/login');

    print('Login API URL: $url');
    print(
      'Request body: ${jsonEncode({'email': email, 'password': password})}',
    );

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(Duration(seconds: 10));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(">>>>>>");
    print(jsonDecode(response.body)["data"]["accessToken"]);

    if (response.statusCode == 200) {
      // save token to storage
      final accessToken = jsonDecode(response.body)["data"]["accessToken"];
      await _tokenStorage.saveAccessToken(accessToken);
      final refreshToken = jsonDecode(response.body)["data"]["refreshToken"];
      await _tokenStorage.saveRfreshAccessToken(refreshToken);

      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      String errorMessage = 'ログインに失敗しました';
      try {
        final errorBody = jsonDecode(response.body);
        errorMessage = errorBody['message'] ?? errorMessage;
      } catch (e) {
        errorMessage = 'サーバーエラー: ${response.statusCode}';
      }
      throw Exception(errorMessage);
    }
  } catch (e) {
    print('Login error: $e');
    rethrow;
  }
}

// get new accessToken by refreshToken

Future<http.Response> authRequest(
  Future<http.Response> Function(String? accessToken) requestFn,
) async {
  String? accessToken = await _tokenStorage.readAccessToken();

  // 1回目のAPI呼び出し
  var response = await requestFn(accessToken);

  if (response.statusCode != 401) {
    return response;
  }

  // === ここから Refresh Token フロー ===
  final refreshToken = await _tokenStorage.readRfreshAccessToken();
  if (refreshToken == null) {
    throw Exception("ログイン期限切れ（refreshTokenなし）");
  }

  // Refresh APIを呼ぶ
  final refreshRes = await http.post(
    Uri.parse('$BASE_URL/auth/refresh'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({"refreshToken": refreshToken}),
  );

  if (refreshRes.statusCode != 200) {
    throw Exception("ログイン期限切れ（refreshToken無効）");
  }

  final newAccessToken = jsonDecode(refreshRes.body)["data"]["accessToken"];

  // 新しい token を保存
  await _tokenStorage.saveAccessToken(newAccessToken);

  // ==== 新しい token で API 再試行 ====
  return await requestFn(newAccessToken);
}
