import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safeeye/color_schemes.dart';
import 'package:safeeye/screens/login_screen.dart';

void main() async {
  await _initialize();
  runApp(const SafeEye());
}

class SafeEye extends StatefulWidget {
  const SafeEye({super.key});

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
      home: const LogInScreen(),
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
  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('mipmap/ic_launcher');
  DarwinInitializationSettings darwinInitializationSettings =
      const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings);
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
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
