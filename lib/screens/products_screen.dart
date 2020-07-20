import 'package:flutter/material.dart';
import 'package:locall/containers/focused_menu.dart';
import 'package:locall/containers/product_item.dart';
import 'package:locall/containers/title_text.dart';
import 'package:locall/screens/category_screen.dart';
import 'package:locall/storage.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  List<String> categories = [
    'New Arrivals',
    'Atta & Flour',
    'Beverages',
    'Body Sprays',
    'Chocolates',
    'Cleaners',
    'Dals & Pulses',
    'Dairy',
    'Dry Fruits',
    'Edible Oils',
    'Hair Oils',
    'Masala',
    'Patanjali',
    'Personal Hygiene',
    'Pooja Products',
    'Rice & Rice Products',
    'Salt, Sugar & Tea',
    'Snacks and Food',
    'Soaps and Shampoo',
    'Spices',
    'Stationary',
    'Vegetables',
    'Others',
  ];

  List<dynamic> t;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffa6e553),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Storage.cart == null
            ? Column(
                children: <Widget>[
                  LinearProgressIndicator(),
                ],
              )
            : Container(
                padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                child: Storage.products.length != 0
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          List<dynamic> visproducts = Storage.products;
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
                                children:
                                    List.generate(visproducts.length, (index) {
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
                                children:
                                    List.generate(visproducts.length, (index) {
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
      ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
/*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(categories.length, (i) {
                    if (categories[i] == categories[0]) {
                      t = Storage.products;
                      t.sort((a, b) {
                        if (b['creation']
                            .toDate()
                            .isBefore(a['creation'].toDate()))
                          return -1;
                        else
                          return 1;
                      });
                    } else {
                      t = List.from(Storage.products.where((element) {
                        return element['category'] == categories[i];
                      }));
                    }
                    if (t.length == 0) {
                      return Container();
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              categories[i],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List<Widget>.generate(
                                      t.length < 5 ? t.length : 5, (index) {
                                    return ProductCard(
                                      snap: t[index].data,
                                      hw: true,
                                    );
                                  }).toList() +
                                  [
                                    if (categories[i] != categories[0])
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              createRoute(CategoryScreen(
                                                  categories[i], products:
                                                      List.from(Storage.products
                                                          .where((element) {
                                            return element['category'] ==
                                                categories[i];
                                          })))));
                                        },
                                        child: Container(
                                          width: 160,
                                          height: 236,
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'More',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.indigo),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          )
                        ],
                      );
                    }
                  }).toList(),
                )*/
