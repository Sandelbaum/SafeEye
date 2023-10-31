import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:safeeye/widgets/navermap_widget.dart';
import 'package:safeeye/widgets/settings_widget.dart';
import 'package:web_socket_channel/io.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.username, required this.channel})
      : super(key: key);
  final String username;
  final IOWebSocketChannel channel;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final TextEditingController _reportController = TextEditingController();

  void onPressedSend() {
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
            const NaverMapWidget(),
            SettingsWidget(channel: widget.channel),
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


// BottomAppBar(
// shape: const CircularNotchedRectangle(),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// IconButton(
// icon: const Icon(Icons.map_rounded),
// onPressed: () {},
// ),
// const SizedBox(),
// IconButton(
// icon: const Icon(Icons.settings_rounded),
// onPressed: () {},
// ),
// ],
// ),
// ),


// NavigationBar(
// selectedIndex: selectedIndex,
// onDestinationSelected: (value) => setState(() {
// selectedIndex = value;
// }),
// destinations: const [
// NavigationDestination(
// icon: Icon(Icons.house),
// label: '홈',
// ),
// NavigationDestination(
// icon: Icon(Icons.warning_rounded),
// label: '신고',
// ),
// NavigationDestination(
// icon: Icon(Icons.settings),
// label: '설정',
// ),
// ],
// ),