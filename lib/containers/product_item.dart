import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locall/containers/focused_menu.dart';
import 'package:locall/screens/product_view_screen.dart';
import 'package:locall/storage.dart';

class ProductItem extends StatefulWidget {
  var snap;
  bool hw;

  ProductItem({@required this.snap, @required this.hw});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500) /*, value: 0.1*/);
    animation = CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /*void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: widget.snap['product_id'],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: Image(
                        image: NetworkImage(widget.snap['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.snap['name'],
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.snap['category'],
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Stock :',
                        style: TextStyle(fontSize: 12),
                      ),
                      Switch.adaptive(
                        value: stock,
                        onChanged: (c) async {
                          stock = c;
                          await Firestore.instance
                              .collection('locations')
                              .document('isnapur')
                              .collection('groceries')
                              .document(widget.snap['product_id'])
                              .updateData({'stock': c});
                        },
                        activeColor: Colors.green,
                        activeTrackColor: Colors.white,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Description :',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.snap['description'] == ''
                        ? '    No description'
                        : '    ' + widget.snap['description'],
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Prices :',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(widget.snap['prices'], (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.snap['quantity_${index + 1}']
                                            .toString() !=
                                        '0'
                                    ? 'Rs.${widget.snap['price_${index + 1}']}/${widget.snap['quantity_${index + 1}']}${widget.snap['unit_${index + 1}']}'
                                    : 'Rs.${widget.snap['price_${index + 1}']}',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (widget.snap['price_${index + 1}'] !=
                                  widget.snap['mrp_${index + 1}'])
                                SizedBox(
                                  width: 4,
                                ),
                              if (widget.snap['price_${index + 1}'] !=
                                  widget.snap['mrp_${index + 1}'])
                                Text(
                                  'Rs.${widget.snap['mrp_${index + 1}']}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              if (widget.snap['price_${index + 1}'] !=
                                  widget.snap['mrp_${index + 1}'])
                                SizedBox(
                                  width: 4,
                                ),
                              if (widget.snap['price_${index + 1}'] !=
                                  widget.snap['mrp_${index + 1}'])
                                Text(
                                  '(${((widget.snap['mrp_${index + 1}'] - widget.snap['price_${index + 1}']) / widget.snap['mrp_${index + 1}'] * 100).round()}%)',
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }*/

  card() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Image(
                image: NetworkImage(widget.snap['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              widget.snap['name'],
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              widget.snap['category'],
              style: TextStyle(fontSize: 8, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.snap['quantity_1'].toString() != '0'
                      ? 'Rs.${widget.snap['price_1']}/${widget.snap['quantity_1']}${widget.snap['unit_1']}'
                      : 'Rs.${widget.snap['price_1']}',
                  style: TextStyle(fontSize: 11, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (widget.snap['price_1'] != widget.snap['mrp_1'])
                  SizedBox(
                    width: 4,
                  ),
                if (widget.snap['price_1'] != widget.snap['mrp_1'])
                  Text(
                    'Rs.${widget.snap['mrp_1']}',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                if (widget.snap['price_1'] != widget.snap['mrp_1'])
                  SizedBox(
                    width: 4,
                  ),
                if (widget.snap['price_1'] != widget.snap['mrp_1'])
                  Text(
                    '(${((widget.snap['mrp_1'] - widget.snap['price_1']) / widget.snap['mrp_1'] * 100).round()}%)',
                    style: TextStyle(
                        fontSize: 7,
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          Spacer(),
          if (widget.snap['stock'] &&
              !Storage.cart_products_id.contains(widget.snap['product_id']))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  color: Color(0xffa6e553),
                  onPressed: () {},
                  icon: Icon(Icons.shopping_basket),
                  label: Text('Add to cart')),
            ),
          if (widget.snap['stock'] &&
              Storage.cart_products_id.contains(widget.snap['product_id']) &&
              widget.snap['prices'] != 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      side: BorderSide(color: Colors.black)),
                  color: Colors.white,
                  onPressed: () {},
                  icon: Icon(Icons.shopping_basket),
                  label: Text(
                    'Added to cart',
                    style: TextStyle(fontSize: 12),
                  )),
            ),
          if (widget.snap['stock'] &&
              Storage.cart_products_id.contains(widget.snap['product_id']) &&
              widget.snap['prices'] == 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      /*
                      if (Storage.cart[
                      '${widget.product['product_id']}_price${index + 1}']
                      ['quantity'] !=
                          1) {
                        await Firestore.instance
                            .collection('users')
                            .document('sumanth')
                            .collection('grocery_cart')
                            .document(
                            '${widget.snap['product_id']}_price1}')
                            .updateData({
                          'quantity': variants[
                          '${widget.snap['product_id']}_price1']
                          ['quantity'] -
                              1,
                        });
                      } else {
                        await Firestore.instance
                            .collection('users')
                            .document('sumanth')
                            .collection('grocery_cart')
                            .document(
                            '${widget.product['product_id']}_price${index + 1}')
                            .delete();
                      }
                      setState(() {});*/
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black)),
                      child: Icon(
                        Icons.remove,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                  ),
                  Text(
                    '1'
                    /*variants['${widget.product['product_id']}_price${index + 1}']
                            ['quantity']
                        .toString()*/
                    ,
                    style: TextStyle(fontSize: 18),
                  ),
                  InkWell(
                    onTap: () async {
                      /*
                      await Firestore.instance
                          .collection('users')
                          .document('sumanth')
                          .collection('grocery_cart')
                          .document(
                          '${widget.product['product_id']}_price${index + 1}')
                          .updateData({
                        'quantity': variants[
                        '${widget.product['product_id']}_price${index + 1}']
                        ['quantity'] +
                            1,
                      });
                      setState(() {});*/
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black)),
                      child: Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (!widget.snap['stock'])
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hw)
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Product(product: widget.snap.data),
          ));
        },
        child: ScaleTransition(
          scale: animation,
          child: Container(
            padding: const EdgeInsets.only(bottom: 2),
            width: 160,
            height: 236,
            child: card(),
          ),
        ),
      );

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Product(product: widget.snap),
        ));
      },
      child: ScaleTransition(
        scale: animation,
        child: Container(
          child: card(),
        ),
      ),
    );
  }
}
