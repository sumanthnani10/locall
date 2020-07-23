import 'package:flutter/material.dart';
import 'package:locall/containers/focused_menu.dart';
import 'package:locall/containers/title_text.dart';

class CategoryScreen extends StatefulWidget {
  String category;
  List<dynamic> products;

  CategoryScreen(this.category, {@required this.products});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: TitleText(
          widget.category,
          cart: false,
          back: true,
          textSize: 20,
        ),
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
                          /*return ProductItem(
                            snap: visproducts[index],
                            hw: false,
                          );*/
                          return ProductCard(
                            hw: false,
                            snap: visproducts[index],
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
                          return ProductCard(
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
