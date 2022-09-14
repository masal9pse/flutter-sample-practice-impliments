import 'dart:async'; //非同期処理用
import 'package:test_project/test_project.dart';
import 'dart:convert'; //httpレスポンスをJSON形式に変換用
import 'package:test/test.dart';

void main() {
  // test('/challengesにPOSTでHTTPリクエストを送信してチャレンジを開始', () async {
  //   final getPostResponses = await getPostResponse('http://challenge.z2o.cloud/challenges?nickname=hoge');
  //   expect(getPostResponses, '1');
  // });

  group('convertUnixTimeMillisecondsToNowTimeはUNIXタイムミリ秒を現在時刻に変換する。', () {
    test('1663145612534は2022-09-14:53:32:534秒である。', () async {
      expect(convertUnixTimeMillisecondsToNowTime('1663145612534'),
          DateTime(2022, 09, 14, 17, 53, 32, 534));
    });
  });
}
