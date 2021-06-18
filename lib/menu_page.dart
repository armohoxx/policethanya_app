import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:policethanya_app/alert_page.dart';
import 'package:policethanya_app/doworks_page.dart';
import 'package:policethanya_app/loc_page.dart';
import 'package:policethanya_app/login_page.dart';
import 'package:policethanya_app/qr_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;

  String rank = '';
  String name = '';
  String lname = '';
  String group = '';
  String loginStatus = '';

  void getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rank = prefs.get("rank");
      name = prefs.get("name");
      lname = prefs.get("lname");
      group = prefs.get("group");
    });
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Center(
            child: Text(
              'เมนู',
              style: TextStyle(
                fontSize: 26.0,
              ),
            ),
          ),
        ),
        body: ListView(
          //fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: Card(
                        child: ListTile(
                          autofocus: true,
                          leading: Icon(
                            Icons.person,
                            size: 100,
                          ),
                          title: Text(
                            'สวัสดี !',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '$rank ' +
                                '$name ' +
                                '$lname ' +
                                '\nชุดปฏิบัติการของคุณ : ' +
                                '$group',
                            style:
                                TextStyle(fontSize: 17, color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      child: ListTile(
                          leading: CircleAvatar(child: Icon(Icons.work)),
                          title: Text(
                            'เข้า/ออกเวร',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          onTap: () => doWork()),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Card(
                      child: ListTile(
                          leading: CircleAvatar(child: Icon(Icons.gps_fixed)),
                          title: Text(
                            'ตำเเหน่งเจ้าหน้าที่',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          onTap: () => doLoc()),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Card(
                      child: ListTile(
                          leading:
                              CircleAvatar(child: Icon(Icons.qr_code_scanner)),
                          title: Text(
                            'สแกนคิวอาร์โค้ด',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          onTap: () => doQr()),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Card(
                      child: ListTile(
                          leading:
                              CircleAvatar(child: Icon(Icons.notifications)),
                          title: Text(
                            'การเเจ้งเตือน',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          onTap: () => doAlert()),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Card(
                      child: ListTile(
                          leading: CircleAvatar(child: Icon(Icons.logout)),
                          title: Text(
                            'ออกจากระบบ',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          onTap: () => doLogout()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  doQr() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage()));
  }

  doLoc() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LocPage()));
  }

  doWork() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DoworksPage()));
  }

  doAlert() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AlertPage()));
  }

  doLogout() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ออกจากระบบ'),
            content: Text('คุณต้องการออกจากระบบใช่หรือไม่ ?'),
            actions: <Widget>[
              FlatButton(
                child: Text('ตกลง'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  if (prefs.getString('onTime') == null) {
                    prefs.remove('username');
                    prefs.remove('password');
                    prefs.remove('rank');
                    prefs.remove('name');
                    prefs.remove('lname');
                    prefs.remove('group');
                    prefs.remove('groupWork');
                    prefs.remove('start_time');
                    prefs.remove('end_time');
                    prefs.remove('userLogin');
                    prefs.remove('code');
                    prefs.remove('lat_long');
                    prefs.remove('dateCheck');
                    prefs.remove('checkSec');
                    prefs.remove('statusloc');
                    prefs.remove('stationtext');
                    prefs.remove('sectiontext');
                    prefs.remove('commenttext');

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  } else {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('คำเตือน'),
                            content: Text(
                                'คุณกำลังปฏิบัติหน้าที่ กรุณาลงชื่อออกเวรก่อน'),
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
                  }
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
}
