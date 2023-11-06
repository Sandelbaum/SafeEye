import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safeeye/screens/login_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.socket}) : super(key: key);
  final io.Socket socket;
  @override
  State<SignUpScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<SignUpScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _pwdckController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.socket.on(
      'register_success',
      (response) {
        Map<String, dynamic> mapdata = response;
        Fluttertoast.showToast(
          msg: mapdata['msg'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        widget.socket.off('register_success');
        widget.socket.off('register_fail');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LogInScreen(socket: widget.socket),
          ),
        );
      },
    );
    widget.socket.on(
      'register_fail',
      (response) {
        Map<String, dynamic> mapdata = jsonDecode(response);
        Fluttertoast.showToast(
          msg: mapdata['msg'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
      },
    );
  }

  void onClickSignUp() async {
    FocusScope.of(context).unfocus();
    String username = _idController.text;
    String email = _emailController.text;
    String school = _schoolController.text;
    String password = _pwdController.text;
    String chkpassword = _pwdckController.text;
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(email)) {
      Fluttertoast.showToast(
        msg: '올바른 이메일을 입력해주세요',
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
      return;
    }
    if (password != chkpassword) {
      Fluttertoast.showToast(
        msg: '비밀번호가 서로 다릅니다',
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
    }
    Map<String, String> data = {
      'username': username,
      'email': email,
      'school_name': school,
      'hashed_password': password,
    };

    var jsondata = jsonEncode(data);
    widget.socket.emit('register', jsondata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            '회원가입',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            onPressed: () {
              widget.socket.off('register_success');
              widget.socket.off('register_fail');
              Navigator.pop(context); //뒤로가기
            },
            icon: const Icon(Icons.arrow_back),
          )),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                        controller: _schoolController,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          labelText: '학교 이름',
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                        controller: _emailController,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          labelText: '이메일',
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                        controller: _pwdckController,
                        textAlign: TextAlign.start,
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          labelText: '비밀번호 확인',
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
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
                        width: 400,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
