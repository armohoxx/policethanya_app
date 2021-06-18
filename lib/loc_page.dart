import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:policethanya_app/model/location_model.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocPage extends StatefulWidget {
  @override
  _LocPageState createState() => _LocPageState();
}

class _LocPageState extends State<LocPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Marker> allMarkers = [];
  String username;

  setMarkers() {
    return allMarkers;
  }

  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.get('username');
    });
  }

  GoogleMapController mapController;
  LocationData currentLocation;

  var day = new DateTime.now();
  var format = new DateFormat.yMd();

  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  // @override
  void initState() {
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
    var locationModel = Provider.of<LocationModel>(context);
    double latuser;
    double lnguser;

    if (locationModel != null) {
      setState(() {
        latuser = locationModel.latitude;
        lnguser = locationModel.longitude;
      });
    } else {
      latuser = 14.02113;
      lnguser = 100.73363;
    }

    setState(() {
      getUser();
    });

    return StreamBuilder(
        stream: firestoreInstance
            .collection('location_now')
            .where('date', isEqualTo: format.format(day))
            .where('username', isNotEqualTo: username)
            .snapshots(),
        builder: (context, snapshot) {
          snapshot.hasData
              ? getMarkerDataUser(snapshot)
              : Center(
                  child: CircularProgressIndicator(),
                );

          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red[900],
                title: Center(
                    child: Text(
                  'ตำเเหน่งเจ้าหน้าที่',
                  style: TextStyle(fontSize: 26.0),
                )),
              ),
              body: Container(
                child: Stack(children: <Widget>[
                  Container(
                      child: GoogleMap(
                    markers: allMarkers.toSet(),
                    mapType: MapType.hybrid,
                    compassEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latuser, lnguser),
                      zoom: 15.0,
                    ),
                    onMapCreated: onMapCreated,
                  )),
                  Positioned(
                      top: 7.5,
                      right: 68,
                      child: FlatButton(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.black54,
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            var user = prefs.get('username');
                            var rank = prefs.getString('rank');
                            var name = prefs.getString('name');
                            var lname = prefs.getString('lname');
                            var numuser = 0;

                            sendLocationNotification();

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
                                      if (numuser == 0 &&
                                          prefs.getString('statusloc') ==
                                              'เข้าเวร')
                                        {
                                          firestoreInstance
                                              .collection('location_now')
                                              .add({
                                            'latitude': locationModel.latitude,
                                            'longitude':
                                                locationModel.longitude,
                                            'rank': rank,
                                            'name': name,
                                            'lname': lname,
                                            'username': user,
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                            'date': format.format(day),
                                            'status':
                                                prefs.getString('statusloc')
                                          })
                                        }
                                      else if (numuser == 1 &&
                                          prefs.getString('statusloc') ==
                                              'เข้าเวร')
                                        {
                                          firestoreInstance
                                              .collection('location_now')
                                              .doc(prefs.get('idcheck'))
                                              .update({
                                            'latitude': locationModel.latitude,
                                            'longitude':
                                                locationModel.longitude,
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                            'date': format.format(day),
                                            'status':
                                                prefs.getString('statusloc'),
                                            'rank': rank,
                                            'name': name,
                                            'lname': lname
                                          })
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
                                                      'คุณยังไม่มีการเข้าเวรหรือได้ออกเวรเเล้ว ไม่สามารถส่งตำเเหน่งปัจจุบันได้'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('ตกลง'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              })
                                        }
                                    });
                            // print(latitude);
                            // print(longitude);
                          }))
                ]),
              ));
        });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  getMarkerDataUser(snapshot) {
    for (int i = 0; i < snapshot.data.docs.length; i++) {
      if (snapshot.data.docs[i]['status'] == "เข้าเวร" &&
          snapshot.data.docs[i]['username'] != username) {
        allMarkers.add(new Marker(
            markerId: MarkerId(snapshot.data.docs[i].id),
            position: new LatLng(snapshot.data.docs[i]['latitude'],
                snapshot.data.docs[i]['longitude']),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: snapshot.data.docs[i]['rank'] +
                    '' +
                    snapshot.data.docs[i]['name'] +
                    ' ' +
                    snapshot.data.docs[i]['lname'],
                snippet: 'Lat: ' +
                    snapshot.data.docs[i]['latitude'].toString() +
                    '  ' +
                    'Long: ' +
                    snapshot.data.docs[i]['longitude'].toString())));
      }
    }
  }

  sendLocationNotification() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('statusloc') == 'เข้าเวร') {
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
          'คุณได้ทำการส่งตำเเหน่งปัจจุบันเรียบร้อย',
          '$timestamp',
          platformChannelSpecifics,
          payload: 'I just haven\'t Met You Yet');
    } else {
      print('hi');
    }
  }
}
