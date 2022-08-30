import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // メソッドチャンネルを作成
  static const batteryChannel = MethodChannel('mukku.com/battery');
  // バッテリーの残量
  String batteryLevel = 'Waiting...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // バッテリーの残量を表示
        child: Text(batteryLevel),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // メソッドチャンネルを使って、バッテリーの残量をbatteryLevelに代入する
          await getBatteryLevel();
        },
        tooltip: 'Get Battery Level',
        child: const Icon(Icons.battery_full),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getBatteryLevel() async {
    // iOSのメソッドに受けわたす引数
    final arguments = {'name': 'Naoki Honda'};
    // バッテリーの残量を取得
    final String newBateryLevel =
        await batteryChannel.invokeMethod('getBatteryLevel', arguments);
    // 画面を再描画する
    setState(() {
      batteryLevel = '$newBateryLevel%';
    });
  }
}