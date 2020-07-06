import 'package:flutter/material.dart';
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
    'Dry Fruits & Masala',
    'Dals & Pulses',
    'Rice & Rice Products',
    'Atta & Flour',
    'Salt & Sugar',
    'Snacks & Food',
    'Soaps & Shampoo',
    'Cleaners',
    'Hair Oils',
    'Body Sprays',
    'Chocolates',
    'Personal Hygiene',
    'Agarbathhi',
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(categories.length, (i) {
              if (categories[i] == categories[0]) {
                t = Storage.products;
                t.sort((a, b) {
                  /*if (a['creation'] == null) {
                    print(a['name']);
                  }
                  if (a['creation'] == null) return -1;
                  if (b['creation'] == null) return 1;*/
                  if (a['creation'].toDate().isBefore(b['creation'].toDate()))
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              return ProductItem(
                                snap: t[index],
                                hw: true,
                              );
                            }).toList() +
                            [
                              if (categories[i] != categories[0])
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(createRoute(
                                        CategoryScreen(categories[i], products:
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
                                        borderRadius: BorderRadius.circular(8),
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
