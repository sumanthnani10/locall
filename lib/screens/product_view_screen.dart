import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locall/screens/cart.dart';
import 'package:locall/storage.dart';

class Product extends StatefulWidget {
  Map<String, dynamic> product;

  Product({@required this.product});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  Map<String, dynamic> variants = new Map<String, dynamic>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 225,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Cart(),
                      ));
                    },
                    splashColor: Color(0x66a6e553),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    icon: Icon(
                      Icons.shopping_basket,
                      size: 14,
                    ),
                    color: Colors.white,
                    label: Text(
                      Storage.cart != null
                          ? Storage.cart.length != 0
                              ? 'Cart (${Storage.cart.length})'
                              : 'Cart'
                          : 'Cart',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              ],
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black))),
                child: Carousel(
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.black,
                  dotIncreasedColor: Colors.black,
                  autoplay: false,
                  dotSpacing: 16,
                  dotPosition: DotPosition.bottomLeft,
                  dotIncreaseSize: 1.5,
                  images: <Widget>[
                    Image.network(
                      widget.product['image'],
                    ),
                    Image.network(
                      widget.product['image'],
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.product['name'],
                    maxLines: 2,
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    widget.product['category'],
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Variants :',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(widget.product['prices'], (index) {
                      var t;
                      if ((t = Storage.cart.singleWhere((element) {
                            return element.documentID ==
                                '${widget.product['product_id']}_price${index + 1}';
                          }, orElse: () {
                            return null;
                          })) !=
                          null) {
                        variants[
                                '${widget.product['product_id']}_price${index + 1}'] =
                            t.data;
                      } else {
                        variants[
                                '${widget.product['product_id']}_price${index + 1}'] =
                            null;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.product['quantity_${index + 1}']
                                          .toString() !=
                                      '0'
                                  ? 'Rs.${widget.product['price_${index + 1}']} - ${widget.product['quantity_${index + 1}']}${widget.product['unit_${index + 1}']}'
                                  : 'Rs.${widget.product['price_${index + 1}']}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            if (widget.product['price_${index + 1}'] !=
                                widget.product['mrp_${index + 1}'])
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Rs.${widget.product['mrp_${index + 1}']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '${((widget.product['mrp_${index + 1}'] - widget.product['price_${index + 1}']) / widget.product['mrp_${index + 1}'] * 100).round()}%',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            Spacer(),
                            if (widget.product['stock'] &&
                                variants[
                                        '${widget.product['product_id']}_price${index + 1}'] ==
                                    null)
                              RaisedButton.icon(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: Color(0xffa6e553),
                                  onPressed: () async {
                                    showLoadingDialog(
                                        context, 'Adding to Cart');
                                    await Firestore.instance
                                        .collection('users')
                                        .document(
                                            '${Storage.user['customer_id']}')
                                        .collection('grocery_cart')
                                        .document(
                                            '${widget.product['product_id']}_price${index + 1}')
                                        .setData({
                                      'product_id':
                                          widget.product['product_id'],
                                      'price_num': index + 1,
                                      'quantity': 1,
                                    });
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.shopping_basket,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Add to cart',
                                    style: TextStyle(fontSize: 12),
                                  )),
                            if (widget.product['stock'] &&
                                variants[
                                        '${widget.product['product_id']}_price${index + 1}'] !=
                                    null)
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      if (variants[
                                                  '${widget.product['product_id']}_price${index + 1}']
                                              ['quantity'] !=
                                          1) {
                                        showLoadingDialog(
                                            context, 'Updating Cart');
                                        await Firestore.instance
                                            .collection('users')
                                            .document(
                                                '${Storage.user['customer_id']}')
                                            .collection('grocery_cart')
                                            .document(
                                                '${widget.product['product_id']}_price${index + 1}')
                                            .updateData({
                                          'quantity': variants[
                                                      '${widget.product['product_id']}_price${index + 1}']
                                                  ['quantity'] -
                                              1,
                                        });
                                        Navigator.pop(context);
                                      } else {
                                        showLoadingDialog(
                                            context, 'Removing from Cart');
                                        await Firestore.instance
                                            .collection('users')
                                            .document(
                                                '${Storage.user['customer_id']}')
                                            .collection('grocery_cart')
                                            .document(
                                                '${widget.product['product_id']}_price${index + 1}')
                                            .delete();
                                        Navigator.pop(context);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.blue,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    variants['${widget.product['product_id']}_price${index + 1}']
                                            ['quantity']
                                        .toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      showLoadingDialog(
                                          context, 'Updating Cart');
                                      await Firestore.instance
                                          .collection('users')
                                          .document(
                                              '${Storage.user['customer_id']}')
                                          .collection('grocery_cart')
                                          .document(
                                              '${widget.product['product_id']}_price${index + 1}')
                                          .updateData({
                                        'quantity': variants[
                                                    '${widget.product['product_id']}_price${index + 1}']
                                                ['quantity'] +
                                            1,
                                      });
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.blue,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (!widget.product['stock'])
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8))),
                                    onPressed: () {},
                                    child: Text('Out Of Stock')),
                              )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Description :',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    widget.product['description'] == ''
                        ? '    No description'
                        : '    ' + widget.product['description'],
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ))
          ],
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
}
