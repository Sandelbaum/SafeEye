import 'package:flutter/material.dart';
import 'package:safeeye/widgets/navermap_widget.dart';
import 'package:safeeye/widgets/report_widget.dart';
import 'package:safeeye/widgets/settings_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: IndexedStack(
          index: selectedIndex,
          children: const [
            NaverMapWidget(),
            ReportWidget(),
            SettingsWidget(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setState(() {
          selectedIndex = value;
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.house),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_rounded),
            label: '신고',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
