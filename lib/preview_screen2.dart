import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:policethanya_app/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:policethanya_app/model/location_model.dart';

class PreviewScreen2 extends StatefulWidget {
  final String imgPath;

  PreviewScreen2({this.imgPath});

  @override
  _PreviewScreen2State createState() => _PreviewScreen2State();
}

class _PreviewScreen2State extends State<PreviewScreen2> {
  final firestoreInstance = FirebaseFirestore.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String urlPicture;
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  var day = new DateTime.now();

  @override
  initState() {
    message = "No message.";

    var initializationSettingsAndroid =
        AndroidInitializationSettings('icon_po');

    var initializationSettingsIOS = IOSInitializationSettings(
        // ignore: missing_return
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // ignore: missing_return
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locationModel = Provider.of<LocationModel>(context);
    var latitude = locationModel.latitude;
    var longitude = locationModel.longitude;
    var timestamp = DateFormat.yMMMd().add_jm().format(day);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.file(
                File(widget.imgPath),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60.0,
                color: Colors.black,
                child: Center(
                  child: IconButton(
                    tooltip: 'ยืนยันการปฏิบัติงาน',
                    icon: Icon(
                      Icons.upload_file,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      getBytesFromFile().then((bytes) {
                        uploadPictureToStorage(latitude, longitude);
                        uploadLocation(latitude, longitude);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('อัปโหลดรูปภาพเสร็จสิ้น'),
                                content: Text('วันที่เเละเวลาที่ถ่ายภาพ : ' +
                                    '$timestamp' +
                                    '\nละติจูด : ' +
                                    '$latitude'.toString().split('.')[0] +
                                    '.' +
                                    '$latitude'
                                        .toString()
                                        .split('.')[1]
                                        .substring(0, 5) +
                                    '\nลองจิจูด : ' +
                                    '$longitude'.toString().split('.')[0] +
                                    '.' +
                                    '$longitude'
                                        .toString()
                                        .split('.')[1]
                                        .substring(0, 5)),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('ตกลง'),
                                    onPressed: () {
                                      sendScanNotification();

                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => MainPage()),
                                          (Route<dynamic> route) => false);
                                    },
                                  ),
                                ],
                              );
                            });
                      });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> uploadPictureToStorage(latitude, longitude) async {
    final prefs = await SharedPreferences.getInstance();

    var user = prefs.get('username');
    var rank = prefs.get('rank');
    var name = prefs.get('name');
    var lname = prefs.get('lname');
    var code = prefs.get('code');
    var group = prefs.get('group');
    // var loc = prefs.get('lat_long');
    var checkSec = prefs.get('checkSec');
    var stationname = prefs.get('stationtext');
    var sectionstation = prefs.get('sectiontext');
    var comment = prefs.get('commenttext');

    var day = new DateTime.now();
    var format = new DateFormat.yMd();
    var dateYMD = format.format(day);

    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage storage = FirebaseStorage.instance;
    final storageReference = storage.ref().child('Images/image$i.jpg');
    final storageUploadTask = storageReference.putFile(File(widget.imgPath));
    urlPicture = await (await storageUploadTask.whenComplete(() => {}))
        .ref
        .getDownloadURL();
    print('urlPicture = $urlPicture');

    firestoreInstance
        .collection('alert_qr')
        .add({
          'timestamp': FieldValue.serverTimestamp(),
          'username': user,
          'code': code,
          'group': group,
          'date': dateYMD,
          'worksec': checkSec,
          'name_station': stationname,
          'section_station': sectionstation,
          'comment': comment,
          'urlPicture': urlPicture,
          'rank': rank,
          'name': name,
          'lname': lname,
          'latitude': latitude,
          'longitude': longitude
        })
        .then((value) => {print('add')})
        .catchError((onError) => {print(onError)});
  }

  Future<void> uploadLocation(latitude, longitude) async {
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.get('username');
    var rank = prefs.getString('rank');
    var name = prefs.getString('name');
    var lname = prefs.getString('lname');
    var numuser = 0;

    var day = new DateTime.now();
    var format = new DateFormat.yMd();

    firestoreInstance
        .collection('location_now')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((result) {
                var test = result.get('username');
                if (test == user) {
                  var idcheck = result.id;
                  prefs.setString('idcheck', idcheck);
                  numuser = numuser + 1;
                }
              }),
              if (numuser == 0)
                {
                  firestoreInstance.collection('location_now').add({
                    'latitude': latitude,
                    'longitude': longitude,
                    'rank': rank,
                    'name': name,
                    'lname': lname,
                    'username': user,
                    'timestamp': FieldValue.serverTimestamp(),
                    'date': format.format(day),
                    'status': prefs.getString('statusloc')
                  })
                }
              else if (numuser == 1)
                {
                  firestoreInstance
                      .collection('location_now')
                      .doc(prefs.get('idcheck'))
                      .update({
                    'latitude': latitude,
                    'longitude': longitude,
                    'timestamp': FieldValue.serverTimestamp(),
                    'date': format.format(day),
                    'status': prefs.getString('statusloc'),
                    'rank': rank,
                    'name': name,
                    'lname': lname
                  })
                }
            });
  }

  Future<ByteData> getBytesFromFile() async {
    // ignore: unnecessary_cast
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }

  sendScanNotification() async {
    var timestamp = DateFormat.yMMMd().add_jm().format(day);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        111, 'คุณได้ทำการตรวจเรียบร้อย', '$timestamp', platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }
}
