import 'dart:async'; //非同期処理用
import 'dart:convert'; //httpレスポンスをJSON形式に変換用
import 'package:http/http.dart' as http;
import 'package:test_project/model/api_response.dart';

Future<void> execute () async {
  final response = await fetchPostResponse('getPostResponse');
  final nowTime = convertUnixTimeMillisecondsToNowTime(response.activesAt);
  // put処理
}

Future<ApiPostResponse> fetchPostResponse(String url) async {
  final response = await http.post(Uri.parse(url));
  final decoded = json.decode(response.body) as Map<String, dynamic>;
  final b = ApiPostResponse.fromJson(decoded);
  print(response.body);
  print(b.id);
  // mockで差し替えないとテストが通らん。
  return b;
}

DateTime convertUnixTimeMillisecondsToNowTime(String unixTimeMilliseconds) {
  return DateTime.fromMillisecondsSinceEpoch(int.parse(unixTimeMilliseconds));
}
