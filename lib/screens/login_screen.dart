import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeeye/models/data_model.dart';
import 'package:safeeye/screens/home_screen.dart';
import 'package:safeeye/screens/signup_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key, required this.socket}) : super(key: key);
  final io.Socket socket;
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  StreamController streamController = StreamController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.socket.off('register_success');
    widget.socket.off('register_fail');
    widget.socket.on(
      'login_success',
      (response) {
        Map<String, dynamic> mapdata = response;
        Fluttertoast.showToast(
          msg: mapdata['msg'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        pushHome(widget.socket);
      },
    );
    widget.socket.on(
      'login_error',
      (response) {
        print(response);
        Map<String, dynamic> mapdata = jsonDecode(response);
        print(mapdata);
        Fluttertoast.showToast(
          msg: mapdata['msg'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
      },
    );
  }

  void onClickLogIn() async {
    FocusScope.of(context).unfocus();
    String username = _idController.text;
    String password = _pwdController.text;
    Map<String, String> data = {
      'username': username,
      'hashed_password': password,
    };
    var jsondata = jsonEncode(data);
    widget.socket.emit('login', jsondata);
  }

  void onDone() {
    Fluttertoast.showToast(
      msg: "연결 종료됨",
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
    );
  }

  void onError(e) {
    print("onError: $e");
  }

  void pushHome(io.Socket socket) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(socket: socket),
      ),
    );
  }

  void onClickSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen(socket: widget.socket),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '로그인',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'SafeEye',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '로그인',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _idController,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'ID',
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _pwdController,
                        textAlign: TextAlign.start,
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: SizedBox(
                          height: 60,
                          width: 400,
                          child: ElevatedButton(
                            onPressed: onClickLogIn,
                            child: const Text(
                              '로그인',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        height: 60,
                        width: 400,
                        child: ElevatedButton(
                          onPressed: onClickSignUp,
                          child: const Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
