import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kormomukhi/Models/User.dart';
import 'Components/custombutton.dart';
import 'Values/position.dart';
import 'Values/values.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'chatscreen.dart';
import 'order.dart';

class HomePage extends StatefulWidget {
  final Position position;
  final List<CurrentUser> users;
  const HomePage({Key? key, required this.position, required this.users})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final locationController = TextEditingController();

  late String googleApikey;
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  bool isLoading = true;
  String location = "Search Service";
  late Position _initialPosition;
  late final List<CurrentUser> users;
  String pay = 'Online';
  final ref = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String online = 'Bkash';

  double destLatitude = 26.46423, destLongitude = 50.06358;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  // String googleAPiKey = googleApiKey;

  @override
  void initState() {
    super.initState();
    users = widget.users;

    _initialPosition = widget.position;
    // getCurrentLocation();
    googleApikey = googleKey;

    setState(() {
      /// origin marker
      _addMarker(LatLng(0, 0), "origin", BitmapDescriptor.defaultMarker);

      /// destination marker
      _addMarker(LatLng(destLatitude, destLongitude), "destination",
          BitmapDescriptor.defaultMarkerWithHue(90));
    });
    users.forEach((user) {
      if (user.position != null) {
        _addMarker(LatLng(user.position[0], user.position[1]), '${user.id}',
            BitmapDescriptor.defaultMarkerWithHue(90));
      }
    });

    _getPolyline();
  }

  Future<Position> getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      _initialPosition = position;
      isLoading = false;
    });
    return _initialPosition;
  }

  // Future<String> getUsersLocationFromLngLat(position) async {
  //   List<Placemark> placemarks =
  //   await placemarkFromCoordinates(position[0], position[1]);
  //   return '${placemarks[0].subAdministrativeArea}';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(_initialPosition.latitude, _initialPosition.longitude),
              zoom: 14.0,
            ),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: false,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
            onTap: (pos) async {
              for (int i = 0; i < users.length; i++) {
                setState(() {
                  print('position $i${users[i]}');
                  _addMarker(LatLng(users[i].position[0], users[i].position[1]),
                      users[i].id, BitmapDescriptor.defaultMarkerWithHue(90));
                });
              }
            },
          ),
          Positioned(
              top: 10,
              child: InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        components: [Component(Component.country, 'np')],
                        onError: (err) {
                          showOkAlertDialog(
                              context: context,
                              title: 'Error!!!',
                              message: err.toString());
                        });

                    if (place != null) {
                      setState(() {
                        location = place.description.toString();
                      });
                      final plist = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatlang, zoom: 17)));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            title: Text(
                              location,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          )),
                    ),
                  )))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          Position _position = await determinePosition();
          var newlatlang = LatLng(_position.latitude, _position.longitude);
          mapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: newlatlang, zoom: 17)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) async {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('position', isEqualTo: [
                  position.latitude,
                  position.longitude
                ]).snapshots(),
                builder: (context, snapshot) {
                  return Builder(builder: (_) {
                    if (snapshot.hasData) {
                      DocumentSnapshot doc = snapshot.data!.docs[0];
                      // var l = getUsersLocationFromLngLat(position);

                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.network(
                              doc['image'],
                              width: 150,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                            Text(
                              doc['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            CustomButton(
                              txt: 'Hire Now',
                              action: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Set your location'),
                                          content: StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: 5,
                                                  minLines: 5,
                                                  controller:
                                                      locationController,
                                                ),
                                                Text('Payment via:'),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            pay = 'Online';
                                                            online = 'Bkash';
                                                          });
                                                        },
                                                        child: Text('Online'),
                                                      ),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            pay = 'Cash';
                                                            online = 'No';
                                                          });
                                                        },
                                                        child: Text('Cash'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text('Selected: $pay'),
                                                if (online != 'No')
                                                  Text('Select Online Method:'),
                                                if (online != 'No')
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              online = 'Bkash';
                                                            });
                                                          },
                                                          child: Text('Bkash'),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              online = 'Nagad';
                                                            });
                                                          },
                                                          child: Text('Nagad'),
                                                        ),
                                                      ),
                                                      SizedBox(width: 2),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              online = 'Rocket';
                                                            });
                                                          },
                                                          child: Text('Rocket'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (online != 'No')
                                                  Text('Selected: $online'),
                                              ],
                                            );
                                          }),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel')),
                                            TextButton(
                                              onPressed: () {
                                                String id = DateTime.now()
                                                    .microsecondsSinceEpoch
                                                    .toString();
                                                ref
                                                    .collection('orders')
                                                    .doc("${id}")
                                                    .set({
                                                  'order_id': id,
                                                  'customer_id':
                                                      auth.currentUser?.uid,
                                                  'customer_name': auth
                                                      .currentUser?.displayName,
                                                  'seller_name': doc['name'],
                                                  'seller_id': doc['uid'],
                                                  'location':
                                                      locationController.text,
                                                  'state': 'Requested',
                                                  'pay': pay,
                                                  'online': online,
                                                  'via': 'GPS'
                                                }).then((value) {
                                                  Navigator.pop(context);
                                                  ref
                                                      .collection('users')
                                                      .doc(
                                                          "${auth.currentUser?.uid}")
                                                      .collection(
                                                          'notifications')
                                                      .add({
                                                    'title': 'Order',
                                                    'details':
                                                        '${doc['name']} is coming soon. Wait for the response',
                                                  }).then((value) {
                                                    ref
                                                        .collection('users')
                                                        .doc('${doc["uid"]}')
                                                        .collection(
                                                            'notifications')
                                                        .add({
                                                      'title': 'Order',
                                                      'details':
                                                          '${auth?.currentUser?.displayName} is calling you for work. He will pay via $pay',
                                                    });
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            AlertDialog(
                                                              title:
                                                                  Text('Order'),
                                                              content: Text(
                                                                  '${doc['name']} is coming soon. Wait for the response'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        'OK')),
                                                              ],
                                                            ));
                                                  });
                                                }).onError((error, stackTrace) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              '${error.toString()}')));
                                                });
                                              },
                                              child: Text('Confirm'),
                                            ),
                                          ],
                                        ));
                              },
                            ),
                            CustomButton(
                              txt: 'Chat',
                              action: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            worker: doc['name'],
                                            workerId: doc['uid'],
                                          )),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  });
                }),
          ),
        );
      },
      markerId: markerId,
      icon: descriptor,
      position: LatLng(position.latitude, position.longitude),
    );
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleKey,
        PointLatLng(_initialPosition.latitude, _initialPosition.longitude),
        PointLatLng(destLatitude, destLongitude),
        // travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
