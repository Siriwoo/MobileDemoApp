import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//หน้าล็อกอิน user

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<Homepage> {
  //functionwhen clk at icon button
  String _mypassword;
  String checkPassword;
  String login_user = 'Not have any user';
  var _getpassword = TextEditingController();

  void _getMyPassword() {
    if (_mypassword == null) {
      _mypassword = _getpassword.text;
    }
  }

  void _checkEmpty(password) {
    if (_mypassword == null) {
      _mypassword = checkPassword;
    }
  }

  void _loginComplete() {
    bool userLogin = false;
    if (_getpassword.text == null) {
      userLogin = false;
    }
    checkPassword = _getpassword.text;
    _checkEmpty(checkPassword);
    try {
      userLogin = (checkPassword == _mypassword);
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      //when user authenticated
      login_user = userLogin ? "Login sucess" : "Failed  to login";
      if (userLogin) {
        Navigator.pushNamed(context, '/user-page-home');
      }
      print(login_user);
    });
  }

  //----------------------------------- หน้า ui -----------------------------------------//

  @override
  Widget build(BuildContext context) {
    //Scaffold คือโครงสร้าง
    return Scaffold(
      body: Container(
        color: Colors.indigo[900],
        alignment: Alignment.center,
        margin: MediaQuery.of(context).padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(),
            Container(
              child: Icon(
                Icons.account_box_rounded,
                size: 120.0,
                color: Color(0xFFD6DAE9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: TextField(
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white38),
                    labelText: 'Password...',
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                controller: _getpassword,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color(0xFF0857D6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Text(
                  'ENTER',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _loginComplete();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
