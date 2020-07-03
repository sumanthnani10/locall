import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locall/containers/title_text.dart';

class Cart extends StatefulWidget {
  var cart;

  Cart({this.cart});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
            TitleText(
              'Cart',
              cart: true,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //TODO: change this to List.generate
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(4),
                constraints: BoxConstraints(maxWidth: 400, maxHeight: 98),
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
                        widget.cart['image'],
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
                            widget.cart['name'],
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            widget.cart['category'],
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.cart['quantity_1'].toString() != '0'
                                    ? 'Rs.${widget.cart['price_1']}/${widget.cart['quantity_1']}${widget.cart['unit_1']}'
                                    : 'Rs.${widget.cart['price_1']}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (widget.cart['price_1'] !=
                                  widget.cart['mrp_1'])
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'Rs.${widget.cart['mrp_1']}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '(${((widget.cart['mrp_1'] - widget.cart['price_1']) / widget.cart['mrp_1'] * 100).round()}%)',
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RupeeText(
                                amount: 2500,
                                size: 18,
                                color: Colors.green[800],
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              //TODO: add if mrp is diff
                              Text(
                                '2750',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
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
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black)),
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
                          '1',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black)),
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
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Total:  '),
                    RupeeText(
                      amount: 2500,
                      color: Colors.green,
                      fontWeight: FontWeight.w800,
                      size: 24,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '2750',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(' (You Save: 9%)',
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.greenAccent,
                onPressed: () {},
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
      ),
      backgroundColor: Color(0xffa6e553),
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
