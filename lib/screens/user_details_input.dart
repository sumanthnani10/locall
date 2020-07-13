import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locall/screens/splash_screen.dart';

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
  String fname = '', lname = '', location = 'Isnapur';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                      child: Image.asset(
                    'assets/images/user_details_input.jpg',
                    fit: BoxFit.cover,
                    height: 280,
                  )),
                  Text(
                    "Enter your Details",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      onChanged: (v) {
                        fname = v;
                      },
                      controller: fname_controller,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 2),
                              borderRadius: BorderRadius.circular(48)),
                          hintText: "First Name",
                          labelText: 'First Name'),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      onChanged: (v) {
                        lname = v;
                      },
                      controller: lname_controller,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 2),
                              borderRadius: BorderRadius.circular(48)),
                          hintText: "Last Name",
                          labelText: 'Last Name'),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 300,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Location',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(48)),
                    child: DropdownButton<String>(
                      value: location,
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'Isnapur',
                          child: Text('Isnapur'),
                        )
                      ],
                      onChanged: (v) {
                        setState(() {
                          location = v;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ButtonTheme(
                    minWidth: 160,
                    height: 48,
                    child: RaisedButton(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        if (fname != '' && lname != '') {
                          showLoadingDialog(context, 'Uploading');
                          await Firestore.instance
                              .collection('users')
                              .document(widget.uid)
                              .setData({
                            'customer_id': widget.uid,
                            'mobile': widget.phone,
                            'first_name': fname,
                            'last_name': lname,
                            'area': location
                          });
                          Navigator.of(context)
                              .pushReplacement(createRoute(SplashScreen()));
                        } else {
                          showAlertDialog(
                              context, 'Details', 'Please enter all details');
                        }
                      },
                      child: Text(
                        "VERIFY",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      splashColor: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
