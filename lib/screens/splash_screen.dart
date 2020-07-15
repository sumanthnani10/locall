import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locall/screens/bottom_nav.dart';
import 'package:locall/screens/login.dart';
import 'package:locall/screens/user_details_input.dart';
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
    if (await FirebaseAuth.instance.currentUser() != null) {
      String uid;
      String phone;
      await FirebaseAuth.instance.currentUser().then((value) {
        uid = value.uid;
        phone = value.phoneNumber;
      });
      await Firestore.instance
          .collection('users')
          .document(uid)
          .get()
          .then((val) async {
        if (val.data['first_name'] == null) {
          Navigator.pushReplacement(
              context, createRoute(UserDetailsInput(uid, phone)));
        } else {
          Storage.user = val.data;
          await Firestore.instance
              .collection('locations')
              .document(val.data['area'].toString().toLowerCase())
              .get()
              .then((value) {
            Storage.area_details = value.data;
            print(value.data);
          });
          await Firestore.instance
              .collection('locations')
              .document(val.data['area'].toString().toLowerCase())
              .collection('groceries')
              .orderBy('name')
              .getDocuments()
              .then((value) {
            Storage.products = value.documents;
            Storage.productsMap.clear();
            Storage.products.forEach((element) {
              Storage.productsMap[element.documentID] = element;
            });
          });
          Navigator.of(context).pushReplacement(createRoute(BottomNavBar()));
        }
      });
    } else {
      Navigator.of(context).pushReplacement(createRoute(Login()));
    }
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
