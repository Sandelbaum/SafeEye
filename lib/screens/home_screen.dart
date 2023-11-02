import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
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
  const HomeScreen({Key? key, required this.username, required this.socket})
      : super(key: key);
  final String username;
  final io.Socket socket;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final TextEditingController _reportController = TextEditingController();
  final GroupButtonController _groupButtonController = GroupButtonController();

  void onPressedSend() {
    String type = Types.values[_groupButtonController.selectedIndex].korean;
    String text = _reportController.text;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
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
                      onSelected: (value, index, isSelected) {},
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
