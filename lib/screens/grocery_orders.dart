import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locall/containers/grocery_order_container.dart';
import 'package:locall/screens/grocery_order.dart';
import 'package:locall/storage.dart';

class GroceryOrders extends StatefulWidget {
  @override
  _GroceryOrdersState createState() => _GroceryOrdersState();
}

class _GroceryOrdersState extends State<GroceryOrders> {
  List<Color> colors = [
    Color(0xffffaf00),
    Color(0xfffff700),
    Color(0xff00fd5d),
    Colors.cyanAccent,
    Colors.deepOrangeAccent
  ];
  List<Color> splashColors = [
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.deepOrange,
  ];

  bool gotOrders = false;

  List<DocumentSnapshot> orders;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    await Firestore.instance
        .collection('orders')
        .where('details.type', isEqualTo: 'grocery')
        .where('details.customer_id', isEqualTo: Storage.user['customer_id'])
        .getDocuments()
        .then((value) {
      orders = value.documents;
      orders.sort((a, b) {
        if (b['time']['order_placed']
            .toDate()
            .isBefore(a['time']['order_placed'].toDate()))
          return -1;
        else
          return 1;
      });
    });
    setState(() {
      gotOrders = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Orders',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 113,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xffffaf00),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Placed',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 113,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xfffff700),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Accepted',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 113,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xff00fd5d),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Packed',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 84.75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Delivered',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 84.75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Rejected',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              if (orders == null) LinearProgressIndicator(),
              if (orders != null && orders.length == 0) Text('No Orders'),
              if (orders != null && orders.length != 0)
                ListView.builder(
                    itemCount: orders.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (_, index) {
                      var snap = orders[index].data;
                      int c = 0;
                      switch (snap['details']['stage']) {
                        case 'Order Placed':
                          c = 0;
                          break;
                        case 'Accepted':
                          c = 1;
                          break;
                        case 'Packed':
                          c = 2;
                          break;
                        case 'Delivered':
                          c = 3;
                          break;
                        case 'Rejected':
                          c = 4;
                          break;
                      }
                      ;
                      String items = '';
                      snap['products'].forEach((e) {
                        items +=
                            '${Storage.productsMap[e['product_id']]['name']}, ';
                      });
                      items = items.substring(0, items.length - 2) + ' .';
                      return GroceryOrderContainer(
                        onTap: () {
                          Navigator.of(context).push(createRoute(GroceryOrder(
                            snap,
                          )));
                        },
                        time: snap['time']['order_placed'],
                        splashColor: splashColors[c],
                        color: colors[c],
                        orderId: '${snap['order_id']}',
                        itemnumbers: snap['length'],
                        items: items,
                        total: '${snap['price']['total']}',
                      );
                    })
              /*Column(
                        children: List.generate(snapshot.data.documents.length,
                            (index) {
                          var snap = snapshot.data.documents[index].data;
                          return OrderContainer(
                              onTap: () {
                                Navigator.of(context).push(createRoute(ItemList(
                                  snap: snap,
                                )));
                              },
                              splashColor: Colors.orange,
                              color: Color(0xffffaf00),
                              customerName: snap['details']['customer_id'],
                              itemnumbers: snap['length'],
                              items:
                                  'Small Fresh Fish,Handmade Granite Keyboard,Handmade');
                        }),
                      );*/
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
}
