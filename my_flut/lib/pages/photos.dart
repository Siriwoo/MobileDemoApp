import 'package:flutter/material.dart';
//import '../components/sidemenu.dart';

class Photos extends StatefulWidget {
  static const routeName = '/photo';

  @override
  State<StatefulWidget> createState() {
    return _PhotosState();
  }
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Photo Screen'),
        ],
      )),
    );
  }
}
