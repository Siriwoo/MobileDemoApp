//import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'videos.dart';
import 'photos.dart';

//หน้า Gallery เริ่มต้น (แสดงรูปก่อน)
//UI
//-bottom nev bar <รูป|วิดีโอ> -ปุ่มเพิ่มรูปภาพ
class UserPage extends StatefulWidget {
  //static const routeName = '/';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';
  File _video;
  ImagePicker picker = ImagePicker();
  File _storedImage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadAssets() async {
    List<Asset> fileList = <Asset>[];
    String error = 'No Error Detected';

    try {
      fileList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: false,
        selectedAssets: images,
        //cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = fileList;
      _error = error;
      //copyFile(images);
      print("-----------------------------------");
      print(images);
      print("-----------------------------------");
    });
  }

  // Future<void> copyFile(asset) async {
  //   List<Asset> list;
  //   //print('Select Photos = ' + list.toString());

  //   final Directory extDir = await getApplicationDocumentsDirectory();
  //   String dirPath = extDir.path;
  //   String folderName = "myGallery";
  //   final String filePath = 'storage/emulated/0/$folderName';
  //   var directory = new File(filePath);

  //   FileUtils.copyDirectory(asset,directory);

  //   setState(() {
  //   });
  // }

  _pickVideo() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
    print('Selected a video');
    File video = File(pickedFile.path);

    //_video = File(pickedFile.path);

    setState(() {
      _video = video;
      if (_video != null) {
        print('OK next step!!!');
      } else {
        print('No object!');
      }
      //_error = error;
    });

    //ได้ไฟล์แล้วเอาไปเข้ารหัสก่อนย้าย
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _pageWidget = <Widget>[
    Photos(),
    Videos(),
  ];
  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.image),
      label: 'Photos',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.video),
      label: 'Videos',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//------------------------------------------------------------------ UI ข้างล่างนี้ ------------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pageWidget.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      //------ UI ปุ่มเพิ่มรูปภาพ+วิดีโอ ------//
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: new Icon(Icons.add),
      ),
    );
  }

// method ปุ่มเพิ่มรูป+วิดีโอ
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.image_outlined),
                  title: new Text('Add Image'),
                  onTap: loadAssets,
                ),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Add Video'),
                  onTap: _pickVideo,
                ),
              ],
            ),
          );
        });
  }
}
