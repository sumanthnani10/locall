import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locall/screens/bottom_nav.dart';
import 'package:locall/storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool gotDetails = false;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    await Firestore.instance
        .collection('locations')
        .document('isnapur')
        .collection('groceries')
        .orderBy('name')
        .getDocuments()
        .then((value) {
      Storage.products = value.documents;
    });
    Navigator.of(context).pushReplacement(createRoute(BottomNavBar()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'LoCall',
                style: TextStyle(color: Colors.lightBlue, fontSize: 64),
              ),
              Container(width: 150, child: LinearProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }

  Route createRoute(dest) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => dest,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, 1);
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
