/*Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  ///นาทีที่ 10.00 Flutter Retrieve Markers From Firestore | Display Markers Firestore Google Maps |Flutter Google Maps
  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        infoWindow: InfoWindow(title: 'Shop', snippet: specify['address']));
    setState(() {
      markers[markerId] = marker;
    });
  }

  ///นาทีที่ 8.00 Flutter Retrieve Markers From Firestore | Display Markers Firestore Google Maps |Flutter Google Maps
  getMarkerData() async {
    Firestore.instance.collection('data').getDocuments().then((myMockData) {
      if (myMockData.documents.isNotEmpty) {
        for (int i = 0; i < myMockData.documents.length; i++) {
          initMarker(
              myMockData.documents[i].data, myMockData.documents[i].documentID);
        }
      }
    });
  }*/

// var log = [];
// var myLatlng = [];
// var namestation = [];

// initMap() async {
//   firestoreInstance
//       .collection('location_now')
//       .get()
//       .then((QuerySnapshot snap) => {
//         snap.docs.forEach((element) {
//           log
//       })});
// }
// Set<Marker> getMarker() {
//   var loglatlong = [];
//   var namelog = [];
//   firestoreInstance
//       .collection('location_now')
//       .get()
//       .then((QuerySnapshot snapshot) => {
//             snapshot.docs.forEach((element) {
//               namelog.add(element.get('name') + " " + element.get('lname'));
//               loglatlong.add((element.get('latitude')).toString() +
//                   "/" +
//                   (element.get('longitude')).toString());
//             }),
//             print(loglatlong),
//           });
//   return <Marker>[
//     Marker(
//         markerId: MarkerId('PoliceThanya'),
//         position: LatLng(14.04, 100.73),
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: InfoWindow(title: 'Shop123')),
//   ].toSet();
// }
