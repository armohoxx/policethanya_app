import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertPage extends StatefulWidget {
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final firestore = FirebaseFirestore.instance;
  String username;

  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.get('username');
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 10.8),
            tabs: [
              Tab(
                icon: Icon(Icons.login),
                text: 'เข้าเวร',
              ),
              Tab(icon: Icon(Icons.logout), text: 'ออกเวร'),
              Tab(icon: Icon(Icons.work_off), text: 'ขาดเวร'),
              Tab(icon: Icon(Icons.work), text: 'ปฏิบัติงาน'),
              Tab(icon: Icon(Icons.location_on), text: 'ตำเเหน่ง'),
            ],
          ),
          title: Center(
              child: Text(
            'การเเจ้งเตือน',
            style: TextStyle(fontSize: 26.0),
          )),
        ),
        body: TabBarView(
          children: <Widget>[
            StreamBuilder(
                stream: firestore
                    .collection('login_work')
                    .where('username', isEqualTo: username)
                    .where('status', isNotEqualTo: 'ขาดงาน')
                    .where('username', isNotEqualTo: null)
                    .orderBy('status', descending: false)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                  return Scaffold(
                    body: snapshot1.hasData
                        ? buildLoginList(snapshot1.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  );
                }),
            StreamBuilder(
                stream: firestore
                    .collection('logout_work')
                    .where('username', isEqualTo: username)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                  return Scaffold(
                    body: snapshot2.hasData
                        ? buildLogoutList(snapshot2.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  );
                }),
            StreamBuilder(
                stream: firestore
                    .collection('login_work')
                    .where('username', isEqualTo: username)
                    .where('status', isEqualTo: 'ขาดงาน')
                    .where('username', isNotEqualTo: null)
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot3) {
                  return Scaffold(
                    body: snapshot3.hasData
                        ? buildLoginList2(snapshot3.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  );
                }),
            StreamBuilder(
                stream: firestore
                    .collection('log_scan')
                    .where('username', isEqualTo: username)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot4) {
                  return Scaffold(
                    body: snapshot4.hasData
                        ? buildDoworkList(snapshot4.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  );
                }),
            StreamBuilder(
                stream: firestore
                    .collection('location_now')
                    // .orderBy('timestamp', descending: true)
                    .where('username', isEqualTo: username)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot5) {
                  return Scaffold(
                    body: snapshot5.hasData
                        ? buildLocationList(snapshot5.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  );
                }),
          ],
        ),
      ),
    ));
  }

  ListView buildLoginList(QuerySnapshot data) {
    return ListView.builder(
      reverse: false,
      itemCount: data.size,
      itemBuilder: (BuildContext context, int index) {
        var model = data.docs.elementAt(index);
        var timestamp = model['timestamp'].toDate();
        var formattedDate = DateFormat.yMMMd().add_jm().format(timestamp);

        return ListTile(
          title: Text('คุณได้ทำการเข้าเวรเเล้ว'),
          subtitle: Text('ชุดปฏิบัติการของคุณ : ' +
              model['group'] +
              '\nสถานะ : ' +
              model['status']),
          trailing: Text(formattedDate.toString()),
        );
      },
    );
  }

  ListView buildLogoutList(QuerySnapshot data2) {
    return ListView.builder(
      itemCount: data2.size,
      itemBuilder: (BuildContext context, int index) {
        var model = data2.docs.elementAt(index);
        var timestamp = model['timestamp'].toDate();
        var formattedDate = DateFormat.yMMMd().add_jm().format(timestamp);

        return ListTile(
          title: Text('คุณได้ทำการออกเวรเเล้ว'),
          subtitle: Text('ชุดปฏิบัติการของคุณ : ' + model['group']),
          trailing: Text(formattedDate.toString()),
        );
      },
    );
  }

  ListView buildLoginList2(QuerySnapshot data3) {
    return ListView.builder(
      reverse: false,
      itemCount: data3.size,
      itemBuilder: (BuildContext context, int index) {
        var model = data3.docs.elementAt(index);
        var formattedDate = DateFormat.yMMMd();
        var mdyStr = model['date'];
        var dateData = DateFormat('M/d/yyyy').parse(mdyStr);

        return ListTile(
          title: Text('คุณมีการขาดเวร'),
          subtitle: Text('ชุดปฏิบัติการของคุณ : ' + model['group']),
          trailing: Text(formattedDate.format(dateData)),
        );
      },
    );
  }

  ListView buildDoworkList(QuerySnapshot data4) {
    return ListView.builder(
      itemCount: data4.size,
      itemBuilder: (BuildContext context, int index) {
        var model = data4.docs.elementAt(index);
        var timestamp = model['timestamp'].toDate();
        var formattedDate = DateFormat.yMMMd().add_jm().format(timestamp);

        return ListTile(
          title:
              Text(model['lat_long'].split(',')[0] + '\n(ได้รับการตรวจเเล้ว)'),
          subtitle: Text('ชุดปฏิบัติการของคุณ : ' + model['group']),
          trailing: Text(formattedDate.toString()),
        );
      },
    );
  }

  ListView buildLocationList(QuerySnapshot data5) {
    return ListView.builder(
      itemCount: data5.size,
      itemBuilder: (BuildContext context, int index) {
        var model = data5.docs.elementAt(index);
        var timestamp = model['timestamp'].toDate();
        var formattedDate = DateFormat.yMMMd().add_jm().format(timestamp);

        return ListTile(
          title: Text('ส่งตำเเหน่งปัจจุบันของคุณเเล้ว'),
          subtitle: Text(model['rank'] + model['name'] + '  ' + model['lname']),
          trailing: Text(formattedDate.toString()),
        );
      },
    );
  }
}
