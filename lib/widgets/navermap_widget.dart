import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapWidget extends StatefulWidget {
  const NaverMapWidget({super.key});

  @override
  State<NaverMapWidget> createState() => _NaverMapWidgetState();
}

class _NaverMapWidgetState extends State<NaverMapWidget> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  @override
  Widget build(BuildContext context) {
    return NaverMap(
        options: const NaverMapViewOptions(
          indoorEnable: true,
          locationButtonEnable: true,
          consumeSymbolTapEvents: false,
        ),
        onMapReady: (controller) async {
          mapControllerCompleter.complete(controller);
        },
    );
  }
}
