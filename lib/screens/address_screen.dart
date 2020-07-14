import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locall/storage.dart';

class AddressScreen extends StatefulWidget {
  final total;

  AddressScreen({this.total});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  /*TextEditingController hnoc = new TextEditingController();
  TextEditingController streetc = new TextEditingController();
  TextEditingController landmarkc = new TextEditingController();
  TextEditingController villc = new TextEditingController();
  TextEditingController pincodec = new TextEditingController();
  String hno = '',
      street = '',
      landmark = '',
      vill = '',
      dist = 'Sangareddy',
      state = 'Telangana',
      area = 'Isnapur',
      pincode = '';*/
  TextEditingController addressc = new TextEditingController();
  GoogleMapController map;

  LatLng custLoc;
  Position position;
  Marker custMarker;
  String custAddress;
  int c = 0;
  ValueNotifier<bool> deliverable = ValueNotifier<bool>(true);

  @override
  void initState() {
    custLoc = null;
    custMarker = Marker(
        markerId: MarkerId("Customer"),
        position: new LatLng(17.406622914697873, 78.48532670898436),
        draggable: true,
        onDragEnd: (newPos) {
          moveCamera(newPos);
        });
  }

  Future<void> getCurrentLocation() async {
    if (custLoc != null) {
      moveToLocation(custLoc);
    } else {
      await Geolocator().checkGeolocationPermissionStatus();
      position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          locationPermissionLevel: GeolocationPermission.locationWhenInUse);
      custLoc = new LatLng(position.latitude, position.longitude);
      moveToLocation(new LatLng(position.latitude, position.longitude));
    }
  }

  moveCamera(LatLng latLng) async {
    map.animateCamera(CameraUpdate.newCameraPosition(
        new CameraPosition(target: latLng, zoom: 15)));
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    setAddress(placemark.elementAt(0));
    custLoc = latLng;
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
    if (await Geolocator().distanceBetween(
            latLng.latitude,
            latLng.longitude,
            Storage.area_details['groceries']['location']['lat'],
            Storage.area_details['groceries']['location']['long']) <=
        3000.0) {
      deliverable.value = true;
    } else {
      deliverable.value = false;
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Address',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  if (deliverable.value) {
                    showLoadingDialog(context, 'Placing Order');
                    List<Map<String, dynamic>> cart =
                        new List<Map<String, dynamic>>();

                    Storage.cart.forEach((element) {
                      cart.add(element.data);
                    });

                    Map<String, dynamic> order = {
                      'products': cart,
                      'details': {
                        'customer_id': Storage.user['customer_id'],
                        'type': 'grocery',
                        'provider_id': 'isnapur_grocery_sairam',
                        'stage': 'Order Placed',
                      },
                      'time': {'order_placed': FieldValue.serverTimestamp()},
                      'total': widget.total,
                      'length': Storage.cart.length,
                      'address': custAddress,
                      'location': {
                        'lat': custLoc.latitude,
                        'long': custLoc.longitude,
                      }
                    };
                    await Firestore.instance.collection('orders').add({}).then(
                        (value) async =>
                            order['order_id'] = await value.documentID);
                    await Firestore.instance
                        .collection('orders')
                        .document(order['order_id'])
                        .setData(order);
                    var l = Storage.cart;
                    l.forEach((e) async {
                      await Firestore.instance
                          .collection('users')
                          .document(Storage.user['customer_id'])
                          .collection('grocery_cart')
                          .document(e.documentID)
                          .delete();
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    showAlertDialog(context, 'Sorry',
                        'You are out of our delivery range.\nWe will be available there soon.');
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ))
          ],
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xffa6e553),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  /*Container(
                    width: 330,
                    child: Text(
                        '${Storage.user['first_name']} ${Storage.user['last_name']},\n${custAddress}'),
                  ),*/
                  ValueListenableBuilder(
                    valueListenable: deliverable,
                    builder: (_, d, __) {
                      return Container(
                        width: 330,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: d ? Colors.greenAccent : Colors.redAccent,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(d
                            ? 'Order can be delivered to your location.'
                            : 'Order cannot be delivered to your location.'),
                      );
                    },
                  ),
                  Container(
                    height: 300,
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
                          target: LatLng(17.406622914697873, 78.48532670898436),
                          zoom: 10.9),
                      onMapCreated: (c) {
                        map = c;
                        getCurrentLocation();
                      },
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
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8)),
                          labelText: 'Address *'),
                    ),
                  ),
                  /*Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    width: 330,
                    child: TextFormField(
                      onChanged: (v) {},
                      validator: (v) {
                        if (v != '') {
                          hno = v;
                          return null;
                        } else
                          return 'House No./Flat No. required';
                      },
                      keyboardType: TextInputType.text,
                      controller: hnoc,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8)),
                          labelText: 'House No./Flat No. *'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    width: 330,
                    child: TextFormField(
                      onChanged: (v) {},
                      validator: (v) {
                        if (v != '') {
                          street = v;
                          return null;
                        } else
                          return 'Street required';
                      },
                      keyboardType: TextInputType.text,
                      controller: streetc,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8)),
                          labelText: 'Street *'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    width: 330,
                    child: TextFormField(
                      onChanged: (v) {},
                      validator: (v) {
                        landmark = v;
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      controller: landmarkc,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8)),
                          labelText: 'Landmark'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    width: 330,
                    child: TextFormField(
                      onChanged: (v) {},
                      validator: (v) {
                        if (v != '') {
                          vill = v;
                          return null;
                        } else
                          return 'Village/Town required';
                      },
                      keyboardType: TextInputType.text,
                      controller: villc,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(8)),
                          labelText: 'Village/Town *'),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: 163,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'District',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          Container(
                            width: 163,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            child: DropdownButton<String>(
                              value: dist,
                              items: <DropdownMenuItem<String>>[
                                DropdownMenuItem<String>(
                                  value: 'Sangareddy',
                                  child: Text('Sangareddy'),
                                )
                              ],
                              onChanged: (v) {
                                setState(() {
                                  dist = v;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: 163,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'State',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          Container(
                            width: 163,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            child: DropdownButton<String>(
                              value: state,
                              items: <DropdownMenuItem<String>>[
                                DropdownMenuItem<String>(
                                  value: 'Telangana',
                                  child: Text('Telangana'),
                                )
                              ],
                              onChanged: (v) {
                                setState(() {
                                  state = v;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: 163,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Area',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          Container(
                            width: 163,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            child: DropdownButton<String>(
                              value: area,
                              items: <DropdownMenuItem<String>>[
                                DropdownMenuItem<String>(
                                  value: 'Isnapur',
                                  child: Text('Isnapur'),
                                )
                              ],
                              onChanged: (v) {
                                setState(() {
                                  area = v;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 24),
                        width: 163,
                        child: TextFormField(
                          onChanged: (v) {},
                          validator: (v) {
                            if (v != '') {
                              pincode = v;
                              return null;
                            } else
                              return 'Pincode required';
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          controller: pincodec,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          onFieldSubmitted: (term) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16.0),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: 'Pincode *'),
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
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
}
