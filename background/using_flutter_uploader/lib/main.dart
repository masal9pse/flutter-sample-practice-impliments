import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:using_flutter_uploader/config.dart';

const String title = "FileUpload Sample app";
// const String uploadURL =
//     "https://us-central1-flutteruploader.cloudfunctions.net/upload";
String uploadURL =
    '$envUrl/api/upload_car_photo/1';

const String uploadBinaryURL =
    "https://us-central1-flutteruploader.cloudfunctions.net/upload/binary";

void main() => runApp(App());

class App extends StatefulWidget {
  final Widget? child;

  App({Key? key, this.child}) : super(key: key);

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadScreen(),
    );
  }
}

class UploadItem {
  final String id;
  final String taskId;
  final MediaType type;
  final int progress;
  final UploadTaskStatus status;

  UploadItem({
    required this.id,
    required this.taskId,
    required this.type,
    this.progress = 0,
    this.status = UploadTaskStatus.undefined,
  });

  UploadItem copyWith({required UploadTaskStatus status, int? progress}) =>
      UploadItem(
          id: this.id,
          taskId: this.taskId,
          type: this.type,
          status: status,
          progress: progress ?? this.progress);

  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
      this.status == UploadTaskStatus.complete ||
      this.status == UploadTaskStatus.failed;
}

enum MediaType { Image, Video }

class UploadScreen extends StatefulWidget {
  UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  FlutterUploader uploader = FlutterUploader();
  late StreamSubscription _progressSubscription;
  late StreamSubscription _resultSubscription;
  Map<String, UploadItem> _tasks = {};

  @override
  void initState() {
    super.initState();
    _progressSubscription = uploader.progress.listen((progress) {
      final task = _tasks[progress.taskId];
      print("progress: ${progress.progress} , tag: ${progress.taskId}");
      if (task == null) return;
      if (task.isCompleted()) return;
      setState(() {
        _tasks[progress.taskId] = task.copyWith(
            progress: progress.progress!, status: progress.status);
      });
    });
    _resultSubscription = uploader.result.listen((result) {
      print(
          "id: ${result.taskId}, status: ${result.status}, response: ${result.response}, statusCode: ${result.statusCode}, taskId: ${result.taskId}, headers: ${result.headers}");

      final task = _tasks[result.taskId];
      if (task == null) return;

      setState(() {
        _tasks[result.taskId] = task.copyWith(status: result.status!);
      });
    }, onError: (ex, stacktrace) {
      print("exception: $ex");
      print("stacktrace: $stacktrace");
      // final exp = ex as UploadException;
      // final task = _tasks[exp.tag];
      // if (task == null) return;

      // setState(() {
      //   _tasks[exp.tag] = task.copyWith(status: exp.status);
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _progressSubscription.cancel();
    _resultSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(height: 20.0),
            Text(
              'multipart/form-data uploads',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => getImage(binary: false),
                  child: Text("upload image"),
                ),
                Container(width: 20.0),
                // RaisedButton(
                //   onPressed: () => getVideo(binary: false),
                //   child: Text("upload video"),
                // )
              ],
            ),
            Container(height: 20.0),
            Text(
              'binary uploads',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text('this will upload selected files as binary'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => getImage(binary: true),
                  child: Text("upload image"),
                ),
                Container(width: 20.0),
                // RaisedButton(
                //   onPressed: () => getVideo(binary: true),
                //   child: Text("upload video"),
                // )
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(20.0),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final item = _tasks.values.elementAt(index);
                  print("${item.taskId} - ${item.status}");
                  return UploadItemView(
                    item: item,
                    onCancel: cancelUpload,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _uploadUrl({required bool binary}) {
    if (binary) {
      return uploadBinaryURL;
    } else {
      return uploadURL;
    }
  }

  Future getImage({required bool binary}) async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      // final String filename = basename(image.path);
      // final String savedDir = dirname(image.path);
      final tag = "image upload ${_tasks.length + 1}";
      var url = _uploadUrl(binary: binary);
      var fileItem = FileItem(
        // filename: filename,
        // savedDir: savedDir,
        // path: savedDir,
        path: image.path,
        // fieldname: "file",
        field: "file",
      );

      // var taskId = binary
      //     ? await uploader.enqueueBinary(
      //         url: url,
      //         file: fileItem,
      //         method: UploadMethod.POST,
      //         tag: tag,
      //         showNotification: true,
      //       )
      //     : await uploader.enqueue(
      //         url: url,
      //         data: {"name": "john"},
      //         files: [fileItem],
      //         method: UploadMethod.POST,
      //         tag: tag,
      //         showNotification: true,
      //       );
      // var taskId = await uploader.enqueue(
      //         url: url,
      //         data: {"name": "john"},
      //         files: [fileItem],
      //         method: UploadMethod.POST,
      //         tag: tag,
      //         showNotification: true,
      //       );
      final upload = MultipartFormDataUpload(
        url: url,
        data: {"name": "john"},
        files: [fileItem],
        method: UploadMethod.POST,
        tag: tag,
        // showNotification: true,
      );
      var taskId = await uploader.enqueue(upload);
      // var taskId = await uploader.enqueue(
      //         url: url,
      //         data: {"name": "john"},
      //         files: [fileItem],
      //         method: UploadMethod.POST,
      //         tag: tag,
      //         showNotification: true,
      //       );

      setState(() {
        _tasks.putIfAbsent(
            tag,
            () => UploadItem(
                  id: taskId,
                  taskId: tag,
                  type: MediaType.Image,
                  status: UploadTaskStatus.enqueued,
                ));
      });
    }
  }

  Future cancelUpload(String id) async {
    await uploader.cancel(taskId: id);
  }
}

typedef CancelUploadCallback = Future<void> Function(String id);

class UploadItemView extends StatelessWidget {
  late UploadItem item;
  late CancelUploadCallback onCancel;

  UploadItemView({
    Key? key,
    required this.item,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = item.progress.toDouble() / 100;
    final widget = item.status == UploadTaskStatus.running
        ? LinearProgressIndicator(value: progress)
        : Container();
    final buttonWidget = item.status == UploadTaskStatus.running
        ? Container(
            height: 50,
            width: 50,
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () => onCancel(item.id),
            ),
          )
        : Container();
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(item.taskId),
              Container(
                height: 5.0,
              ),
              Text(item.status.description),
              Container(
                height: 5.0,
              ),
              widget
            ],
          ),
        ),
        buttonWidget
      ],
    );
  }
}
