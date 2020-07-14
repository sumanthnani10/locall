import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locall/screens/login.dart';
import 'package:locall/storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showAddress = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 48,
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${Storage.user['first_name']} ${Storage.user['last_name']}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${Storage.user['mobile']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${Storage.user['area']}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      showAddress = !showAddress;
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border(bottom: BorderSide(color: Colors.black26))),
                    child: Text(
                      'Address',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                if (showAddress)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'House No./Flat No.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        Text('12-80/2'),
                        Text(
                          'Street',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        Text('Srinagar Colony'),
                        Text(
                          'Landmark',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        Text('School'),
                        Text(
                          'Area',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        Text('Isnapur'),
                        Text(
                          'Pincode',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        Text('502319'),
                      ],
                    ),
                  ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border(bottom: BorderSide(color: Colors.black26))),
                    child: Text(
                      'Orders',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, createRoute(Login()));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border(bottom: BorderSide(color: Colors.black26))),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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