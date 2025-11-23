import 'dart:convert';

import 'package:flutter_basic_01/data/api/auth_service.dart';
import 'package:flutter_basic_01/data/storage/auth_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

String BASE_URL = dotenv.env['BASE_API_URL'] ?? '';
TokenStorage _tokenStorage = TokenStorage();

Future<Map<String, dynamic>> getAllTransactions() async {
  try {
    final url = Uri.parse('$BASE_URL/transactions');
    final response = await authRequest((token) async {
      return await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 10));
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load transactions: ${response.statusCode}');
    }
  } catch (e) {
    print('API error: $e');
    throw Exception(e.toString());
  }
}

// add transaction
Future<Map<String, dynamic>> addTransactions(body) async {
  try {
    final url = Uri.parse('$BASE_URL/transactions');
    final response = await authRequest((token) async {
      return await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 10));
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to add transaction: ${response.statusCode}');
    }
  } catch (e) {
    print('add error: $e');
    throw Exception(e.toString());
  }
}

//update transaction
Future<Map<String, dynamic>> updateTransactions(String id, dynamic body) async {
  try {
    final url = Uri.parse('$BASE_URL/transactions/$id');
    final response = await authRequest((token) async {
      return await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 10));
    });

    print('Sending transaction: ${jsonEncode(body)}');

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update transaction: ${response.statusCode}');
    }
  } catch (e) {
    print('update error: $e');
    throw Exception(e.toString());
  }
}

// delete transaction
Future<Map<String, dynamic>> deleteTransactions(String id) async {
  try {
    final url = Uri.parse('$BASE_URL/transactions/$id');
    final response = await authRequest((token) async {
      return await http
          .delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 10));
    });

    print('Sending transaction: ${jsonEncode(id)}');

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to add transaction: ${response.statusCode}');
    }
  } catch (e) {
    print('delete error: $e');
    throw Exception(e.toString());
  }
}

Future<Map<String, dynamic>> getMonthlySeparatedSummary() async {
  final url = Uri.parse('$BASE_URL/transactions/monthly-separated');
  final response = await authRequest((token) async {
    return await http
        .get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(Duration(seconds: 10));
  });

  if (response.statusCode == 200) {
    print(">>>>>get monthly sumary ");
    print(jsonDecode(response.body));
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception(
      'Failed to get monthly transaction: ${response.statusCode}',
    );
  }
}
