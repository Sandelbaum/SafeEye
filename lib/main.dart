import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safeeye/screens/login_screen.dart';

void main() async {
  await _initialize();
  runApp(const SafeEye());
}

getPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.locationAlways,
    Permission.notification,
  ].request();
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
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LogInScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        brightness: Brightness.light,
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
    );
  }
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: '08qpd7rrsb',
    onAuthFailed: (e) => log("네이버 맵 인증오류: $e", name: "onAuthFailed"),
  );
}
