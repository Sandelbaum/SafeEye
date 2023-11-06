import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safeeye/color_schemes.dart';
import 'package:safeeye/screens/login_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

void main() async {
  await _initialize();
  io.Socket socket = io.io(
    'http://172.17.3.124:8000',
    io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );
  socket.connect();
  socket.on(
    'connect_error',
    (error) {
      Fluttertoast.showToast(
        msg: error.toString(),
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
    },
  );
  runApp(SafeEye(
    socket: socket,
  ));
}

class SafeEye extends StatefulWidget {
  const SafeEye({Key? key, required this.socket}) : super(key: key);
  final io.Socket socket;
  @override
  State<SafeEye> createState() => _SafeEyeState();
}

class _SafeEyeState extends State<SafeEye> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogInScreen(
        socket: widget.socket,
      ),
      theme: ThemeData(
        colorScheme: lightColorScheme,
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
    );
  }
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    onAuthFailed: (e) => log("네이버 맵 인증오류: $e", name: "onAuthFailed"),
  );

  Map<Permission, PermissionStatus> statuses = await [
    Permission.locationWhenInUse,
    Permission.notification,
  ].request();
  if (statuses[Permission.locationWhenInUse]!.isGranted &&
      statuses[Permission.notification]!.isGranted) {
    return;
  } else {
    await openAppSettings();
    if (statuses[Permission.locationWhenInUse]!.isGranted == false ||
        statuses[Permission.notification]!.isGranted == false) {
      Fluttertoast.showToast(
        msg: '권한이 부여되지 않았습니다. 앱을 종료합니다.',
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
      exit(1);
    }
    return;
  }
}
