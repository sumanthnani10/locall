import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locall/screens/product_view_screen.dart';
import 'package:locall/screens/products_screen.dart';
import 'package:locall/service/notification_handler.dart';
import 'package:locall/storage.dart';

class GroceryOrder extends StatelessWidget {
  Map<String, dynamic> order;

  GroceryOrder(this.order);
  @override
  Widget build(BuildContext context) {
    double progress = 0.12;
    switch (order['details']['stage']) {
      case 'Accepted':
        progress = 0.36;
        break;
      case 'Packed':
        progress = 0.64;
        break;
      case 'Delivered':
        progress = 1;
        break;
      case 'Rejected':
        progress = 1;
        break;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffa6e553),
        title: Text(
          'Order Id: #' + order['order_id'],
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                    InkWell(
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: LinearProgressIndicator(
                                value: progress,
                                //0.12,0.36,0.64,1
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    order['details']['stage'] != 'Rejected'
                                        ? Colors.blue
                                        : Colors.redAccent),
                              ),
                            ),
                            if (order['details']['stage'] != 'Rejected')
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Placed',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.white,
                                        ),
                                        Text(
                                          '${order['time']['order_placed'].toDate().hour > 12 ? order['time']['order_placed'].toDate().hour - 12 : order['time']['order_placed'].toDate().hour}:${order['time']['order_placed'].toDate().minute} ${order['time']['order_placed'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['order_placed'].toDate().day}-${order['time']['order_placed'].toDate().month}-${order['time']['order_placed'].toDate().year}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Accepted',
                                          style: TextStyle(
                                              fontWeight: order['time']
                                                          ['accepted'] !=
                                                      null
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              fontSize: 14),
                                        ),
                                        CircleAvatar(
                                          radius:
                                              order['time']['accepted'] != null
                                                  ? 10
                                                  : 6,
                                          backgroundColor:
                                              order['time']['accepted'] != null
                                                  ? Colors.white
                                                  : Colors.grey,
                                        ),
                                        Text(
                                          order['time']['accepted'] != null
                                              ? '${order['time']['accepted'].toDate().hour > 12 ? order['time']['accepted'].toDate().hour - 12 : order['time']['accepted'].toDate().hour}:${order['time']['accepted'].toDate().minute} ${order['time']['accepted'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['accepted'].toDate().day}-${order['time']['accepted'].toDate().month}-${order['time']['accepted'].toDate().year}'
                                              : '\n',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Packed',
                                          style: TextStyle(
                                              fontWeight: order['time']
                                                          ['packed'] !=
                                                      null
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              fontSize: 14),
                                        ),
                                        CircleAvatar(
                                          radius:
                                              order['time']['packed'] != null
                                                  ? 10
                                                  : 6,
                                          backgroundColor:
                                              order['time']['packed'] != null
                                                  ? Colors.white
                                                  : Colors.grey,
                                        ),
                                        Text(
                                          order['time']['packed'] != null
                                              ? '${order['time']['packed'].toDate().hour > 12 ? order['time']['packed'].toDate().hour - 12 : order['time']['packed'].toDate().hour}:${order['time']['packed'].toDate().minute} ${order['time']['packed'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['packed'].toDate().day}-${order['time']['packed'].toDate().month}-${order['time']['packed'].toDate().year}'
                                              : '\n',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Delivered',
                                          style: TextStyle(
                                              fontWeight: order['time']
                                                          ['delivered'] !=
                                                      null
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              fontSize: 14),
                                        ),
                                        CircleAvatar(
                                          radius:
                                              order['time']['delivered'] != null
                                                  ? 10
                                                  : 6,
                                          backgroundColor:
                                              order['time']['delivered'] != null
                                                  ? Colors.white
                                                  : Colors.grey,
                                        ),
                                        Text(
                                          order['time']['delivered'] != null
                                              ? '${order['time']['delivered'].toDate().hour > 12 ? order['time']['delivered'].toDate().hour - 12 : order['time']['delivered'].toDate().hour}:${order['time']['delivered'].toDate().minute} ${order['time']['delivered'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['delivered'].toDate().day}-${order['time']['delivered'].toDate().month}-${order['time']['delivered'].toDate().year}'
                                              : '\n',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            if (order['details']['stage'] == 'Rejected')
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Placed',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.white,
                                        ),
                                        Text(
                                          '${order['time']['order_placed'].toDate().hour > 12 ? order['time']['order_placed'].toDate().hour - 12 : order['time']['order_placed'].toDate().hour}:${order['time']['order_placed'].toDate().minute} ${order['time']['order_placed'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['order_placed'].toDate().day}-${order['time']['order_placed'].toDate().month}-${order['time']['order_placed'].toDate().year}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Rejected',
                                          style: TextStyle(
                                              fontWeight: order['time']
                                                          ['rejected'] !=
                                                      null
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              fontSize: 14),
                                        ),
                                        CircleAvatar(
                                          radius:
                                              order['time']['rejected'] != null
                                                  ? 10
                                                  : 6,
                                          backgroundColor:
                                              order['time']['rejected'] != null
                                                  ? Colors.white
                                                  : Colors.grey,
                                        ),
                                        Text(
                                          order['time']['rejected'] != null
                                              ? '${order['time']['rejected'].toDate().hour > 12 ? order['time']['rejected'].toDate().hour - 12 : order['time']['rejected'].toDate().hour}:${order['time']['rejected'].toDate().minute} ${order['time']['rejected'].toDate().hour > 12 ? 'PM' : 'AM'}\n${order['time']['rejected'].toDate().day}-${order['time']['rejected'].toDate().month}-${order['time']['rejected'].toDate().year}'
                                              : '\n',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                        child: SizedBox(
                      height: 8,
                    )),
                    InkWell(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Address:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    InkWell(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '${Storage.user['first_name']} ${Storage.user['last_name']}\n${order['address']}'),
                      ),
                    ),
                    InkWell(
                        child: SizedBox(
                      height: 16,
                    )),
                    InkWell(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Products:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ))
                  ] +
                  List.generate(order['length'], (i) {
                    int pn = order['products'][i]['price_num'];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(createRoute(Product(
                          product: Storage
                              .productsMap[order['products'][i]['product_id']]
                              .data,
                        )));
                      },
                      child: Container(
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
                                Storage.productsMap[order['products'][i]
                                    ['product_id']]['image'],
                                fit: BoxFit.cover,
                                width: 100,
                                height: 90,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              width: 220,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    Storage.productsMap[order['products'][i]
                                        ['product_id']]['name'],
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    Storage.productsMap[order['products'][i]
                                        ['product_id']]['category'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                  ),
                                  Text(
                                    'Qty: ${order['products'][i]['quantity']}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Total:  '),
            Row(
              children: <Widget>[
                RupeeText(
                  amount: order['price']['total'],
                  color: Colors.green,
                  fontWeight: FontWeight.w800,
                  size: order['price']['delivery'] != 0 ? 24 : 22,
                ),
                if (order['price']['delivery'] != 0)
                  Text(
                    ' + Rs.${order['price']['delivery']} (Delivery)',
                    style: TextStyle(fontSize: 14),
                  ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  order['price']['mrp'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                    order['price']['saved'] != 0
                        ? ' (You Save: ${order['price']['saved']}%)'
                        : '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    )),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xffa6e553),
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
