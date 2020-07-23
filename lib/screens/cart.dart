import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locall/containers/title_text.dart';
import 'package:locall/service/notification_handler.dart';
import 'package:locall/storage.dart';

import 'grocery_order.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Map<String, dynamic> products = new Map<String, dynamic>();
  List<int> tl = new List<int>();
  List<int> ml = new List<int>();
  int total = 0, mrp = 0;
  bool loading = false;
  int delivery = 0;

  @override
  Widget build(BuildContext context) {
    tl.length = 0;
    ml.length = 0;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: TitleText(
          'Cart',
          cart: true,
          back: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Storage.cart.length != 0
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(Storage.cart.length, (i) {
                      var t;
                      String id = '${Storage.cart[i].documentID}';
                      int pn = Storage.cart[i]['price_num'];
                      t = Storage.productsMap[Storage.cart[i]['product_id']];
                      if (t != null) {
                        products[id] = t.data;
                        products[id].addAll(Storage.cart[i].data);
                        if (tl.length > i) {
                          tl[i] = (products[id]['price_$pn'] *
                              products[id]['quantity']);
                          ml[i] = (products[id]['mrp_$pn'] *
                              products[id]['quantity']);
                        } else {
                          tl.add(products[id]['price_$pn'] *
                              products[id]['quantity']);
                          ml.add(products[id]['mrp_$pn'] *
                              products[id]['quantity']);
                        }
                        mrp = ml.fold(0, (p, c) => p + c);
                        total = tl.fold(0, (p, c) => p + c);
                        if (total >= 1500) {
                          delivery = 0;
                        } else {
                          if (Storage.user['grocery']['distance'] <= 1000) {
                            delivery = 25;
                          } else {
                            delivery = 40;
                          }
                        }
                      }
                      return Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        constraints:
                            BoxConstraints(maxWidth: 400, maxHeight: 98),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                products[id]['image'],
                                fit: BoxFit.cover,
                                width: 100,
                                height: 90,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    products[id]['name'],
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    products[id]['category'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        products[id]['quantity_$pn']
                                                    .toString() !=
                                                '0'
                                            ? 'Rs.${products[id]['price_$pn']}/${products[id]['quantity_$pn']}${products[id]['unit_$pn']}'
                                            : 'Rs.${products[id]['price_$pn']}',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      if (products[id]['price_$pn'] !=
                                          products[id]['mrp_$pn'])
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              'Rs.${products[id]['mrp_$pn']}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationColor:
                                                      Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              '(${((products[id]['mrp_$pn'] - products[id]['price_$pn']) / products[id]['mrp_$pn'] * 100).round()}%)',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      RupeeText(
                                        amount: products[id]['price_$pn'] *
                                            Storage.cart[i]['quantity'],
                                        size: 18,
                                        color: Colors.green[800],
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        (products[id]['mrp_$pn'] *
                                                Storage.cart[i]['quantity'])
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
                                    showLoadingDialog(
                                        context, 'Adding to Cart');
                                    products[id]['quantity']++;
                                    setState(() {});
                                    await Firestore.instance
                                        .collection('users')
                                        .document(
                                            '${Storage.user['customer_id']}')
                                        .collection('grocery_cart')
                                        .document(Storage.cart[i].documentID)
                                        .updateData({
                                      'quantity':
                                          Storage.cart[i]['quantity'] + 1,
                                    });
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  Storage.cart[i]['quantity'].toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () async {
                                    showLoadingDialog(
                                        context, 'Adding to Cart');
                                    if (Storage.cart[i]['quantity'] > 1) {
                                      products[id]['quantity']--;
                                      setState(() {});
                                      await Firestore.instance
                                          .collection('users')
                                          .document(
                                              '${Storage.user['customer_id']}')
                                          .collection('grocery_cart')
                                          .document(Storage.cart[i].documentID)
                                          .updateData({
                                        'quantity':
                                            Storage.cart[i]['quantity'] - 1,
                                      });
                                    } else {
                                      products[id] = null;
                                      setState(() {});
                                      await Firestore.instance
                                          .collection('users')
                                          .document(
                                              '${Storage.user['customer_id']}')
                                          .collection('grocery_cart')
                                          .document(Storage.cart[i].documentID)
                                          .delete();
                                    }
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.green,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }).toList()),
              )
            : Text('Add products to your cart.'),
      ),
      bottomNavigationBar: Storage.cart.length != 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Total:  '),
                      Row(
                        children: <Widget>[
                          RupeeText(
                            amount: total,
                            color: Colors.green,
                            fontWeight: FontWeight.w800,
                            size: 22,
                          ),
                          Text(
                            delivery == 0
                                ? ' (Free Delivery)'
                                : ' + Rs.$delivery (Delivery)',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (mrp != total)
                        Row(
                          children: <Widget>[
                            Text(
                              mrp.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                                ' (You Save: ${(((mrp - total) / mrp) * 100).round()}%)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                )),
                          ],
                        ),
                    ],
                  ),
                  Spacer(),
                  RaisedButton.icon(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.greenAccent,
                      onPressed: () async {
                        showLoadingDialog(context, 'Placing Order');
                        List<Map<String, dynamic>> cart =
                            new List<Map<String, dynamic>>();
                        List<String> pids = new List<String>();

                        Storage.cart.forEach((element) {
                          cart.add(element.data);
                          pids.add(element.data['product_id']);
                        });

                        String ntoken =
                            await NotificationHandler.instance.init(context);

                        Map<String, dynamic> order = {
                          'products': cart,
                          'details': {
                            'customer_id': Storage.user['customer_id'],
                            'type': 'grocery',
                            'provider_id': 'isnapur_grocery_sairam',
                            'stage': 'Order Placed',
                          },
                          'time': {'order_placed': Timestamp.now()},
                          'price': {
                            'total': total,
                            'mrp': mrp,
                            'saved': (((mrp - total) / mrp) * 100).round(),
                            'delivery': delivery
                          },
                          'notification_id': ntoken,
                          'length': Storage.cart.length,
                        };
                        await Firestore.instance
                            .collection('orders')
                            .add({}).then((value) async =>
                                order['order_id'] = value.documentID);
                        await Firestore.instance
                            .collection('orders')
                            .document(order['order_id'])
                            .setData(order);
                        await Firestore.instance
                            .collection('users')
                            .document(Storage.user['customer_id'])
                            .updateData({
                          'notification_id': ntoken,
                          'grocery_ordered_products':
                              FieldValue.arrayUnion(pids)
                        });

                        var l = Storage.cart;
                        l.forEach((e) async {
                          await Firestore.instance
                              .collection('users')
                              .document(Storage.user['customer_id'])
                              .collection('grocery_cart')
                              .document(e.documentID)
                              .delete();
                        });
//                    order['time']['order_placed'] = Timestamp.now();
                        await NotificationHandler.instance.sendMessage(
                            'New Order',
                            "You got a new Order.",
                            Storage.area_details['groceries']
                                ['notification_token']);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.of(context)
                            .push(createRoute(GroceryOrder(order)));

                        /*Navigator.push(
                            context,
                            createRoute(AddressScreen(
                                total: total,
                                mrp: mrp,
                                saved: (((mrp - total) / mrp) * 100).round())));*/
                      },
                      icon: Icon(
                        Icons.done_all,
                        size: 24,
                      ),
                      label: Text(
                        'Checkout',
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
            )
          : Container(
              height: 48,
            ),
      backgroundColor: Color(0xffa6e553),
    );
  }

  Route createRoute(dest) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => dest,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1, 0);
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

class RupeeText extends StatelessWidget {
  Color color = Colors.black;
  double size = 16;
  int amount = 0;
  FontWeight fontWeight = FontWeight.normal;
  TextDecoration textDecoration = TextDecoration.none;

  RupeeText(
      {this.amount,
      this.color,
      this.size,
      this.fontWeight,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '\u20B9 ',
          style: TextStyle(
              fontSize: this.size, color: this.color, fontFamily: 'Roboto'),
        ),
        Text(
          '${this.amount}',
          style: TextStyle(
              fontSize: this.size,
              color: this.color,
              fontWeight: fontWeight,
              decoration: textDecoration),
        ),
      ],
    );
  }
}
