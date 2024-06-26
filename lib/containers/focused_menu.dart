import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locall/screens/product_view_screen.dart';
import 'package:locall/storage.dart';

class ProductCard extends StatefulWidget {
  var snap;
  bool hw;
  final double menuItemExtent;
  final double menuWidth;
  final bool animateMenuItems;
  final BoxDecoration menuBoxDecoration;
  final Duration duration;
  final double blurSize;
  final Color blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;

  ProductCard(
      {Key key,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      @required this.snap,
      @required this.hw})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> variants = new Map<String, dynamic>();
/*  AnimationController _controller;
  Animation<double> animation;*/

  Widget child;

  @override
  void initState() {
    super.initState();
    /*_controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500) */ /*, value: 0.1*/ /*);
    animation = CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn);
    _controller.forward();*/
  }

  @override
  void dispose() {
//    _controller.dispose();
    super.dispose();
  }

  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size childSize;

  getOffset() {
    RenderBox renderBox = containerKey.currentContext.findRenderObject();
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      this.childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

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
                  onPressed: () async {
                    if (widget.snap['prices'] != 1) {
                      getOffset();
                      await Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration: widget.duration ??
                                  Duration(milliseconds: 100),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                animation = Tween(begin: 0.0, end: 1.0)
                                    .animate(animation);
                                return FadeTransition(
                                    opacity: animation,
                                    child: FocusedMenuDetails(
                                      snap: widget.snap,
                                      itemExtent: widget.menuItemExtent,
                                      menuBoxDecoration:
                                          widget.menuBoxDecoration,
                                      child: child,
                                      childOffset: childOffset,
                                      childSize: childSize,
                                      blurSize: widget.blurSize,
                                      menuWidth: widget.menuWidth,
                                      blurBackgroundColor:
                                          widget.blurBackgroundColor,
                                      animateMenu:
                                          widget.animateMenuItems ?? true,
                                      bottomOffsetHeight:
                                          widget.bottomOffsetHeight ?? 0,
                                      menuOffset: widget.menuOffset ?? 0,
                                    ));
                              },
                              fullscreenDialog: true,
                              opaque: false));
                    } else {
                      showLoadingDialog(context, 'Adding to Cart');
                      await Firestore.instance
                          .collection('users')
                          .document('${Storage.user['customer_id']}')
                          .collection('grocery_cart')
                          .document('${widget.snap['product_id']}_price1')
                          .setData({
                        'product_id': widget.snap['product_id'],
                        'price_num': 1,
                        'quantity': 1,
                      });
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
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
                  onPressed: () async {
                    getOffset();
                    await Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration:
                                widget.duration ?? Duration(milliseconds: 100),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              animation = Tween(begin: 0.0, end: 1.0)
                                  .animate(animation);
                              return FadeTransition(
                                  opacity: animation,
                                  child: FocusedMenuDetails(
                                    snap: widget.snap,
                                    itemExtent: widget.menuItemExtent,
                                    menuBoxDecoration: widget.menuBoxDecoration,
                                    child: child,
                                    childOffset: childOffset,
                                    childSize: childSize,
                                    blurSize: widget.blurSize,
                                    menuWidth: widget.menuWidth,
                                    blurBackgroundColor:
                                        widget.blurBackgroundColor,
                                    animateMenu:
                                        widget.animateMenuItems ?? true,
                                    bottomOffsetHeight:
                                        widget.bottomOffsetHeight ?? 0,
                                    menuOffset: widget.menuOffset ?? 0,
                                  ));
                            },
                            fullscreenDialog: true,
                            opaque: false));
                  },
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
                      if (variants['${widget.snap['product_id']}_price1']
                              ['quantity'] !=
                          1) {
                        showLoadingDialog(context, 'Updating Cart');
                        await Firestore.instance
                            .collection('users')
                            .document('${Storage.user['customer_id']}')
                            .collection('grocery_cart')
                            .document('${widget.snap['product_id']}_price1')
                            .updateData({
                          'quantity':
                              variants['${widget.snap['product_id']}_price1']
                                      ['quantity'] -
                                  1,
                        });
                        Navigator.pop(context);
                      } else {
                        showLoadingDialog(context, 'Removing from Cart');
                        await Firestore.instance
                            .collection('users')
                            .document('${Storage.user['customer_id']}')
                            .collection('grocery_cart')
                            .document('${widget.snap['product_id']}_price1')
                            .delete();
                        Navigator.pop(context);
                      }
                      setState(() {});
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
                    variants['${widget.snap['product_id']}_price1']['quantity']
                        .toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  InkWell(
                    onTap: () async {
                      showLoadingDialog(context, 'Updating Cart');
                      await Firestore.instance
                          .collection('users')
                          .document('${Storage.user['customer_id']}')
                          .collection('grocery_cart')
                          .document('${widget.snap['product_id']}_price1')
                          .updateData({
                        'quantity':
                            variants['${widget.snap['product_id']}_price1']
                                    ['quantity'] +
                                1,
                      });
                      Navigator.pop(context);
                      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    var t;
    for (int index = 0; index < widget.snap['prices']; index++) {
      if ((t = Storage.cart.singleWhere((element) {
            return element.documentID ==
                '${widget.snap['product_id']}_price${index + 1}';
          }, orElse: () {
            return null;
          })) !=
          null) {
        variants['${widget.snap['product_id']}_price${index + 1}'] = t.data;
      } else {
        variants['${widget.snap['product_id']}_price${index + 1}'] = null;
      }
    }
    child = widget.hw
        ? InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Product(product: widget.snap),
              ));
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 2),
              width: 160,
              height: 236,
              child: card(),
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Product(product: widget.snap.data),
              ));
            },
            child: Container(
              child: card(),
            ),
          );
    return GestureDetector(key: containerKey, child: child);
  }
}

class FocusedMenuDetails extends StatefulWidget {
  final BoxDecoration menuBoxDecoration;
  final Offset childOffset;
  final double itemExtent;
  final Size childSize;
  final Widget child;
  final bool animateMenu;
  final double blurSize;
  final double menuWidth;
  final Color blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;
  final snap;

  FocusedMenuDetails(
      {Key key,
      @required this.snap,
      @required this.child,
      @required this.childOffset,
      @required this.childSize,
      @required this.menuBoxDecoration,
      @required this.itemExtent,
      @required this.animateMenu,
      @required this.blurSize,
      @required this.blurBackgroundColor,
      @required this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset})
      : super(key: key);

  @override
  _FocusedMenuDetailsState createState() => _FocusedMenuDetailsState();
}

class _FocusedMenuDetailsState extends State<FocusedMenuDetails> {
  List<Widget> menuItems;

  Map<String, dynamic> variants = new Map<String, dynamic>();

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

  @override
  Widget build(BuildContext context) {
    var t;
    for (int index = 0; index < widget.snap['prices']; index++) {
      if ((t = Storage.cart.singleWhere((element) {
            return element.documentID ==
                '${widget.snap['product_id']}_price${index + 1}';
          }, orElse: () {
            return null;
          })) !=
          null) {
        variants['${widget.snap['product_id']}_price${index + 1}'] = t.data;
      } else {
        variants['${widget.snap['product_id']}_price${index + 1}'] = null;
      }
    }
    this.menuItems = List.generate(widget.snap['prices'], (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.snap['quantity_${index + 1}'].toString() != '0'
                  ? 'Rs.${widget.snap['price_${index + 1}']} - ${widget.snap['quantity_${index + 1}']}${widget.snap['unit_${index + 1}']}'
                  : 'Rs.${widget.snap['price_${index + 1}']}',
              style: TextStyle(fontSize: 12, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (widget.snap['price_${index + 1}'] !=
                widget.snap['mrp_${index + 1}'])
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 4,
                  ),
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
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${((widget.snap['mrp_${index + 1}'] - widget.snap['price_${index + 1}']) / widget.snap['mrp_${index + 1}'] * 100).round()}%',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            Spacer(),
            if (widget.snap['stock'] &&
                variants['${widget.snap['product_id']}_price${index + 1}'] ==
                    null)
              RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Color(0xffa6e553),
                  onPressed: () async {
                    showLoadingDialog(context, 'Adding to Cart');
                    await Firestore.instance
                        .collection('users')
                        .document('${Storage.user['customer_id']}')
                        .collection('grocery_cart')
                        .document(
                            '${widget.snap['product_id']}_price${index + 1}')
                        .setData({
                      'product_id': widget.snap['product_id'],
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
            if (widget.snap['stock'] &&
                variants['${widget.snap['product_id']}_price${index + 1}'] !=
                    null)
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      if (variants[
                                  '${widget.snap['product_id']}_price${index + 1}']
                              ['quantity'] !=
                          1) {
                        showLoadingDialog(context, 'Updating Cart');
                        await Firestore.instance
                            .collection('users')
                            .document('${Storage.user['customer_id']}')
                            .collection('grocery_cart')
                            .document(
                                '${widget.snap['product_id']}_price${index + 1}')
                            .updateData({
                          'quantity': variants[
                                      '${widget.snap['product_id']}_price${index + 1}']
                                  ['quantity'] -
                              1,
                        });
                        Navigator.pop(context);
                      } else {
                        showLoadingDialog(context, 'Removing from Cart');
                        await Firestore.instance
                            .collection('users')
                            .document('${Storage.user['customer_id']}')
                            .collection('grocery_cart')
                            .document(
                                '${widget.snap['product_id']}_price${index + 1}')
                            .delete();
                        Navigator.pop(context);
                      }
                      setState(() {});
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
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    variants['${widget.snap['product_id']}_price${index + 1}']
                            ['quantity']
                        .toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () async {
                      showLoadingDialog(context, 'Updating Cart');
                      await Firestore.instance
                          .collection('users')
                          .document('${Storage.user['customer_id']}')
                          .collection('grocery_cart')
                          .document(
                              '${widget.snap['product_id']}_price${index + 1}')
                          .updateData({
                        'quantity': variants[
                                    '${widget.snap['product_id']}_price${index + 1}']
                                ['quantity'] +
                            1,
                      });
                      Navigator.pop(context);
                      setState(() {});
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
    }).toList();
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.5;
    final listHeight = menuItems.length * (widget.itemExtent ?? 56.0);

    final maxMenuWidth = 300.0;
    final menuHeight =
        listHeight < maxMenuHeight ? listHeight + 12 : maxMenuHeight;
    final leftOffset = (widget.childOffset.dx + maxMenuWidth) < size.width
        ? widget.childOffset.dx
        : (widget.childOffset.dx - maxMenuWidth + widget.childSize.width);
    final topOffset = (widget.childOffset.dy +
                menuHeight +
                widget.childSize.height) <
            size.height - widget.bottomOffsetHeight
        ? widget.childOffset.dy + widget.childSize.height + widget.menuOffset
        : widget.childOffset.dy - menuHeight - widget.menuOffset;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: (widget.blurBackgroundColor ?? Colors.black)
                      .withOpacity(0.2),
                )),
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                builder: (BuildContext context, value, Widget child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: widget.menuBoxDecoration ??
                      BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            const BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                spreadRadius: 1)
                          ]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Widget item = menuItems[index];
                        if (widget.animateMenu) {
                          return TweenAnimationBuilder(
                              builder: (context, value, child) {
                                return Transform(
                                  transform: Matrix4.rotationX(1.5708 * value),
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                );
                              },
                              tween: Tween(begin: 1.0, end: 0.0),
                              duration: Duration(milliseconds: index * 200),
                              child: item);
                        } else {
                          return item;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: widget.childOffset.dy,
                left: widget.childOffset.dx,
                child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                        width: widget.childSize.width,
                        height: widget.childSize.height,
                        child: widget.child))),
          ],
        ),
      ),
    );
  }
}
