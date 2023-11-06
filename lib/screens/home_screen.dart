import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_button/group_button.dart';
import 'package:safeeye/services/notification_service.dart';
import 'package:safeeye/widgets/navermap_widget.dart';
import 'package:safeeye/widgets/settings_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum Types {
  assault('폭행'),
  theft('절도'),
  knife('칼부림'),
  fall('쓰러짐'),
  other('기타');

  const Types(this.korean);
  final String korean;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.socket}) : super(key: key);
  final io.Socket socket;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int selectedIndex = 0;
  int groupbuttonIndex = -1;
  List<NLatLng> locations = [];
  final TextEditingController _reportController = TextEditingController();

  @override
  void initState() {
    FlutterLocalNotification.init();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        widget.socket.on('alert', (data) async {
          Map<String, dynamic> mapdata = data;
          await FlutterLocalNotification.showNotification(
              '사건 발생!', mapdata['msg']);
        });
      },
    );
  }

  void onPressedSend() {
    FocusScope.of(context).unfocus();
    if (groupbuttonIndex == -1) {
      Fluttertoast.showToast(
        msg: '사건의 종류를 선택해주세요',
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
      return;
    }
    String type = Types.values[groupbuttonIndex].korean;
    String msg = _reportController.text;
    dynamic data = {'type': type, 'msg': msg};
    widget.socket.emit('report', jsonEncode(data));
    widget.socket.on('report_success', (receive) {
      List<dynamic> jsondata = jsonDecode(receive);
      Map<String, String> mapdata = {'msg': jsondata[0]};
      Fluttertoast.showToast(
        msg: mapdata['msg']!,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
    });
    _reportController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            NaverMapWidget(socket: widget.socket),
            SettingsWidget(socket: widget.socket),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: '설정',
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade400,
        foregroundColor: const Color(0xFFF8F6F4),
        child: const Icon(Icons.warning_rounded),
        onPressed: () {
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                title: const Text('신고하기'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GroupButton(
                      options: GroupButtonOptions(
                        unselectedShadow: const [],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      buttons: const ['폭행', '절도', '칼부림', '쓰러짐', '기타'],
                      onSelected: (value, index, isSelected) {
                        groupbuttonIndex = index;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reportController,
                      decoration: InputDecoration(
                        filled: true,
                        //fillColor: Colors.white70,
                        hintText: '자세한 상황을 설명해 주세요',
                        labelText: '자세한 상황을 설명해 주세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onPressedSend,
                        child: const Text('제출하기'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
