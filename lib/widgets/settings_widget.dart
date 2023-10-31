import 'package:flutter/material.dart';
import 'package:safeeye/screens/login_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key, required this.channel}) : super(key: key);

  final WebSocketChannel channel;
  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _enableNotification = false;

  void onTapLogout() {
    widget.channel.sink.close();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LogInScreen(),
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
