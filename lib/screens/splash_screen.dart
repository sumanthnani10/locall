import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locall/screens/bottom_nav.dart';
import 'package:locall/screens/login.dart';
import 'package:locall/screens/user_details_input.dart';
import 'package:locall/service/notification_handler.dart';
import 'package:locall/storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool gotDetails = false;
  List<String> categories = [
    'Dry Fruits',
    'Rice & Rice Products',
    'Edible Oils',
    'Spices',
    'Dals & Pulses',
    'Atta & Flour',
    'Salt, Sugar & Tea',
    'Pooja Products',
    'Body Sprays',
    'Soaps and Shampoo',
    'Personal Hygiene',
    'Snacks and Food',
    'Hair Oils',
    'Masala',
    'Cleaners',
    'Chocolates',
    'Beverages',
    'Others',
    'Vegetables',
    'Stationary',
    'Dairy',
    'Patanjali',
  ];

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
        if (val.data == null) {
          Navigator.pushReplacement(
              context, createRoute(UserDetailsInput(uid, phone)));
        } else {
          Storage.user = val.data;
          await Firestore.instance
              .collection('locations')
              .document(val.data['grocery']['area'].toString().toLowerCase())
              .get()
              .then((value) {
            Storage.area_details = value.data;
          });
          await Firestore.instance
              .collection('locations')
              .document(val.data['grocery']['area'].toString().toLowerCase())
              .collection('groceries')
              .orderBy('name')
              .getDocuments()
              .then((value) {
            Storage.products = value.documents;
            Storage.productsMap.clear();
            Storage.products.forEach((element) {
              Storage.productsMap[element.documentID] = element;
            });
            Storage.products.sort((a, b) {
              return categories.indexOf(a['category']) -
                  categories.indexOf(b['category']);
            });
          });
          String ntoken =
          await NotificationHandler.instance.init(context);
          await Firestore.instance
              .collection('users')
              .document(uid)
              .updateData({
            'notification_id': ntoken,
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
        color: /*Color(0xffffaf00)*/ Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*Text(
                'Avashyaa',
                style: TextStyle(color: Colors.white, fontSize: 64),
              ),*/
              Spacer(),
              Container(
                height: 300,
                child: Image.asset(
                  'assets/logo/logo rev.png',
                  width: 300,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xffffaf00)),
                  )),
              Spacer(),
              Image.asset(
                'assets/logo/ftd_logo.png',
                width: 100,
              ),
              SizedBox(
                height: 8,
              )
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
