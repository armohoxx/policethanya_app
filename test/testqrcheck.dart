// import 'dart:math';

// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';
// import 'package:location/location.dart';
// import 'package:policethanya_app/camera_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class QrPage extends StatefulWidget {
//   @override
//   _QrPageState createState() => _QrPageState();
// }

// class _QrPageState extends State<QrPage> {
//   String result = "สแกนฉันสิ !";
//   final firestoreInstance = FirebaseFirestore.instance;
//   double lat1, lng1, lat2, lng2, distance;

//   @override
//   void initState() {
//     super.initState();
//     findLatlng1();
//   }

//   Future<Null> findLatlng1() async {
//     final prefs = await SharedPreferences.getInstance();
//     LocationData locationData = await findLocationDataUser();
//     setState(() {
//       var lat1str = locationData.latitude.toString().split('.')[0] +
//           "." +
//           locationData.latitude.toString().split('.')[1].substring(0, 5);
//       var lng1str = locationData.longitude.toString().split('.')[0] +
//           "." +
//           locationData.longitude.toString().split('.')[1].substring(0, 5);
//       lat1 = double.parse(lat1str);
//       lng1 = double.parse(lng1str);
//       lat2 = prefs.getDouble('latitude_station');
//       lng2 = prefs.getDouble('longitude_station');
//       print("$lat1" + ' , ' + "$lng1");
//       distance = double.parse((calculateDistance(lat1, lng1, lat2, lng2))
//               .toString()
//               .substring(0, 5)) *
//           1000;
//     });
//   }

//   double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
//     double distance = 0;

//     var p = 0.017453292519943295; // ค่า pi/180
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
//     distance = 12742 * asin(sqrt(a));

//     return distance;
//   }

//   Future<LocationData> findLocationDataUser() async {
//     Location location = Location();
//     try {
//       return await location.getLocation();
//     } catch (e) {
//       return null;
//     }
//   }

//   Future _scanQR() async {
//     final prefs = await SharedPreferences.getInstance();
//     var onTimecheck = prefs.getString('onTime');
//     print('distance : ' + '$distance');

//     if (onTimecheck == "ตรงเวลา" || onTimecheck == "สาย") {
//       // if (distance <= 30) {
//       // } else {}
//       try {
//         String qrResult = await BarcodeScanner.scan();

//         if (qrResult != null && qrResult.split(',')[10] != null) {
//           prefs.setDouble(
//               'latitude_station', double.parse(qrResult.split(',')[2]));
//           prefs.setDouble(
//               'longitude_station', double.parse(qrResult.split(',')[3]));

//           showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text('เเจ้งเตือน'),
//                   content: Text('สแกนคิวอาร์โค้ดเรียบร้อย ' +
//                       "\nชื่อสถานที่ : " +
//                       '$qrResult'.split(',')[0] +
//                       "\nเขต : " +
//                       '$qrResult'.split(',')[1] +
//                       '\nตำบล : ' +
//                       '$qrResult'.split(',')[7] +
//                       '\nอำเภอ : ' +
//                       '$qrResult'.split(',')[8] +
//                       '\nจังหวัด : ' +
//                       '$qrResult'.split(',')[9] +
//                       '\nรหัสไปรษณีย์ : ' +
//                       '$qrResult'.split(',')[10]),
//                   actions: <Widget>[
//                     FlatButton(
//                       child: Text('ตกลง'),
//                       onPressed: () {
//                         prefs.setString('lat_long', qrResult);

//                         Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => CameraScreen()));
//                       },
//                     ),
//                     FlatButton(
//                       child: Text('ยกเลิก'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 );
//               });
//         } else {
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text('เเจ้งเตือน'),
//                   content: Text('สแกนคิวอาร์โค้ดไม่ถูกต้อง'),
//                   actions: <Widget>[
//                     FlatButton(
//                       child: Text('ตกลง'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 );
//               });
//         }
//       } on PlatformException catch (ex) {
//         if (ex.code == BarcodeScanner.CameraAccessDenied) {
//           // result = "Camera permission was denied";
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text('เเจ้งเตือน'),
//                   content: Text('สแกนคิวอาร์โค้ดไม่ถูกต้อง'),
//                   actions: <Widget>[
//                     FlatButton(
//                       child: Text('ตกลง'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 );
//               });
//         } else {
//           setState(() {
//             // result = "Unknown Error $ex";
//             showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: Text('เเจ้งเตือน'),
//                     content: Text('สแกนคิวอาร์โค้ดไม่ถูกต้อง'),
//                     actions: <Widget>[
//                       FlatButton(
//                         child: Text('ตกลง'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 });
//           });
//         }
//       }
//       // on FormatException {
//       //   setState(() {
//       //     result = "You pressed the back button before scaning anything";
//       //   });
//       // } catch (ex) {
//       //   setState(() {
//       //     result = "Unknown Error $ex";
//       //   });
//       // }
//     } else {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Text('เเจ้งเตือน'),
//               content: Text('กรุณาลงชื่อเข้าเวรก่อนปฏิบัติงาน'),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text('ตกลง'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red[900],
//         title: Center(
//           child: Text(
//             'สเเกนคิวอาร์โค้ด',
//             style: TextStyle(
//               fontSize: 26.0,
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 180,
//                   ),
//                   Text(
//                     result,
//                     style: new TextStyle(fontSize: 30.0),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Stack(
//                     children: <Widget>[
//                       Container(
//                         width: 200,
//                         height: 200,
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 width: 0,
//                                 color:
//                                     Theme.of(context).scaffoldBackgroundColor),
//                             shape: BoxShape.rectangle,
//                             image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage('assets/images/qr.png'))),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 222.5,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         icon: Icon(Icons.camera_alt),
//         label: Text('สเเกนคิวอาร์โค้ด'),
//         onPressed: _scanQR,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
