import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController hnoc = new TextEditingController();
  TextEditingController streetc = new TextEditingController();
  TextEditingController landmarkc = new TextEditingController();
  TextEditingController villc = new TextEditingController();
  TextEditingController pincodec = new TextEditingController();
  GoogleMapController map;
  String hno = '',
      street = '',
      landmark = '',
      vill = '',
      dist = 'Sangareddy',
      state = 'Telangana',
      area = 'Isnapur',
      pincode = '';

  LatLng custLoc;
  Position position;
  Marker custMarker;
  String custAddress;
  int c = 0;

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
      print(await Geolocator().checkGeolocationPermissionStatus());
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
    custAddress = placemark.elementAt(0).name +
        ',' +
        placemark.elementAt(0).subLocality +
        ',' +
        placemark.elementAt(0).subAdministrativeArea +
        ',' +
        placemark.elementAt(0).locality +
        ',' +
        placemark.elementAt(0).administrativeArea;
    print(custAddress);
    print(placemark.elementAt(0).thoroughfare);
    print(placemark.elementAt(0).subThoroughfare);
    pincodec.text = placemark.elementAt(0).postalCode;
    villc.text = placemark.elementAt(0).subLocality;
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
    print(latLng.toString() + custMarker.position.toString());
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    custAddress = placemark.elementAt(0).name +
        ',' +
        placemark.elementAt(0).subLocality +
        ',' +
        placemark.elementAt(0).subAdministrativeArea +
        ',' +
        placemark.elementAt(0).locality +
        ',' +
        placemark.elementAt(0).administrativeArea;
    print(custAddress);
    print(placemark.elementAt(0).thoroughfare);
    print(placemark.elementAt(0).subThoroughfare);
    pincodec.text = placemark.elementAt(0).postalCode;
    villc.text = placemark.elementAt(0).subLocality;
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
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
