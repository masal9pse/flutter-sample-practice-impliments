import 'dart:async'; //非同期処理用
import 'dart:convert'; //httpレスポンスをJSON形式に変換用
import 'package:http/http.dart' as http;

Future<String> getPostResponse(String url) async {
  final url2 = Uri.parse(url);
  final response = await http.post(url2);
  print(response.body);
  return '1';
}