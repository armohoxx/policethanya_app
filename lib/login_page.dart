import 'package:flutter/material.dart';
import 'package:policethanya_app/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final firestoreInstance = FirebaseFirestore.instance;

  String usernametext;
  String passwordtext;
  String nulltext;
  bool _isHidden = true;

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 120.0,
                    ),
                    Text(
                      'A MANAGEMENT SYSTEM FOR POLICE PATROL THANYABURI POLICE STATION',
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    TextFormField(
                      controller: userController,
                      onChanged: (valueusertext) {
                        usernametext = valueusertext.trim();
                      },
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          prefixIcon: Icon(Icons.people),
                          labelText: 'Usename',
                          labelStyle: TextStyle(fontSize: 16.0),
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: passwordController,
                      onChanged: (valuepasswordtext) {
                        passwordtext = valuepasswordtext.trim();
                      },
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          prefixIcon: Icon(Icons.vpn_key),
                          suffixIcon: InkWell(
                            onTap: _toggleVisibility,
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 16.0),
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      onPressed: () => signIn(),
                      color: Colors.white,
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'ลืมรหัสผ่านหรือไม่? ติดต่อเจ้าหน้าที่',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  signIn() async {
    if (usernametext == null ||
        usernametext.isEmpty ||
        passwordtext == null ||
        passwordtext.isEmpty) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('คำเตือน'),
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
      var numcheck = 0;
      firestoreInstance
          .collection('users')
          .get()
          .then((QuerySnapshot querytSnapshot) => {
                querytSnapshot.docs.forEach((result) {
                  if (result.get("username") == usernametext &&
                      result.get("password") == passwordtext) {
                    numcheck++;
                  }
                }),
                if (numcheck == 1)
                  {
                    firestoreInstance
                        .collection('users')
                        .where('username', isEqualTo: usernametext)
                        .where('password', isEqualTo: passwordtext)
                        .get()
                        .then((QuerySnapshot snapshot) => {
                              snapshot.docs.forEach((element) async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('userLogin', usernametext);

                                var user = element.get("username");
                                var password = element.get("password");
                                var rank = element.get("rank");
                                var name = element.get("name");
                                var lname = element.get("lname");
                                var group = element.get("group");
                                var code = element.get("code");

                                prefs.setString('username', user);
                                prefs.setString('rank', rank);
                                prefs.setString('name', name);
                                prefs.setString('lname', lname);
                                prefs.setString('group', group);
                                prefs.setString('code', code);
                                prefs.setString('password', password);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage()));
                              })
                            })
                  }
                else if (numcheck == 0)
                  {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('คำเตือน'),
                            content: Text('ชื่อผู้ใช้ หรือรหัสผ่านไม่ถูกต้อง'),
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
              })
          .catchError((onError) {
        print(onError);
      });
    }
  }
}
