import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locall/screens/splash_screen.dart';
import 'package:locall/service/notification_handler.dart';
import 'package:locall/storage.dart';

class UserDetailsInput extends StatefulWidget {
  final String uid;
  final String phone;

  UserDetailsInput(this.uid, this.phone);

  @override
  _UserDetailsInputState createState() => _UserDetailsInputState();
}

class _UserDetailsInputState extends State<UserDetailsInput> {
  TextEditingController fname_controller = new TextEditingController();
  TextEditingController lname_controller = new TextEditingController();
  String fname = '', lname = '', location = '';
  TextEditingController addressc = new TextEditingController();
  GoogleMapController map;

  List<Map<String, dynamic>> areas = new List<Map<String, dynamic>>();

  LatLng custLoc;
  Position position;
  double distance = 3001;
  Marker custMarker;
  String custAddress;
  int c = 0;
  ValueNotifier<bool> deliverable = ValueNotifier<bool>(true);

  @override
  void initState() {
    custLoc = null;
    areas.add({'area': 'Isnapur', 'lat': 17.544466, 'long': 78.212255});
    custMarker = Marker(
        markerId: MarkerId("Customer"),
        position: new LatLng(17.406622914697873, 78.48532670898436),
        draggable: true,
        onDragEnd: (newPos) {
          moveCamera(newPos);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enter your Details",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              if (fname != '' && lname != '') {
                if (deliverable.value) {
                  showLoadingDialog(context, 'Uploading');
                  String t = await NotificationHandler.instance.init(context);
                  await Firestore.instance
                      .collection('users')
                      .document(widget.uid)
                      .setData({
                    'customer_id': widget.uid,
                    'mobile': widget.phone,
                    'notification_id': t,
                    'grocery': {
                      'area': location,
                      'distance': distance,
                      'address': custAddress,
                      'location': {
                        'lat': custLoc.latitude,
                        'long': custLoc.longitude,
                      },
                    },
                    'first_name': fname,
                    'last_name': lname,
                  });
                  Navigator.of(context)
                      .pushReplacement(createRoute(SplashScreen()));
                } else {
                  showAlertDialog(context, 'Sorry',
                      'You are out of our delivery range.\nWe will be available there soon.');
                }
              } else {
                showAlertDialog(context, 'Details', 'Please enter all details');
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.blue),
            ),
            splashColor: Colors.greenAccent,
          )
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/user_details_input.jpg',
                      fit: BoxFit.cover,
                    ),
                  )),
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          child: TextField(
                            onChanged: (v) {
                              fname = v;
                            },
                            controller: fname_controller,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            maxLines: 1,
                            decoration: InputDecoration(
                                fillColor: Colors.white70,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black54, width: 2),
                                    borderRadius: BorderRadius.circular(48)),
                                hintText: "First Name *",
                                labelText: 'First Name *'),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: 300,
                          child: TextField(
                            onChanged: (v) {
                              lname = v;
                            },
                            controller: lname_controller,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            maxLines: 1,
                            decoration: InputDecoration(
                                fillColor: Colors.white70,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black54, width: 2),
                                    borderRadius: BorderRadius.circular(48)),
                                hintText: "Last Name *",
                                labelText: 'Last Name *'),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: deliverable,
                          builder: (_, d, __) {
                            return Container(
                              width: 330,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color:
                                      d ? Colors.greenAccent : Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(d
                                  ? 'Order can be delivered to your location.'
                                  : 'Order cannot be delivered to your location.'),
                            );
                          },
                        ),
                        Container(
                          height: 200,
                          width: 330,
                          child: GoogleMap(
                            key: UniqueKey(),
                            markers: {custMarker},
                            mapType: MapType.normal,
                            buildingsEnabled: true,
                            rotateGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                            myLocationEnabled: true,
                            onLongPress: (lloc) {
                              custLoc = lloc;
                              moveToLocation(lloc);
                              setState(() {});
                            },
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    17.406622914697873, 78.48532670898436),
                                zoom: 10.9),
                            onMapCreated: (c) {
                              map = c;
                              getCurrentLocation();
                            },
                          ),
                        ),
                        Container(
                          width: 330,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Long press to pin a location.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: 330,
                          child: TextField(
                            onChanged: (v) {
                              custAddress = v;
                            },
                            keyboardType: TextInputType.text,
                            controller: addressc,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            maxLines: 6,
                            decoration: InputDecoration(
                                fillColor: Colors.white70,
                                filled: true,
                                contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                labelText: 'Address *'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    if (custLoc != null) {
      moveToLocation(custLoc);
    } else {
      if (await Geolocator().checkGeolocationPermissionStatus() ==
          GeolocationStatus.granted) {
        if (!await Geolocator().isLocationServiceEnabled()) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Turn on Location"),
                  content: const Text(
                      'Please make sure you enable Location and try again'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Ok'),
                        onPressed: () async {
                          final AndroidIntent intent = AndroidIntent(
                              action:
                                  'android.settings.LOCATION_SOURCE_SETTINGS');
                          intent.launch();
                          Navigator.of(context, rootNavigator: true).pop();
                        })
                  ],
                );
              });
        } else {
          position = await Geolocator().getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              locationPermissionLevel: GeolocationPermission.locationWhenInUse);
          custLoc = new LatLng(position.latitude, position.longitude);
          moveToLocation(new LatLng(position.latitude, position.longitude));
        }
      } else {
        getCurrentLocation();
      }
    }
  }

  moveCamera(LatLng latLng) async {
    map.animateCamera(CameraUpdate.newCameraPosition(
        new CameraPosition(target: latLng, zoom: 15)));
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    setAddress(placemark.elementAt(0));
    custLoc = latLng;
    setState(() {});
  }

  moveToLocation(LatLng latLng) async {
    Marker marker = Marker(
        position: new LatLng(latLng.latitude, latLng.longitude),
        markerId: custMarker.markerId,
        draggable: true,
        onDragEnd: (newPos) {
          moveCamera(newPos);
        });
    custMarker = marker;
    if (c == 0) {
      setState(() {
        c = 1;
      });
    }
    map.moveCamera(CameraUpdate.newCameraPosition(
        new CameraPosition(target: latLng, zoom: 15)));
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    setAddress(placemark.elementAt(0));
    deliverable.value = false;
    double dt;
    areas.forEach((element) async {
      if ((dt = await Geolocator().distanceBetween(latLng.latitude,
              latLng.longitude, element['lat'], element['long'])) <=
          3000.0) {
        deliverable.value = true;
        location = element['area'];
        distance = dt;
      }
    });
  }

  setAddress(placemark) {
//    print(placemark.toJson());
    custAddress = '';
    if (placemark.name != '') {
      custAddress += '${placemark.name},';
    }
    if (placemark.subThoroughfare != '') {
      custAddress += '${placemark.subThoroughfare},';
    }
    if (placemark.subLocality != '') {
      custAddress += '${placemark.subLocality},';
    }
    if (placemark.subAdministrativeArea != '') {
      custAddress += '${placemark.subAdministrativeArea},';
    }
    if (placemark.thoroughfare != '') {
      custAddress += '${placemark.thoroughfare},';
    }
    if (placemark.locality != '') {
      custAddress += '${placemark.locality},';
    }
    if (placemark.subAdministrativeArea != '') {
      custAddress += '${placemark.administrativeArea},';
    }
    if (placemark.subAdministrativeArea != '') {
      custAddress += '${placemark.postalCode},';
    }
    addressc.text = custAddress;
  }

  showLoadingDialog(BuildContext context, String title) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 8,
                  ),
                  Text(title)
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(16),
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Route createRoute(dest) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => dest,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, -1);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
