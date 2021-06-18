import 'package:flutter/material.dart';
import 'package:policethanya_app/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:policethanya_app/main_page.dart';
import 'package:policethanya_app/model/location_model.dart';
import 'package:policethanya_app/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('userLogin');
  prefs.setString('status', 'ออกเวร');
  print(user);
  runApp(StreamProvider<LocationModel>(
      create: (_) => LocationService().getStreamData,
      child: MaterialApp(home: user == null ? LoginPage() : MainPage())));
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      title: 'Login app',
    );
  }
}
