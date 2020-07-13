import 'package:flutter/material.dart';
import 'package:locall/screens/cart.dart';
import 'package:locall/storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TitleText extends StatelessWidget {
  String title;
  bool cart;

  TitleText(this.title, {this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffa6e553),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: Colors.white38,
                  fontWeight: FontWeight.w800,
                  fontSize: 56),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (!cart)
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Cart(),
                      ));
                    },
                    splashColor: Color(0x66a6e553),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    icon: Icon(Icons.shopping_basket),
                    label: Text(
                      Storage.cart != null
                          ? Storage.cart.length != 0
                              ? 'Cart (${Storage.cart.length})'
                              : 'Cart'
                          : 'Cart',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
