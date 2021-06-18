import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:policethanya_app/model/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DoworksPage extends StatefulWidget {
  @override
  _DoworksPageState createState() => _DoworksPageState();
}

class _DoworksPageState extends State<DoworksPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String user = '';
  String rank = '';
  String name = '';
  String lname = '';
  String group = '';
  String groupWork = '';
  String checkSec = '';
  String checkWork = '';
  String onTime = '';
  String latitude = '';
  String longitude = '';
  String time = '';

  //notification
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  int _value1 = 0;
  int startTimeWork;
  int endTimeWork;
  double startTimeHwork;
  double startTimeMwork;
  double endTimeHwork;
  double endTimeMwork;
  var timeHourNow;
  var timeMinuteNow;
  var timeHM;
  var dateCheck;

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
        // ignore: unnecessary_statements
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Center(
            child: Text('เข้า/ออกเวร',
                style: TextStyle(
                  fontSize: 26.0,
                ))),
      ),
      body: ListView(
        // scrollDirection: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 430,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'โปรดระบุข้อมูลเวรของท่าน',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 13,
                              ),
                              Text(
                                'ผลัด',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.all(15.0),
                              child: DropdownButton(
                                hint: Text('เลือกผลัด'),
                                isExpanded: true,
                                value: _value1,
                                items: [
                                  DropdownMenuItem(
                                    child: Text('เลือกผลัด'),
                                    value: 0,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('ผลัดเช้า'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('ผลัดบ่าย'),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('ผลัดดึก'),
                                    value: 3,
                                  ),
                                ],
                                onChanged: (value) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    _value1 = value;
                                    switch (_value1) {
                                      case 0:
                                        {
                                          startTimeWork = 99;
                                          endTimeWork = 99;
                                          prefs.setInt(
                                              'startTimeWork', startTimeWork);
                                          prefs.setInt(
                                              'endTimeWork', endTimeWork);
                                        }
                                        break;
                                      case 1: //ผลัดเช้า เวลาเป็น 24 ชม.
                                        {
                                          startTimeWork = 8;
                                          startTimeHwork = 08;
                                          startTimeMwork = 01;
                                          endTimeWork = 16;
                                          endTimeHwork = 16;
                                          endTimeMwork = 00;
                                          prefs.setInt(
                                              'startTimeWork', startTimeWork);
                                          prefs.setDouble(
                                              'startTimeHwork', startTimeHwork);
                                          prefs.setDouble(
                                              'startTimeMwork', startTimeMwork);
                                          prefs.setInt(
                                              'endTimeWork', endTimeWork);
                                          prefs.setDouble(
                                              'endTimeHwork', endTimeHwork);
                                          prefs.setDouble(
                                              'endTimeMwork', endTimeMwork);
                                        }
                                        break;
                                      case 2: //ผลัดบ่าย เวลาเป็น 24 ชม.
                                        {
                                          startTimeWork = 16;
                                          startTimeHwork = 16;
                                          startTimeMwork = 01;
                                          endTimeWork = 0;
                                          endTimeHwork = 23; //23
                                          endTimeMwork = 59; //59
                                          prefs.setInt(
                                              'startTimeWork', startTimeWork);
                                          prefs.setDouble(
                                              'startTimeHwork', startTimeHwork);
                                          prefs.setDouble(
                                              'startTimeMwork', startTimeMwork);
                                          prefs.setInt(
                                              'endTimeWork', endTimeWork);
                                          prefs.setDouble(
                                              'endTimeHwork', endTimeHwork);
                                          prefs.setDouble(
                                              'endTimeMwork', endTimeMwork);
                                        }
                                        break;
                                      case 3: //ผลัดดึก เวลาเป็น 24 ชม.
                                        {
                                          startTimeWork = 0;
                                          startTimeHwork = 00;
                                          startTimeMwork = 01;
                                          endTimeWork = 8;
                                          endTimeHwork = 08;
                                          endTimeMwork = 00;
                                          prefs.setInt(
                                              'startTimeWork', startTimeWork);
                                          prefs.setDouble(
                                              'startTimeHwork', startTimeHwork);
                                          prefs.setDouble(
                                              'startTimeMwork', startTimeMwork);
                                          prefs.setInt(
                                              'endTimeWork', endTimeWork);
                                          prefs.setDouble(
                                              'endTimeHwork', endTimeHwork);
                                          prefs.setDouble(
                                              'endTimeMwork', endTimeMwork);
                                        }
                                        break;
                                      default:
                                        {
                                          print('err');
                                        }
                                        break;
                                    }
                                  });
                                },
                              )),
                          Row(
                            children: [
                              SizedBox(
                                width: 13,
                              ),
                              Text(
                                'เวลาเข้าเวร',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.all(15.0),
                              child: DropdownButton(
                                hint: Text('เวลาเข้าเวร'),
                                isExpanded: true,
                                value: _value1,
                                items: [
                                  DropdownMenuItem(
                                    child: Text(' '),
                                    value: 0,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('08:01:00'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('16:01:00'),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('00:01:00'),
                                    value: 3,
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _value1 = value;
                                  });
                                },
                              )),
                          Row(
                            children: [
                              SizedBox(
                                width: 13,
                              ),
                              Text(
                                'เวลาออกเวร',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.all(15.0),
                              child: DropdownButton(
                                hint: Text('เวลาออกเวร'),
                                isExpanded: true,
                                value: _value1,
                                items: [
                                  DropdownMenuItem(
                                    child: Text(' '),
                                    value: 0,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('16:00:00'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('00:00:00'),
                                    value: 2,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('08:00:00'),
                                    value: 3,
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _value1 = value;
                                  });
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  buildLoginWorkCard(),
                  SizedBox(
                    height: 15,
                  ),
                  buildLogoutWorkCard(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card buildLogoutWorkCard() {
    var locationModel = Provider.of<LocationModel>(context);
    return Card(
      color: Colors.red,
      child: ListTile(
          leading: Icon(Icons.logout, color: Colors.white),
          title: Text(
            'ลงชื่อออกจากเวร',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          onTap: () async {
            var day = new DateTime.now();
            var format = new DateFormat.yMd();
            final prefs = await SharedPreferences.getInstance();

            // prefs.remove('onTime');
            // prefs.remove('dateCheck');
            // prefs.remove('checkSec');
            groupWork = prefs.getString('group');
            var user = prefs.get('username');
            var code = prefs.get('code');
            var rank = prefs.getString('rank');
            var name = prefs.getString('name');
            var lname = prefs.getString('lname');

            startTimeHwork = prefs.getDouble('startTimeHwork');
            startTimeMwork = prefs.getDouble('startTimeMwork');
            endTimeHwork = prefs.getDouble('endTimeHwork');
            endTimeMwork = prefs.getDouble('endTimeMwork');

            var dayNow = day.day.toInt();
            var monthNow = day.month.toInt();
            var yearNow = day.year.toInt();
            timeHourNow = day.hour.toDouble(); //เป็นเเบบ 24 ชม. 5 โมง = 17
            timeMinuteNow = day.minute.toDouble(); //เป็นเเบบ 24 ชม. 5 โมง = 17

            firestoreInstance
                .collection('dowork')
                .where("group", isEqualTo: groupWork)
                .where("months", isEqualTo: monthNow)
                .where("years", isEqualTo: yearNow)
                .get()
                .then((QuerySnapshot querySnapshot) => {
                      querySnapshot.docs.forEach((result) {
                        switch ((endTimeWork)) {
                          case 99:
                            {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('เเจ้งเตือน'),
                                      content: Text('กรุณาเลือกผลัด'),
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
                            break;
                          case 16:
                            {
                              String date1 = result.get("datessec1");
                              var month = result.get("months");
                              var year = result.get("years");
                              var datemon = date1.split(",");
                              var dateYMD = format.format(day);
                              var checkSecWork = prefs.getString('checkSec');
                              var numuser = 0;

                              if (checkSecWork == 'ผลัดเช้า') {
                                firestoreInstance
                                    .collection('login_work')
                                    .where('username', isEqualTo: user)
                                    .where("group", isEqualTo: groupWork)
                                    .where("date", isEqualTo: dateYMD)
                                    .where("worksec", isEqualTo: 'ผลัดเช้า')
                                    .get()
                                    .then((QuerySnapshot value) => {
                                          value.docs.forEach((element) {
                                            if (timeHourNow >= endTimeHwork &&
                                                    timeMinuteNow >=
                                                        endTimeMwork ||
                                                timeHourNow > endTimeHwork &&
                                                    timeMinuteNow <=
                                                        endTimeMwork) {
                                              firestoreInstance
                                                  .collection('location_now')
                                                  .get()
                                                  .then((QuerySnapshot
                                                          querySnapshot) =>
                                                      {
                                                        querySnapshot.docs
                                                            .forEach((result) {
                                                          var test = result
                                                              .get('username');

                                                          if (test == user) {
                                                            var idcheck =
                                                                result.id;
                                                            prefs.setString(
                                                                'idcheck',
                                                                idcheck);
                                                            numuser =
                                                                numuser + 1;
                                                          }
                                                        }),
                                                        if (numuser == 0)
                                                          {
                                                            firestoreInstance
                                                                .collection(
                                                                    'location_now')
                                                                .add({
                                                              'latitude':
                                                                  locationModel
                                                                      .latitude,
                                                              'longitude':
                                                                  locationModel
                                                                      .longitude,
                                                              'rank': rank,
                                                              'name': name,
                                                              'lname': lname,
                                                              'username': user,
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                              'date': format
                                                                  .format(day),
                                                              'status':
                                                                  'ออกเวร',
                                                            }).then((val) => {
                                                                      prefs.setString(
                                                                          'statusloc',
                                                                          'ออกเวร')
                                                                    })
                                                          }
                                                        else if (numuser == 1)
                                                          {
                                                            firestoreInstance
                                                                .collection(
                                                                    'location_now')
                                                                .doc(prefs.get(
                                                                    'idcheck'))
                                                                .update({
                                                              'latitude':
                                                                  locationModel
                                                                      .latitude,
                                                              'longitude':
                                                                  locationModel
                                                                      .longitude,
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                              'date': format
                                                                  .format(day),
                                                              'status':
                                                                  'ออกเวร',
                                                              'rank': rank,
                                                              'name': name,
                                                              'lname': lname
                                                            }).then((val) => {
                                                                      prefs.setString(
                                                                          'statusloc',
                                                                          'ออกเวร')
                                                                    })
                                                          }
                                                      });

                                              firestoreInstance
                                                  .collection('logout_work')
                                                  .add({
                                                    'code': code,
                                                    'group': groupWork,
                                                    'worksec': 'ผลัดเช้า',
                                                    'status': 'ออกเวร',
                                                    'timestamp': FieldValue
                                                        .serverTimestamp(),
                                                    'date': format.format(day),
                                                    'rank': rank,
                                                    'name': name,
                                                    'lname': lname,
                                                    'username': user,
                                                    'login_status':
                                                        'ออกเวรเรียบร้อยเเล้ว'
                                                  })
                                                  .then((value) => {
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'เเจ้งเตือน'),
                                                                content: Text(
                                                                    'ทำการออกเวรเรียบร้อยเเล้ว'),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'ตกลง'),
                                                                    onPressed:
                                                                        () {
                                                                      prefs.remove(
                                                                          'checkSec');
                                                                      prefs.remove(
                                                                          'onTime');
                                                                      sendLogoutNotification();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            })
                                                      })
                                                  .catchError((error) => {
                                                        print('Failed: $error')
                                                      });
                                            } else {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('เเจ้งเตือน'),
                                                      content: Text(
                                                          'ยังไม่ถึงเวลาออกเวรของคุณ'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text('ตกลง'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          })
                                        })
                                    .catchError((error) => {print(error)});
                              } else {
                                nodateAlertLogout();
                              }
                            }
                            break;
                          case 0:
                            {
                              String date2 = result.get("datessec2");
                              var month = result.get("months");
                              var year = result.get("years");
                              var datemon = date2.split(",");
                              var dateYMD = format.format(day);
                              var checkSecWork = prefs.getString('checkSec');
                              var numuser = 0;

                              if (checkSecWork == 'ผลัดบ่าย') {
                                firestoreInstance
                                    .collection('login_work')
                                    .where("group", isEqualTo: groupWork)
                                    .where("date", isEqualTo: dateYMD)
                                    .where("worksec", isEqualTo: 'ผลัดบ่าย')
                                    .get()
                                    .then((QuerySnapshot value) => {
                                          value.docs.forEach((element) {
                                            if (timeHourNow >= endTimeHwork &&
                                                    timeMinuteNow >=
                                                        endTimeMwork ||
                                                timeHourNow > endTimeHwork &&
                                                    timeMinuteNow <=
                                                        endTimeMwork) {
                                              firestoreInstance
                                                  .collection('location_now')
                                                  .get()
                                                  .then((QuerySnapshot
                                                          querySnapshot) =>
                                                      {
                                                        querySnapshot.docs
                                                            .forEach((result) {
                                                          var test = result
                                                              .get('username');

                                                          if (test == user) {
                                                            var idcheck =
                                                                result.id;
                                                            prefs.setString(
                                                                'idcheck',
                                                                idcheck);
                                                            numuser =
                                                                numuser + 1;
                                                          }
                                                        }),
                                                        if (numuser == 0)
                                                          {
                                                            firestoreInstance
                                                                .collection(
                                                                    'location_now')
                                                                .add({
                                                              'latitude':
                                                                  locationModel
                                                                      .latitude,
                                                              'longitude':
                                                                  locationModel
                                                                      .longitude,
                                                              'rank': rank,
                                                              'name': name,
                                                              'lname': lname,
                                                              'username': user,
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                              'date': format
                                                                  .format(day),
                                                              'status':
                                                                  'ออกเวร',
                                                            }).then((val) => {
                                                                      prefs.setString(
                                                                          'statusloc',
                                                                          'ออกเวร')
                                                                    })
                                                          }
                                                        else if (numuser == 1)
                                                          {
                                                            firestoreInstance
                                                                .collection(
                                                                    'location_now')
                                                                .doc(prefs.get(
                                                                    'idcheck'))
                                                                .update({
                                                              'latitude':
                                                                  locationModel
                                                                      .latitude,
                                                              'longitude':
                                                                  locationModel
                                                                      .longitude,
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                              'date': format
                                                                  .format(day),
                                                              'status':
                                                                  'ออกเวร',
                                                              'rank': rank,
                                                              'name': name,
                                                              'lname': lname
                                                            }).then((val) => {
                                                                      prefs.setString(
                                                                          'statusloc',
                                                                          'ออกเวร')
                                                                    })
                                                          }
                                                      });

                                              firestoreInstance
                                                  .collection('logout_work')
                                                  .add({
                                                    'code': code,
                                                    'group': groupWork,
                                                    'worksec': 'ผลัดบ่าย',
                                                    'status': 'ออกเวร',
                                                    'timestamp': FieldValue
                                                        .serverTimestamp(),
                                                    'date': format.format(day),
                                                    'rank': rank,
                                                    'name': name,
                                                    'lname': lname,
                                                    'username': user,
                                                    'login_status':
                                                        'ออกเวรเรียบร้อยเเล้ว'
                                                  })
                                                  .then((value) => {
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'เเจ้งเตือน'),
                                                                content: Text(
                                                                    'ทำการออกเวรเรียบร้อยเเล้ว'),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'ตกลง'),
                                                                    onPressed:
                                                                        () {
                                                                      prefs.remove(
                                                                          'checkSec');
                                                                      prefs.remove(
                                                                          'onTime');
                                                                      sendLogoutNotification();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            })
                                                      })
                                                  .catchError((error) => {
                                                        print('Failed: $error')
                                                      });
                                            } else {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('เเจ้งเตือน'),
                                                      content: Text(
                                                          'ยังไม่ถึงเวลาออกเวรของคุณ'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text('ตกลง'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          })
                                        })
                                    .catchError((error) => {print(error)});
                              } else {
                                // prefs.remove('onTime');
                                nodateAlertLogout();
                              }
                            }
                            break;
                          case 8:
                            {
                              String date3 = result.get("datessec3");
                              var month = result.get("months");
                              var year = result.get("years");
                              var datemon = date3.split(",");
                              var dateYMD = format.format(day);
                              var checkSecWork = prefs.getString('checkSec');
                              var numuser = 0;

                              if (checkSecWork == 'ผลัดดึก') {
                                firestoreInstance
                                    .collection('login_work')
                                    .where("group", isEqualTo: groupWork)
                                    .where("date", isEqualTo: dateYMD)
                                    .where("worksec", isEqualTo: 'ผลัดดึก')
                                    .get()
                                    .then((QuerySnapshot value) => {
                                          value.docs.forEach((element) {
                                            if (timeHourNow >= endTimeHwork &&
                                                    timeMinuteNow >=
                                                        endTimeMwork ||
                                                timeHourNow > endTimeHwork &&
                                                    timeMinuteNow <=
                                                        endTimeMwork) {
                                              firestoreInstance
                                                  .collection('location_now')
                                                  .get()
                                                  .then((QuerySnapshot
                                                          querySnapshot) =>
                                                      {
                                                        querySnapshot.docs
                                                            .forEach((result) {
                                                          var test = result
                                                              .get('username');

                                                          if (test == user) {
                                                            var idcheck =
                                                                result.id;
                                                            prefs.setString(
                                                                'idcheck',
                                                                idcheck);
                                                            numuser =
                                                                numuser + 1;
                                                          }
                                                        }),
                                                        if (numuser == 0)
                                                          {
                                                            firestoreInstance
                                                                .collection(
                                                                    'location_now')
                                                                .add({
                                                              'latitude':
                                                                  locationModel
                                                                      .latitude,
                                                              'longitude':
                                                                  locationModel
                                                                      .longitude,
                                                              'rank': rank,
                                                              'name': name,
                                                              'lname': lname,
                                                              'username': user,
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                              'date': format
                                                                  .format(day),
                                                              'status':
                                                                  'ออกเวร',
                                                            }).then((val) => {
                                                                      prefs.setString(
                                                                          'statusloc',
                                                                          'ออกเวร')
                                                                    })
                                                          }
                                                        else if (numuser == 1)
                                                          {
                                                            firestoreInstance
                                                                .collection(
                                                                    'location_now')
                                                                .doc(prefs.get(
                                                                    'idcheck'))
                                                                .update({
                                                              'latitude':
                                                                  locationModel
                                                                      .latitude,
                                                              'longitude':
                                                                  locationModel
                                                                      .longitude,
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                              'date': format
                                                                  .format(day),
                                                              'status':
                                                                  'ออกเวร',
                                                              'rank': rank,
                                                              'name': name,
                                                              'lname': lname
                                                            }).then((val) => {
                                                                      prefs.setString(
                                                                          'statusloc',
                                                                          'ออกเวร')
                                                                    })
                                                          }
                                                      });

                                              firestoreInstance
                                                  .collection('logout_work')
                                                  .add({
                                                    'code': code,
                                                    'group': groupWork,
                                                    'worksec': 'ผลัดดึก',
                                                    'status': 'ออกเวร',
                                                    'timestamp': FieldValue
                                                        .serverTimestamp(),
                                                    'date': format.format(day),
                                                    'rank': rank,
                                                    'name': name,
                                                    'lname': lname,
                                                    'username': user,
                                                    'login_status':
                                                        'ออกเวรเรียบร้อยเเล้ว'
                                                  })
                                                  .then((value) => {
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'เเจ้งเตือน'),
                                                                content: Text(
                                                                    'ทำการออกเวรเรียบร้อยเเล้ว'),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'ตกลง'),
                                                                    onPressed:
                                                                        () {
                                                                      prefs.remove(
                                                                          'checkSec');
                                                                      prefs.remove(
                                                                          'onTime');
                                                                      sendLogoutNotification();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            })
                                                      })
                                                  .catchError((error) => {
                                                        print('Failed: $error')
                                                      });
                                            } else {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('เเจ้งเตือน'),
                                                      content: Text(
                                                          'ยังไม่ถึงเวลาออกเวรของคุณ'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text('ตกลง'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          })
                                        })
                                    .catchError((error) => {print(error)});
                              } else {
                                // prefs.remove('onTime');
                                nodateAlertLogout();
                              }
                            }
                            break;

                          default:
                            {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('เเจ้งเตือน'),
                                      content: Text('กรุณาเลือกผลัด'),
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
                            break;
                        }
                      })
                    });
          }),
    );
  }

  Card buildLoginWorkCard() {
    var locationModel = Provider.of<LocationModel>(context);
    return Card(
      color: Colors.green,
      child: ListTile(
          leading: Icon(Icons.login, color: Colors.white),
          title: Text(
            'ลงชื่อเข้าเวร',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            groupWork = prefs.getString('group');

            var day = new DateTime.now();
            var format = new DateFormat.yMd();
            var user = prefs.get('username');
            var code = prefs.get('code');
            var rank = prefs.getString('rank');
            var name = prefs.getString('name');
            var lname = prefs.getString('lname');

            startTimeHwork = prefs.getDouble('startTimeHwork');
            startTimeMwork = prefs.getDouble('startTimeMwork');
            endTimeHwork = prefs.getDouble('endTimeHwork');
            endTimeMwork = prefs.getDouble('endTimeMwork');

            var dayNow = day.day.toString();
            var monthNow = day.month.toInt();
            var yearNow = day.year.toInt();
            timeHourNow = day.hour.toDouble(); //เป็นเเบบ 24 ชม. 5 โมง = 17
            timeMinuteNow = day.minute.toDouble(); //เป็นเเบบ 24 ชม. 5 โมง = 17
            var numDataLogin = 0;

            firestoreInstance
                .collection('dowork')
                .where("group", isEqualTo: groupWork)
                .where("months", isEqualTo: monthNow)
                .where("years", isEqualTo: yearNow)
                .get()
                .then((QuerySnapshot querySnapshot) => {
                      querySnapshot.docs.forEach((result) {
                        firestoreInstance
                            .collection('login_work')
                            .where('username', isEqualTo: user)
                            .where('date', isEqualTo: format.format(day))
                            .get()
                            .then((QuerySnapshot querySnapshot) => {
                                  querySnapshot.docs.forEach((resultlogin) {
                                    numDataLogin = 1;
                                  }),
                                  if (numDataLogin == 0)
                                    {
                                      doSwitch(
                                          result,
                                          format,
                                          day,
                                          prefs,
                                          dayNow,
                                          monthNow,
                                          yearNow,
                                          code,
                                          locationModel,
                                          user,
                                          rank,
                                          name,
                                          lname,
                                          startTimeHwork,
                                          startTimeMwork,
                                          endTimeHwork,
                                          endTimeMwork,
                                          timeHourNow,
                                          timeMinuteNow)
                                    }
                                  else
                                    {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('เเจ้งเตือน'),
                                              content: Text(
                                                  'วันนี้คุณได้ลงชื่อเข้าเวรไปเรียบร้อยเเล้ว'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('ตกลง'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          })
                                    }
                                });
                      }),
                    });
          }),
    );
  }

  doSwitch(
      result,
      format,
      day,
      prefs,
      dayNow,
      monthNow,
      yearNow,
      code,
      locationModel,
      user,
      rank,
      name,
      lname,
      startTimeHwork,
      startTimeMwork,
      endTimeHwork,
      endTimeMwork,
      timeHourNow,
      timeMinuteNow) {
    switch ((startTimeWork)) {
      case 99:
        {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('เเจ้งเตือน'),
                  content: Text('กรุณาเลือกผลัด'),
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
        break;
      case 8:
        {
          String date1 = result.get("datessec1");
          var month = result.get("months");
          var year = result.get("years");
          var datemon = date1.split(",");
          var dateYMD = format.format(day);
          var onTimecheck = prefs.getString('onTime');
          var dateCheck = prefs.getString('dateCheck');

          if (dateYMD == dateCheck) {
            if (onTimecheck == 'ตรงเวลา' || onTimecheck == 'สาย') {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('เเจ้งเตือน'),
                      content: Text('คุณได้ทำการเข้าเวรไปเเล้ว'),
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
                      content: Text('วันนี้คุณได้ทำการเข้าเวรไปเเล้ว'),
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
          } else {
            if (datemon.contains(dayNow) &&
                monthNow == month &&
                yearNow == year) {
              if (timeHourNow == startTimeHwork && timeMinuteNow == 01) {
                Timestamp stampNow = Timestamp.now();
                int secNow = stampNow.seconds;
                int yesterday = secNow;
                int numyes = 0;

                for (var loop = 0; loop <= 7; loop++) {
                  yesterday = yesterday - 86400;
                  int numlogdatayes = 0;
                  var yesMilli2 =
                      DateTime.fromMillisecondsSinceEpoch(yesterday * 1000);
                  var dateYes2 = format.format(yesMilli2);
                  firestoreInstance
                      .collection('login_work')
                      .where('username', isEqualTo: user)
                      .get()
                      .then((QuerySnapshot snap) => {
                            snap.docs.forEach((element) {
                              if (element.get('date') == dateYes2.toString()) {
                                numyes = 1;
                                print(element.get('date'));
                                print(dateYes2.toString());
                              }
                              if (element.get('username') == user) {
                                numlogdatayes++;
                              }
                            }),
                            print("-----------"),
                            print(numyes),
                            print(numlogdatayes),
                            print("-----------"),
                            if (numyes == 0 && numlogdatayes > 1)
                              {
                                numlogdatayes = 0,
                                firestoreInstance.collection('login_work').add({
                                  'code': code,
                                  'group': groupWork,
                                  'worksec': 'ผลัดเช้า',
                                  'status': 'ขาดงาน',
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'date': dateYes2,
                                  'rank': rank,
                                  'name': name,
                                  'lname': lname,
                                  'username': user,
                                  'login_status': 'ขาด'
                                }).then((value) => {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('เเจ้งเตือน'),
                                              content: Text(
                                                  'ไม่พบประวัติการเข้าเวรวันที่ ' +
                                                      dateYes2 +
                                                      ' ระบบจะทำการบันทึกการขาดเวร'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('ตกลง'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          })
                                    }),
                              }
                          });
                }

                var numusergps = 0;

                firestoreInstance
                    .collection('location_now')
                    .get()
                    .then((QuerySnapshot querySnapshot) => {
                          querySnapshot.docs.forEach((result2) {
                            var test = result2.get('username');

                            if (test == user) {
                              var idcheck = result2.id;
                              prefs.setString('idcheck', idcheck);
                              numusergps = 1;
                            }
                          }),
                          if (numusergps == 0)
                            {
                              firestoreInstance.collection('location_now').add({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'rank': rank,
                                'name': name,
                                'lname': lname,
                                'username': user,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                              }).then((val) =>
                                  {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                          else if (numusergps == 1)
                            {
                              firestoreInstance
                                  .collection('location_now')
                                  .doc(prefs.get('idcheck'))
                                  .update({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                                'rank': rank,
                                'name': name,
                                'lname': lname
                              }).then((val) =>
                                      {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                        });

                firestoreInstance
                    .collection('login_work')
                    .add({
                      'code': code,
                      'group': groupWork,
                      'worksec': 'ผลัดเช้า',
                      'status': 'ตรงเวลา',
                      'timestamp': FieldValue.serverTimestamp(),
                      'date': format.format(day),
                      'rank': rank,
                      'name': name,
                      'lname': lname,
                      'username': user,
                      'login_status': 'กำลังเข้าเวร'
                    })
                    .then((value) => {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('เเจ้งเตือน'),
                                  content: Text('ทำการเข้าเวรเรียบร้อยเเล้ว'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        sendLoginNotification();

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }),
                          firestoreInstance
                              .collection('login_work')
                              .where("group", isEqualTo: groupWork)
                              .where("date", isEqualTo: dateYMD)
                              .get()
                              .then((QuerySnapshot query) => {
                                    query.docs.forEach((arm) {
                                      checkWork = arm.get('worksec');
                                      onTime = arm.get('status');
                                      dateCheck = arm.get('date');

                                      prefs.setString('checkSec', checkWork);
                                      prefs.setString('onTime', onTime);
                                      prefs.setString('dateCheck', dateCheck);
                                    })
                                  })
                        })
                    .catchError((error) => {print('Failed: $error')});
              } else if (timeHourNow == startTimeHwork &&
                      timeMinuteNow > 02 &&
                      timeMinuteNow <= 59 ||
                  timeHourNow >= startTimeHwork + 1 &&
                      timeHourNow <= startTimeHwork + 7) {
                Timestamp stampNow = Timestamp.now();
                int secNow = stampNow.seconds;
                int yesterday = secNow;
                int numyes = 0;
                for (var loop = 0; loop <= 7; loop++) {
                  yesterday = yesterday - 86400;
                  int numlogdatayes = 0;
                  var yesMilli2 =
                      DateTime.fromMillisecondsSinceEpoch(yesterday * 1000);
                  var dateYes2 = format.format(yesMilli2);
                  firestoreInstance
                      .collection('login_work')
                      .where('username', isEqualTo: user)
                      .get()
                      .then((QuerySnapshot snap) => {
                            snap.docs.forEach((element) {
                              if (element.get('date') == dateYes2.toString()) {
                                numyes = 1;
                                print(element.get('date'));
                                print(dateYes2.toString());
                              }
                              if (element.get('username') == user) {
                                numlogdatayes++;
                              }
                            }),
                            print("-----------"),
                            print(numyes),
                            print(numlogdatayes),
                            print("-----------"),
                            if (numyes == 0 && numlogdatayes > 1)
                              {
                                numlogdatayes = 0,
                                firestoreInstance.collection('login_work').add({
                                  'code': code,
                                  'group': groupWork,
                                  'worksec': 'ผลัดเช้า',
                                  'status': 'ขาดงาน',
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'date': dateYes2,
                                  'rank': rank,
                                  'name': name,
                                  'lname': lname,
                                  'username': user,
                                  'login_status': 'ขาด'
                                }).then((value) => {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('เเจ้งเตือน'),
                                              content: Text(
                                                  'ไม่พบประวัติการเข้าเวรวันที่ ' +
                                                      dateYes2 +
                                                      ' ระบบจะทำการบันทึกการขาดเวร'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('ตกลง'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          })
                                    }),
                              }
                          });
                }

                var numusergps = 0;

                firestoreInstance
                    .collection('location_now')
                    .get()
                    .then((QuerySnapshot querySnapshot) => {
                          querySnapshot.docs.forEach((result2) {
                            var test = result2.get('username');

                            if (test == user) {
                              var idcheck = result2.id;
                              prefs.setString('idcheck', idcheck);
                              numusergps = 1;
                            }
                          }),
                          if (numusergps == 0)
                            {
                              firestoreInstance.collection('location_now').add({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'rank': rank,
                                'name': name,
                                'lname': lname,
                                'username': user,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                              }).then((val) =>
                                  {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                          else if (numusergps == 1)
                            {
                              firestoreInstance
                                  .collection('location_now')
                                  .doc(prefs.get('idcheck'))
                                  .update({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                                'rank': rank,
                                'name': name,
                                'lname': lname
                              }).then((val) =>
                                      {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                        });

                firestoreInstance
                    .collection('login_work')
                    .add({
                      'code': code,
                      'group': groupWork,
                      'worksec': 'ผลัดเช้า',
                      'status': 'สาย',
                      'timestamp': FieldValue.serverTimestamp(),
                      'date': format.format(day),
                      'rank': rank,
                      'name': name,
                      'lname': lname,
                      'username': user,
                      'login_status': 'กำลังเข้าเวร'
                    })
                    .then((value) => {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('เเจ้งเตือน'),
                                  content: Text('ทำการเข้าเวรเรียบร้อยเเล้ว'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        sendLoginNotification();

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }),
                          firestoreInstance
                              .collection('login_work')
                              .where("group", isEqualTo: groupWork)
                              .where("date", isEqualTo: dateYMD)
                              .get()
                              .then((QuerySnapshot query) => {
                                    query.docs.forEach((arm) {
                                      checkWork = arm.get('worksec');
                                      onTime = arm.get('status');
                                      dateCheck = arm.get('date');

                                      prefs.setString('checkSec', checkWork);
                                      prefs.setString('onTime', onTime);
                                      prefs.setString('dateCheck', dateCheck);
                                    })
                                  })
                        })
                    .catchError((error) => {print('Failed: $error')});
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('เเจ้งเตือน'),
                        content: Text('ยังไม่ถึงเวลา หรือเลยเวลาเข้าเวรเเล้ว'),
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
            } else {
              nodateAlertLogin();
            }
          }
        }

        break;
      case 16:
        {
          String date2 = result.get("datessec2");
          var month = result.get("months");
          var year = result.get("years");
          var datemon = date2.split(",");
          var dateYMD = format.format(day);
          var onTimecheck = prefs.getString('onTime');
          var dateCheck = prefs.getString('dateCheck');

          if (dateYMD == dateCheck) {
            if (onTimecheck == 'ตรงเวลา' || onTimecheck == 'สาย') {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('เเจ้งเตือน'),
                      content: Text('คุณได้ทำการเข้าเวรไปเเล้ว'),
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
                      content: Text('วันนี้คุณได้ทำการเข้าเวรไปเเล้ว'),
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
          } else {
            if (datemon.contains(dayNow) &&
                monthNow == month &&
                yearNow == year) {
              if (timeHourNow == startTimeHwork && timeMinuteNow == 01) {
                Timestamp stampNow = Timestamp.now();
                int secNow = stampNow.seconds;
                int yesterday = secNow;
                int numyes = 0;

                for (var loop = 0; loop <= 7; loop++) {
                  yesterday = yesterday - 86400;
                  int numlogdatayes = 0;
                  var yesMilli2 =
                      DateTime.fromMillisecondsSinceEpoch(yesterday * 1000);
                  var dateYes2 = format.format(yesMilli2);
                  firestoreInstance
                      .collection('login_work')
                      .where('username', isEqualTo: user)
                      .get()
                      .then((QuerySnapshot snap) => {
                            snap.docs.forEach((element) {
                              if (element.get('date') == dateYes2.toString()) {
                                numyes = 1;
                                print(element.get('date'));
                                print(dateYes2.toString());
                              }
                              if (element.get('username') == user) {
                                numlogdatayes++;
                              }
                            }),
                            print("-----------"),
                            print(numyes),
                            print(numlogdatayes),
                            print("-----------"),
                            if (numyes == 0 && numlogdatayes > 1)
                              {
                                numlogdatayes = 0,
                                firestoreInstance.collection('login_work').add({
                                  'code': code,
                                  'group': groupWork,
                                  'worksec': 'ผลัดบ่าย',
                                  'status': 'ขาดงาน',
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'date': dateYes2,
                                  'rank': rank,
                                  'name': name,
                                  'lname': lname,
                                  'username': user,
                                  'login_status': 'ขาด'
                                }).then((value) => {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('เเจ้งเตือน'),
                                              content: Text(
                                                  'ไม่พบประวัติการเข้าเวรวันที่ ' +
                                                      dateYes2 +
                                                      ' ระบบจะทำการบันทึกการขาดเวร'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('ตกลง'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          })
                                    }),
                              }
                          });
                }

                var numusergps = 0;

                firestoreInstance
                    .collection('location_now')
                    .get()
                    .then((QuerySnapshot querySnapshot) => {
                          querySnapshot.docs.forEach((result2) {
                            var test = result2.get('username');

                            if (test == user) {
                              var idcheck = result2.id;
                              prefs.setString('idcheck', idcheck);
                              numusergps = 1;
                            }
                          }),
                          if (numusergps == 0)
                            {
                              firestoreInstance.collection('location_now').add({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'rank': rank,
                                'name': name,
                                'lname': lname,
                                'username': user,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                              }).then((val) =>
                                  {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                          else if (numusergps == 1)
                            {
                              firestoreInstance
                                  .collection('location_now')
                                  .doc(prefs.get('idcheck'))
                                  .update({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                                'rank': rank,
                                'name': name,
                                'lname': lname
                              }).then((val) =>
                                      {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                        });

                firestoreInstance
                    .collection('login_work')
                    .add({
                      'code': code,
                      'group': groupWork,
                      'worksec': 'ผลัดบ่าย',
                      'status': 'ตรงเวลา',
                      'timestamp': FieldValue.serverTimestamp(),
                      'date': format.format(day),
                      'rank': rank,
                      'name': name,
                      'lname': lname,
                      'username': user,
                      'login_status': 'กำลังเข้าเวร'
                    })
                    .then((value) => {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('เเจ้งเตือน'),
                                  content: Text('ทำการเข้าเวรเรียบร้อยเเล้ว'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        sendLoginNotification();

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }),
                          firestoreInstance
                              .collection('login_work')
                              .where("group", isEqualTo: groupWork)
                              .where("date", isEqualTo: dateYMD)
                              .get()
                              .then((QuerySnapshot query) => {
                                    query.docs.forEach((arm) {
                                      checkWork = arm.get('worksec');
                                      onTime = arm.get('status');
                                      dateCheck = arm.get('date');

                                      prefs.setString('checkSec', checkWork);
                                      prefs.setString('onTime', onTime);
                                      prefs.setString('dateCheck', dateCheck);
                                    })
                                  })
                        })
                    .catchError((error) => {print('Failed: $error')});
              } else if (timeHourNow == startTimeHwork &&
                      timeMinuteNow > 02 &&
                      timeMinuteNow <= 59 ||
                  timeHourNow >= startTimeHwork + 1 &&
                      timeHourNow <= startTimeHwork + 7) {
                Timestamp stampNow = Timestamp.now();
                int secNow = stampNow.seconds;
                int yesterday = secNow;
                int numyes = 0;
                for (var loop = 0; loop <= 7; loop++) {
                  yesterday = yesterday - 86400;
                  int numlogdatayes = 0;
                  var yesMilli2 =
                      DateTime.fromMillisecondsSinceEpoch(yesterday * 1000);
                  var dateYes2 = format.format(yesMilli2);
                  firestoreInstance
                      .collection('login_work')
                      .where('username', isEqualTo: user)
                      .get()
                      .then((QuerySnapshot snap) => {
                            snap.docs.forEach((element) {
                              if (element.get('date') == dateYes2.toString()) {
                                numyes = 1;
                                print(element.get('date'));
                                print(dateYes2.toString());
                              }
                              if (element.get('username') == user) {
                                numlogdatayes++;
                              }
                            }),
                            print("-----------"),
                            print(numyes),
                            print(numlogdatayes),
                            print("-----------"),
                            if (numyes == 0 && numlogdatayes > 1)
                              {
                                numlogdatayes = 0,
                                firestoreInstance.collection('login_work').add({
                                  'code': code,
                                  'group': groupWork,
                                  'worksec': 'ผลัดบ่าย',
                                  'status': 'ขาดงาน',
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'date': dateYes2,
                                  'rank': rank,
                                  'name': name,
                                  'lname': lname,
                                  'username': user,
                                  'login_status': 'ขาด'
                                }).then((value) => {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('เเจ้งเตือน'),
                                              content: Text(
                                                  'ไม่พบประวัติการเข้าเวรวันที่ ' +
                                                      dateYes2 +
                                                      ' ระบบจะทำการบันทึกการขาดเวร'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('ตกลง'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          })
                                    }),
                              }
                          });
                }

                var numusergps = 0;

                firestoreInstance
                    .collection('location_now')
                    .get()
                    .then((QuerySnapshot querySnapshot) => {
                          querySnapshot.docs.forEach((result2) {
                            var test = result2.get('username');

                            if (test == user) {
                              var idcheck = result2.id;
                              prefs.setString('idcheck', idcheck);
                              numusergps = 1;
                            }
                          }),
                          if (numusergps == 0)
                            {
                              firestoreInstance.collection('location_now').add({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'rank': rank,
                                'name': name,
                                'lname': lname,
                                'username': user,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                              }).then((val) =>
                                  {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                          else if (numusergps == 1)
                            {
                              firestoreInstance
                                  .collection('location_now')
                                  .doc(prefs.get('idcheck'))
                                  .update({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                                'rank': rank,
                                'name': name,
                                'lname': lname
                              }).then((val) =>
                                      {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                        });

                firestoreInstance
                    .collection('login_work')
                    .add({
                      'code': code,
                      'group': groupWork,
                      'worksec': 'ผลัดบ่าย',
                      'status': 'สาย',
                      'timestamp': FieldValue.serverTimestamp(),
                      'date': format.format(day),
                      'rank': rank,
                      'name': name,
                      'lname': lname,
                      'username': user,
                      'login_status': 'กำลังเข้าเวร'
                    })
                    .then((value) => {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('เเจ้งเตือน'),
                                  content: Text('ทำการเข้าเวรเรียบร้อยเเล้ว'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        sendLoginNotification();

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }),
                          firestoreInstance
                              .collection('login_work')
                              .where("group", isEqualTo: groupWork)
                              .where("date", isEqualTo: dateYMD)
                              .get()
                              .then((QuerySnapshot query) => {
                                    query.docs.forEach((arm) {
                                      checkWork = arm.get('worksec');
                                      onTime = arm.get('status');
                                      dateCheck = arm.get('date');

                                      prefs.setString('checkSec', checkWork);
                                      prefs.setString('onTime', onTime);
                                      prefs.setString('dateCheck', dateCheck);
                                    })
                                  })
                        })
                    .catchError((error) => {print('Failed: $error')});
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('เเจ้งเตือน'),
                        content: Text('ยังไม่ถึงเวลา หรือเลยเวลาเข้าเวรเเล้ว'),
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
            } else {
              nodateAlertLogin();
            }
          }
        }
        break;
      case 0:
        {
          String date3 = result.get("datessec3");
          var month = result.get("months");
          var year = result.get("years");
          var datemon = date3.split(",");
          var dateYMD = format.format(day);
          var onTimecheck = prefs.getString('onTime');
          var dateCheck = prefs.getString('dateCheck');

          if (dateYMD == dateCheck) {
            if (onTimecheck == 'ตรงเวลา' || onTimecheck == 'สาย') {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('เเจ้งเตือน'),
                      content: Text('คุณได้ทำการเข้าเวรไปเเล้ว'),
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
                      content: Text('วันนี้คุณได้ทำการเข้าเวรไปเเล้ว'),
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
          } else {
            if (datemon.contains(dayNow) &&
                monthNow == month &&
                yearNow == year) {
              if (timeHourNow == startTimeHwork && timeMinuteNow == 01) {
                Timestamp stampNow = Timestamp.now();
                int secNow = stampNow.seconds;
                int yesterday = secNow;
                int numyes = 0;

                for (var loop = 0; loop <= 7; loop++) {
                  yesterday = yesterday - 86400;
                  int numlogdatayes = 0;
                  var yesMilli2 =
                      DateTime.fromMillisecondsSinceEpoch(yesterday * 1000);
                  var dateYes2 = format.format(yesMilli2);
                  firestoreInstance
                      .collection('login_work')
                      .where('username', isEqualTo: user)
                      .get()
                      .then((QuerySnapshot snap) => {
                            snap.docs.forEach((element) {
                              if (element.get('date') == dateYes2.toString()) {
                                numyes = 1;
                                print(element.get('date'));
                                print(dateYes2.toString());
                              }
                              if (element.get('username') == user) {
                                numlogdatayes++;
                              }
                            }),
                            print("-----------"),
                            print(numyes),
                            print(numlogdatayes),
                            print("-----------"),
                            if (numyes == 0 && numlogdatayes > 1)
                              {
                                numlogdatayes = 0,
                                firestoreInstance.collection('login_work').add({
                                  'code': code,
                                  'group': groupWork,
                                  'worksec': 'ผลัดดึก',
                                  'status': 'ขาดงาน',
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'date': dateYes2,
                                  'rank': rank,
                                  'name': name,
                                  'lname': lname,
                                  'username': user,
                                  'login_status': 'ขาด'
                                }).then((value) => {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('เเจ้งเตือน'),
                                              content: Text(
                                                  'ไม่พบประวัติการเข้าเวรวันที่ ' +
                                                      dateYes2 +
                                                      ' ระบบจะทำการบันทึกการขาดเวร'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('ตกลง'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          })
                                    }),
                              }
                          });
                }

                var numusergps = 0;

                firestoreInstance
                    .collection('location_now')
                    .get()
                    .then((QuerySnapshot querySnapshot) => {
                          querySnapshot.docs.forEach((result2) {
                            var test = result2.get('username');

                            if (test == user) {
                              var idcheck = result2.id;
                              prefs.setString('idcheck', idcheck);
                              numusergps = 1;
                            }
                          }),
                          if (numusergps == 0)
                            {
                              firestoreInstance.collection('location_now').add({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'rank': rank,
                                'name': name,
                                'lname': lname,
                                'username': user,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                              }).then((val) =>
                                  {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                          else if (numusergps == 1)
                            {
                              firestoreInstance
                                  .collection('location_now')
                                  .doc(prefs.get('idcheck'))
                                  .update({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                                'rank': rank,
                                'name': name,
                                'lname': lname
                              }).then((val) =>
                                      {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                        });

                firestoreInstance
                    .collection('login_work')
                    .add({
                      'code': code,
                      'group': groupWork,
                      'worksec': 'ผลัดดึก',
                      'status': 'ตรงเวลา',
                      'timestamp': FieldValue.serverTimestamp(),
                      'date': format.format(day),
                      'rank': rank,
                      'name': name,
                      'lname': lname,
                      'username': user,
                      'login_status': 'กำลังเข้าเวร'
                    })
                    .then((value) => {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('เเจ้งเตือน'),
                                  content: Text('ทำการเข้าเวรเรียบร้อยเเล้ว'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        sendLoginNotification();

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }),
                          firestoreInstance
                              .collection('login_work')
                              .where("group", isEqualTo: groupWork)
                              .where("date", isEqualTo: dateYMD)
                              .get()
                              .then((QuerySnapshot query) => {
                                    query.docs.forEach((arm) {
                                      checkWork = arm.get('worksec');
                                      onTime = arm.get('status');
                                      dateCheck = arm.get('date');

                                      prefs.setString('checkSec', checkWork);
                                      prefs.setString('onTime', onTime);
                                      prefs.setString('dateCheck', dateCheck);
                                    })
                                  })
                        })
                    .catchError((error) => {print('Failed: $error')});
              } else if (timeHourNow == startTimeHwork &&
                      timeMinuteNow > 02 &&
                      timeMinuteNow <= 59 ||
                  timeHourNow >= startTimeHwork + 1 &&
                      timeHourNow <= startTimeHwork + 7) {
                Timestamp stampNow = Timestamp.now();
                int secNow = stampNow.seconds;
                int yesterday = secNow;
                int numyes = 0;
                for (var loop = 0; loop <= 7; loop++) {
                  yesterday = yesterday - 86400;
                  int numlogdatayes = 0;
                  var yesMilli2 =
                      DateTime.fromMillisecondsSinceEpoch(yesterday * 1000);
                  var dateYes2 = format.format(yesMilli2);
                  firestoreInstance
                      .collection('login_work')
                      .where('username', isEqualTo: user)
                      .get()
                      .then((QuerySnapshot snap) => {
                            snap.docs.forEach((element) {
                              if (element.get('date') == dateYes2.toString()) {
                                numyes = 1;
                                print(element.get('date'));
                                print(dateYes2.toString());
                              }
                              if (element.get('username') == user) {
                                numlogdatayes++;
                              }
                            }),
                            print("-----------"),
                            print(numyes),
                            print(numlogdatayes),
                            print("-----------"),
                            if (numyes == 0 && numlogdatayes > 1)
                              {
                                numlogdatayes = 0,
                                firestoreInstance.collection('login_work').add({
                                  'code': code,
                                  'group': groupWork,
                                  'worksec': 'ผลัดดึก',
                                  'status': 'ขาดงาน',
                                  'timestamp': FieldValue.serverTimestamp(),
                                  'date': dateYes2,
                                  'rank': rank,
                                  'name': name,
                                  'lname': lname,
                                  'username': user,
                                  'login_status': 'ขาด'
                                }).then((value) => {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('เเจ้งเตือน'),
                                              content: Text(
                                                  'ไม่พบประวัติการเข้าเวรวันที่ ' +
                                                      dateYes2 +
                                                      ' ระบบจะทำการบันทึกการขาดเวร'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('ตกลง'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          })
                                    }),
                              }
                          });
                }

                var numusergps = 0;

                firestoreInstance
                    .collection('location_now')
                    .get()
                    .then((QuerySnapshot querySnapshot) => {
                          querySnapshot.docs.forEach((result2) {
                            var test = result2.get('username');

                            if (test == user) {
                              var idcheck = result2.id;
                              prefs.setString('idcheck', idcheck);
                              numusergps = 1;
                            }
                          }),
                          if (numusergps == 0)
                            {
                              firestoreInstance.collection('location_now').add({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'rank': rank,
                                'name': name,
                                'lname': lname,
                                'username': user,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                              }).then((val) =>
                                  {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                          else if (numusergps == 1)
                            {
                              firestoreInstance
                                  .collection('location_now')
                                  .doc(prefs.get('idcheck'))
                                  .update({
                                'latitude': locationModel.latitude,
                                'longitude': locationModel.longitude,
                                'timestamp': FieldValue.serverTimestamp(),
                                'date': format.format(day),
                                'status': 'เข้าเวร',
                                'rank': rank,
                                'name': name,
                                'lname': lname
                              }).then((val) =>
                                      {prefs.setString('statusloc', 'เข้าเวร')})
                            }
                        });

                firestoreInstance
                    .collection('login_work')
                    .add({
                      'code': code,
                      'group': groupWork,
                      'worksec': 'ผลัดดึก',
                      'status': 'สาย',
                      'timestamp': FieldValue.serverTimestamp(),
                      'date': format.format(day),
                      'rank': rank,
                      'name': name,
                      'lname': lname,
                      'username': user,
                      'login_status': 'กำลังเข้าเวร'
                    })
                    .then((value) => {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('เเจ้งเตือน'),
                                  content: Text('ทำการเข้าเวรเรียบร้อยเเล้ว'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ตกลง'),
                                      onPressed: () {
                                        sendLoginNotification();

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              }),
                          firestoreInstance
                              .collection('login_work')
                              .where("group", isEqualTo: groupWork)
                              .where("date", isEqualTo: dateYMD)
                              .get()
                              .then((QuerySnapshot query) => {
                                    query.docs.forEach((arm) {
                                      checkWork = arm.get('worksec');
                                      onTime = arm.get('status');
                                      dateCheck = arm.get('date');

                                      prefs.setString('checkSec', checkWork);
                                      prefs.setString('onTime', onTime);
                                      prefs.setString('dateCheck', dateCheck);
                                    })
                                  })
                        })
                    .catchError((error) => {print('Failed: $error')});
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('เเจ้งเตือน'),
                        content: Text('ยังไม่ถึงเวลา หรือเลยเวลาเข้าเวรเเล้ว'),
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
            } else {
              nodateAlertLogin();
            }
          }
        }
        break;

      default:
        {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('เเจ้งเตือน'),
                  content: Text('กรุณาเลือกผลัด'),
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
        break;
    }
  }

  nodateAlertLogin() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เเจ้งเตือน'),
            content: Text('คุณเลือกผลัดไม่ถูกต้อง'),
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

  nodateAlertLogout() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เเจ้งเตือน'),
            content: Text('คุณเลือกผลัดไม่ถูกต้องหรือยังไม่มีการเข้าเวร'),
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

  doWorkLogin() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เเจ้งเตือน'),
            content: Text('ลงชื่อเข้าเวรเรียบร้อยเเล้ว'),
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

  doWorkLogout() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เเจ้งเตือน'),
            content: Text('ลงชื่อออกเวรเรียบร้อยเเล้ว'),
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

  sendLoginNotification() async {
    var day = new DateTime.now();
    var timestamp = DateFormat.yMMMd().add_jm().format(day);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        111,
        'คุณได้ทำการลงชื่อเข้าเวรเรียบร้อย',
        '$timestamp',
        platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }

  sendLogoutNotification() async {
    var day = new DateTime.now();
    var timestamp = DateFormat.yMMMd().add_jm().format(day);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        111,
        'คุณได้ทำการลงชื่อออกเวรเรียบร้อย',
        '$timestamp',
        platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }
}
