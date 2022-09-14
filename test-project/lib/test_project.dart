import 'dart:async'; //非同期処理用
import 'dart:convert'; //httpレスポンスをJSON形式に変換用
import 'package:http/http.dart' as http;
import 'package:test_project/model/api_response.dart';

Future<void> execute() async {
  final response = await fetchPostResponse(
      url: 'http://challenge.z2o.cloud/challenges?nickname=miura');
  final nowTime = convertUnixTimeMillisecondsToNowTime(
      unixTimeMilliseconds: response.activesAt);
  // put処理
  final putResponse = await hitPutApi(
      id: response.id,
      date: nowTime,
      url: 'http://challenge.z2o.cloud/challenges');
}

Future<ApiPostResponse> fetchPostResponse({required String url}) async {
  // final nickName = {'nickmame': 'miura'};
  // final response = await http.post(Uri.parse(url), body: json.encode(nickName));
  final response = await http.post(Uri.parse(url));
  final decoded = json.decode(response.body) as Map<String, dynamic>;
  final convertedResponse = ApiPostResponse.fromJson(decoded);
  print(response.body);
  print(convertedResponse.activesAt);
  print(convertedResponse.id);
  // mockで差し替えないとテストが通らん。
  return convertedResponse;
}

Future<String> hitPutApi(
    {required String id, required DateTime date, required String url}) {
  Timer(date.difference(date), () async {
    print(date);
    print('時間指定でデータを送ります。');
    // final response =
    //     await http.post(Uri.parse(url), headers: {'X-Challenge-Id': id});
    final response =
        await http.put(Uri.parse(url), headers: {'X-Challenge-Id': id});
    print(response.body);
    // final decoded = json.decode(response.body) as Map<String, dynamic>;
    // final b = ApiPostResponse.fromJson(decoded);
    // print(response.body);
    // print(b.id);
  });
  // return '1';
  return Future.value('1');
}

DateTime convertUnixTimeMillisecondsToNowTime(
    {required String unixTimeMilliseconds}) {
  int k = 3;
  return DateTime.fromMillisecondsSinceEpoch(int.parse(unixTimeMilliseconds));
}
