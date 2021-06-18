import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:policethanya_app/camera_screen2.dart';

class CommentPage extends StatefulWidget {
  CommentPage({Key key}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String stationtext;
  String sectiontext;
  String commenttext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Center(
            child: Text('เเจ้งคิวอาร์โค้ดชำรุด/สูญหาย',
                style: TextStyle(
                  fontSize: 23.0,
                ))),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (valuestationtext) {
                    stationtext = valuestationtext.trim();
                  },
                  decoration: InputDecoration(
                      errorStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(Icons.home_work),
                      labelText: 'ชื่อสถานที่',
                      labelStyle: TextStyle(fontSize: 16.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (valuesectiontext) {
                    sectiontext = valuesectiontext.trim();
                  },
                  decoration: InputDecoration(
                      errorStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(Icons.add_road),
                      labelText: 'เขตตรวจที่',
                      labelStyle: TextStyle(fontSize: 16.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (valuecommenttext) {
                    commenttext = valuecommenttext.trim();
                  },
                  decoration: InputDecoration(
                      errorStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(Icons.article_rounded),
                      labelText: 'สาเหตุ',
                      labelStyle: TextStyle(fontSize: 16.0),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('stationtext', stationtext);
                        prefs.setString('sectiontext', sectiontext);
                        prefs.setString('commenttext', commenttext);

                        if (stationtext == null ||
                            stationtext.isEmpty ||
                            sectiontext == null ||
                            sectiontext.isEmpty ||
                            commenttext == null ||
                            commenttext.isEmpty) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('เเจ้งเตือน'),
                                  content: Text('กรุณากรอกข้อมูลให้ครบ'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('เเจ้งเตือน'),
                                  content:
                                      Text('คุณต้องการเเจ้งเรื่องใช่หรือไม่'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ยืนยัน'),
                                      onPressed: () {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('เเจ้งเตือน'),
                                                content: Text(
                                                    'เเจ้งเรื่องเรียบร้อย'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('ตกลง'),
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CameraScreen2()));
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('ยกเลิก'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      color: Colors.white,
                      child: Text(
                        'ส่งเเจ้งเรื่องเเละถ่ายรูปยืนยัน',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
