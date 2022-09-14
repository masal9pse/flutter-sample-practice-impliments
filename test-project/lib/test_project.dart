import 'dart:async'; //非同期処理用
import 'dart:convert'; //httpレスポンスをJSON形式に変換用
import 'package:http/http.dart' as http;
import 'package:test_project/model/api_response.dart';

Future<void> execute() async {
  final response = await fetchPostResponse(
      url: 'http://challenge.z2o.cloud/challenges?nickname=miura');
  final nowActivesAtTime = convertUnixTimeMillisecondsToNowTime(
      unixTimeMilliseconds: response.activesAt);
  final nowCalledAtTime = convertUnixTimeMillisecondsToNowTime(
      unixTimeMilliseconds: response.calledAt);
  hitPutApi(
      id: response.id,
      activeAt: nowActivesAtTime,
      calledAt: nowCalledAtTime,
      url: 'http://challenge.z2o.cloud/challenges');
}

Future<ApiPostResponse> fetchPostResponse({required String url}) async {
  final response = await http.post(Uri.parse(url));
  final decoded = json.decode(response.body) as Map<String, dynamic>;
  final convertedResponse = ApiPostResponse.fromJson(decoded);
  print(response.body);
  print(convertedResponse.activesAt);
  print(convertedResponse.id);
  // mockで差し替えないとテストが通らん。
  return convertedResponse;
}

Future<void> hitPutApi(
    {required String id,
    required DateTime activeAt,
    required,
    required DateTime calledAt,
    required String url}) {
  final diff = activeAt.difference(calledAt);
  Timer(diff, () async {
    final response =
        await http.put(Uri.parse(url), headers: {'X-Challenge-Id': id});
    print(response.body);
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final convertedResponse = ApiPostResponse.fromJson(decoded);
    hitPutApi(
        id: convertedResponse.id,
        activeAt: convertUnixTimeMillisecondsToNowTime(
            unixTimeMilliseconds: convertedResponse.activesAt),
        calledAt: convertUnixTimeMillisecondsToNowTime(
            unixTimeMilliseconds: convertedResponse.calledAt),
        url: url);
  });

  return Future.value();
}

DateTime convertUnixTimeMillisecondsToNowTime(
    {required String unixTimeMilliseconds}) {
  return DateTime.fromMillisecondsSinceEpoch(int.parse(unixTimeMilliseconds));
}
