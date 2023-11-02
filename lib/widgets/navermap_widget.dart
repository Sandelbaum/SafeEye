import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class NaverMapWidget extends StatefulWidget {
  const NaverMapWidget({Key? key, required this.socket}) : super(key: key);
  final io.Socket socket;
  @override
  State<NaverMapWidget> createState() => _NaverMapWidgetState();
}

class _NaverMapWidgetState extends State<NaverMapWidget> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: const NaverMapViewOptions(
        indoorEnable: false,
        locationButtonEnable: true,
        consumeSymbolTapEvents: false,
      ),
      onMapReady: (controller) async {
        mapControllerCompleter.complete(controller);
      },
    );
  }
}
