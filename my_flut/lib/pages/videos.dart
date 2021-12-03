import 'package:flutter/material.dart';
//import '../components/sidemenu.dart';

class Videos extends StatefulWidget {
  static const routeName = '/video';

  @override
  State<StatefulWidget> createState() {
    return _VideosState();
  }
}

class _VideosState extends State<Videos> {
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
          Text('Video Screen'),
        ],
      )),
    );
  }
}
