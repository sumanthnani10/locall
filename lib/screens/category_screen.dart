import 'package:flutter/material.dart';
import 'package:locall/containers/product_item.dart';

import 'bottom_nav.dart';

class CategoryScreen extends StatefulWidget {
  String category;
  List<dynamic> products;

  CategoryScreen(@required this.category, {@required this.products});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xffa6e553),
      ),
      backgroundColor: Color(0xffa6e553),
      body: Container(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
        child: widget.products.length != 0
            ? LayoutBuilder(
                builder: (context, constraints) {
                  List<dynamic> visproducts = widget.products;
                  /*visproducts = visproducts.where((e) {
                      if (e['name']
                          .toString()
                          .toLowerCase()
                          .contains(search.toLowerCase()))
                        return true;
                      else
                        return false;
                    else {
                      print(e['category']);
                      if (e['name']
                              .toString()
                              .toLowerCase()
                              .contains(search.toLowerCase()) &&
                          e['category'] == viewCat)
                        return true;
                      else
                        return false;
                    }
                  }).toList();*/
                  if (visproducts.length != 0) {
                    if (constraints.maxWidth <= 600) {
                      return GridView.count(
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 0.72,
                        children: List.generate(visproducts.length, (index) {
                          return ProductItem(
                            snap: visproducts[index],
                            hw: false,
                          );
                        }),
                      );
                    } else {
                      return GridView.count(
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        childAspectRatio: 0.68,
                        children: List.generate(visproducts.length, (index) {
                          return ProductItem(
                            snap: visproducts[index],
                            hw: false,
                          );
                        }),
                      );
                    }
                  } else {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text('No Products'),
                    ));
                  }
                },
              )
            : Center(
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text('No Products'),
              )),
      ),
    );
  }
}
