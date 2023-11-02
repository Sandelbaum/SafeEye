import 'package:flutter/material.dart';
import 'package:safeeye/screens/login_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key, required this.socket}) : super(key: key);

  final io.Socket socket;
  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _enableNotification = false;

  void onTapLogout() {
    widget.socket.close();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LogInScreen(socket: widget.socket),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '알림 끄기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch(
                  value: _enableNotification,
                  onChanged: (state) {
                    setState(() {
                      _enableNotification = state;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onTapLogout,
                child: const Text('로그아웃'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
