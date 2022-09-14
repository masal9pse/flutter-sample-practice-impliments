import 'dart:async'; //非同期処理用
import 'package:test_project/test_project.dart';
import 'dart:convert'; //httpレスポンスをJSON形式に変換用
import 'package:test/test.dart';

void main() {
  test('/challengesにPOSTでHTTPリクエストを送信してチャレンジを開始します。', () async {
    final a = await getPostResponse('http://challenge.z2o.cloud/challenges?nickname=hoge');
    expect(a, '1');
  });
}
