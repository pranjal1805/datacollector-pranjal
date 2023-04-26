import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:datacollector/screens/dashboard_new.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
//

// late List<CameraDescription> _cameras;
//
// Future<void> camera() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   _cameras = await availableCameras();
//   runApp(const CameraApp());
// }
//
// class CameraApp extends StatefulWidget {
//   /// Default Constructor
//   const CameraApp({Key? key}) : super(key: key);
//
//   @override
//   State<CameraApp> createState() => _CameraAppState();
// }
// class _CameraAppState extends State<CameraApp> {
//   late CameraController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(_cameras[0], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//           // Handle access errors here.
//             break;
//           default:
//           // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: CameraPreview(controller),
//     );
//   }
// }
//-==========================================================
/*void _createFile(String _completeFileName) async {
  final directory = await getApplicationDocumentsDirectory();
  String _path = directory.path;
  File(_path + '/image-files/' + _completeFileName)
      .create(recursive: true)
      .then((File file) async {
    //write to file
    Uint8List bytes = await file.readAsBytes();
    file.writeAsBytes(bytes);
    print(file.path);
  });
}

void _createDirectory(String _path) async {
  bool isDirectoryCreated = await Directory(_path).exists();
  if (!isDirectoryCreated) {
    Directory(_path)
        .create()
    // The created directory is returned as a Future.
        .then((Directory directory) {
      print(directory.path);
    });
  }
}

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              height: 740,
              width: 400,
              child: CameraPreview(controller),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              pictureFile = await controller.takePicture();
              setState(() {});
            },
            child: const Text('Capture Image'),
          ),
        ),
        if (pictureFile != null)
          Image.network(
            pictureFile!.path,
            height: 100,
          )
        //Android/iOS
        // Image.file(File(pictureFile!.path)))
      ],
    );
  }
}*/
//==================================================================


late List<CameraDescription> cameras;

Future<void> camerasrun() async {
  cameras = await availableCameras();
  runApp(MaterialApp(
    home: CameraApp(),
  ));
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  bool _cameraOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _cameraOn ? Camera() : Container(),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cameraOn = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Post())).then((res) {
                setState(() {
                  _cameraOn = true;
                });
              }).catchError((err) {
                print(err);
              });
            },
            child: Text("Capture"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cameraOn = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      //Navigator.push(context,MaterialPageRoute());
                      builder: (BuildContext context) => HomePageWidget())).then((res) {}).catchError((err) {
                print(err);
              });
            },
            child: Text("Back"),
          ),
        ],
      ),
    );
  }
}

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return // set the amount of padding
       Scaffold(
        appBar: AppBar(
          title: Text('Save'),
        ),
        body: Center(
        child: TextButton(onPressed: () {}, child: Text("Post"),

        ),
        ),
      );

  }
}
