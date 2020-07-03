import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  var product;

  Product({@required this.product});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                backgroundColor: Color(0xffa6e553),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.green))),
                  child: Carousel(
                    dotBgColor: Colors.transparent,
                    dotColor: Colors.black,
                    dotIncreasedColor: Colors.black,
                    autoplay: false,
                    dotSpacing: 16,
                    dotPosition: DotPosition.topRight,
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
                      children:
                          List.generate(widget.product['prices'], (index) {
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
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
                                          decoration:
                                              TextDecoration.lineThrough,
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
                              if (widget.product['stock'])
                                RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Color(0xffa6e553),
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.shopping_basket,
                                      size: 16,
                                    ),
                                    label: Text(
                                      'Add to cart',
                                      style: TextStyle(fontSize: 12),
                                    )),
                              if (false)
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.black)),
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.black)),
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
      ),
    );
  }
}
