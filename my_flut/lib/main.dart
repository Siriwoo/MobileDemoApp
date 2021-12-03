import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_flut/homepage.dart';
import 'package:my_flut/pages/userpage.dart';
//import 'package:my_flut/loginpage.dart';

//เรียกโปรแกรมมารันในนี้
//main เรียก MaterialApp มาแสดงผ่านการเรียก MyApp
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //สร้างแอพฯ แล้ว return ตามที่ออกแบบ
    return MaterialApp(
      //เปิดหน้า homepage
      home: FingerprintLogin(),
      routes: {
        '/login-page': (context) => Homepage(), //หน้าล็อกอิน
        '/user-page-home': (context) =>
            UserPage(), //หน้าเพจผู้ใช้ เรียกรูปภาพ+วิดีโอมาแสดง
      },
    );
  }
}

class FingerprintLogin extends StatefulWidget {
  FingerprintLogin({Key key}) : super(key: key);

  @override
  _FingerprintLoginState createState() => _FingerprintLoginState();
}

class _FingerprintLoginState extends State<FingerprintLogin> {
  // เพิ่มการขอ local auth fingerprint --> android mainfest
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType>
      _availableBiometrics; //list ลายนิ้วมือทั้งหมด --> ต้องตั้งค่าลายนิ้วมือก่อน
  String autherized = "Not autherizes"; //โชว์เมื่อลายนิ้วมือไม่ถูกต้อง

  //ขออนุญาตตรวจสอบลายนิ้วมือ
  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  //When allowed to check our Biometric
  //Get the available biometric sensor on our device
  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }

// scan เพื่อเปิดแอพไปหน้า login
  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: "Scan you finger to authenticate",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      //when user authenticated
      autherized =
          authenticated ? "Autheized sucess" : "Failed  to authenticate";
      if (authenticated) {
        Navigator.pushNamed(context, '/login-page');
      }
      print(autherized);
    });
  }

  _createFolder() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final folderName = "myGallery";
    final path = Directory("storage/emulated/0/$folderName");
    if ((await path.exists())) {
      // TODO:
      print("exist");
    } else {
      // TODO:
      print("not exist");
      path.create();
    }
  }

//เมื่อกดปุ่มฟังก์ชั่นจะทำงาน
  @override
  void initState() {
    // TODO: implement initState
    _createFolder();
    _checkBiometric();
    _getAvailableBiometric();
  }

// -------------------------------------------- หน้า ui ล้วนๆ ---------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///Center(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 120.0),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/fingerprint.png', width: 130.0),
                    Text(
                      "Welcome to Gallery!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          height: 2.5),
                    ),
                    Container(
                      width: 150.0,
                      child: Text(
                        "Scan for open gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, height: 1.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 65.0),
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        color: Color(0xFF131C48),
                        //กดเพื่อ open gallery
                        onPressed: _authenticate,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 24.0),
                          child: Text(
                            "Open Gallery",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
