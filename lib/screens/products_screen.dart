import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locall/containers/focused_menu.dart';
import 'package:locall/storage.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  List<String> categories = [
    'Dry Fruits',
    'Rice & Rice Products',
    'Edible Oils',
    'Spices',
    'Dals & Pulses',
    'Atta & Flour',
    'Salt, Sugar & Tea',
    'Pooja Products',
    'Body Sprays',
    'Soaps and Shampoo',
    'Personal Hygiene',
    'Snacks and Food',
    'Hair Oils',
    'Masala',
    'Cleaners',
    'Chocolates',
    'Beverages',
    'Others',
    'Vegetables',
    'Stationary',
    'Dairy',
    'Patanjali',
  ];

  List<String> sortList = [
    'Default',
    'Name - A->Z',
    'Name - Z->A',
    'Latest',
    'Oldest',
  ];
  int sort = 0;
  List<dynamic> allproducts, visproducts;
  List<String> filterCats = new List<String>();

  String search = '';
  TextEditingController search_controller = new TextEditingController();
  bool searching = false;

  ScrollController scrollController = new ScrollController();
  int viewItems = 20;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        viewItems+=20;
        setState(() {});
      }
    });
    allproducts = Storage.products.sublist(0);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          padding:
                              const EdgeInsets.only(top: 8, left: 4, right: 4),
                          child: Storage.products.length != 0
                              ? LayoutBuilder(
                                  builder: (context, constraints) {
                                    visproducts = allproducts.where((e) {
                                      if (e['name']
                                          .toLowerCase()
                                          .contains(search)) {
                                        if (filterCats.length == 0) {
                                          return true;
                                        } else {
                                          return filterCats
                                              .contains(e['category']);
                                        }
                                      } else {
                                        return false;
                                      }
                                    }).toList();
                                    switch (sort) {
                                      case 0:
                                        visproducts.sort((a, b) =>
                                            categories.indexOf(a['category']) -
                                            categories.indexOf(b['category']));
                                        break;
                                      case 1:
                                        visproducts.sort((a, b) =>
                                            a['name'].compareTo(b['name']));
                                        break;
                                      case 2:
                                        visproducts.sort((a, b) =>
                                            b['name'].compareTo(a['name']));
                                        break;
                                      case 3:
                                        visproducts.sort((a, b) {
                                          if (b['creation']
                                              .toDate()
                                              .isBefore(a['creation'].toDate()))
                                            return -1;
                                          else
                                            return 1;
                                        });
                                        break;
                                      case 4:
                                        visproducts.sort((a, b) {
                                          if (a['creation']
                                              .toDate()
                                              .isBefore(b['creation'].toDate()))
                                            return -1;
                                          else
                                            return 1;
                                        });
                                        break;
                                    }
                                    if (visproducts.length != 0) {
                                      if (constraints.maxWidth <= 600) {
                                        return GridView.count(
                                          physics: BouncingScrollPhysics(),
                                          crossAxisCount: 2,
                                          shrinkWrap: true,
                                          childAspectRatio: 0.72,
                                          children:
                                              List<Widget>.generate(min<int>(viewItems, visproducts.length), (index) {
                                            return ProductCard(
                                              hw: false,
                                              snap: visproducts[index],
                                            );
                                          })+[Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Center(child: Text(search!=''?'':viewItems==visproducts.length?'____':'Loading....')),
                                              )],
                                        );
                                      } else {
                                        return GridView.count(
                                          physics: BouncingScrollPhysics(),
                                          crossAxisCount: 4,
                                          shrinkWrap: true,
                                          childAspectRatio: 0.68,
                                          children:
                                              List<Widget>.generate(min<int>(viewItems, visproducts.length), (index) {
                                            return ProductCard(
                                              snap: visproducts[index],
                                              hw: false,
                                            );
                                          })+[Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Center(child: Text(search!=''?'':viewItems==visproducts.length?'____':'Loading....')),
                                              )],
                                        );
                                      }
                                    } else {
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 32),
                                        child: Text('No Products'),
                                      ));
                                    }
                                  },
                                )
                              : Center(
                                  child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 32),
                                  child: Text('No Products'),
                                )),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Container(
                        color: Color(0xffa6e553),
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  searching = !searching;
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Search',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    enableDrag: true,
                                    backgroundColor: Colors.transparent,
                                    useRootNavigator: true,
                                    elevation: 0,
                                    builder: (c) {
                                      bool showCats = false;
                                      return StatefulBuilder(
                                        builder: (c, setMState) => SafeArea(
                                          child: Container(
                                            color: Colors.white,
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            margin:
                                                const EdgeInsets.only(top: 32),
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Container(
                                                    height: 4,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons.arrow_back),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                      Text(
                                                        'Filter',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 24,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Done',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Material(
                                                  child: InkWell(
                                                    splashColor: Colors.black12,
                                                    onTap: () {
                                                      setMState(() {
                                                        showCats = !showCats;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 16,
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border.symmetric(
                                                              vertical: BorderSide(
                                                                  color: Colors
                                                                      .black54))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            'Categories',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          Icon(Icons
                                                              .keyboard_arrow_down)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (showCats)
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: List.generate(
                                                            categories.length,
                                                            (index) => InkWell(
                                                                  onTap: () {
                                                                    if (!filterCats
                                                                        .contains(
                                                                            categories[index]))
                                                                      filterCats.add(
                                                                          categories[
                                                                              index]);
                                                                    else
                                                                      filterCats
                                                                          .remove(
                                                                              categories[index]);
                                                                    setMState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Checkbox(
                                                                            value:
                                                                                filterCats.contains(categories[index]),
                                                                            onChanged: (v) {
                                                                              if (v)
                                                                                filterCats.add(categories[index]);
                                                                              else
                                                                                filterCats.remove(categories[index]);
                                                                              setMState(() {});
                                                                            }),
                                                                        Text(
                                                                          categories[
                                                                              index],
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                      ),
                                                    ),
                                                  ),
                                                if (!showCats)
                                                  SizedBox(
                                                    height: 64,
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).whenComplete(() => setState(() {}));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.filter_list,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Filter',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    enableDrag: true,
                                    backgroundColor: Colors.transparent,
                                    useRootNavigator: true,
                                    elevation: 0,
                                    builder: (c) {
                                      return StatefulBuilder(
                                        builder: (c, setMState) => Wrap(
                                          children: <Widget>[
                                            Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.only(
                                                  top: 16),
                                              child: Column(
                                                children: <Widget>[
                                                  Center(
                                                    child: Container(
                                                      height: 4,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        IconButton(
                                                            icon: Icon(Icons
                                                                .arrow_back),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        Text(
                                                          'Sort By',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 24,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Done',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    children: List.generate(
                                                        sortList.length,
                                                        (index) => ListTile(
                                                              onTap: () {
                                                                setMState(() {
                                                                  sort = index;
                                                                });
                                                              },
                                                              title: Text(
                                                                sortList[index],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              leading: Radio(
                                                                  value: index,
                                                                  groupValue:
                                                                      sort,
                                                                  onChanged:
                                                                      (v) {
                                                                    setMState(
                                                                        () {
                                                                      sort = v;
                                                                    });
                                                                  }),
                                                            )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).whenComplete(() => setState(() {}));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.sort,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Sort',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (searching)
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          padding: const EdgeInsets.only(top: 4),
                          child: Theme(
                            data: ThemeData(primaryColor: Colors.white),
                            child: TextField(
                              autofocus: true,
                              onChanged: (v) {
                                setState(() {
                                  search = v;
                                });
                              },
                              decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        search_controller.text = '';
                                        search = '';
                                      });
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: search == ''
                                          ? Colors.white
                                          : Colors.black,
                                      size: 16,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  hintText: 'Search',
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black54,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  fillColor: Colors.white),
                            ),
                          ),
                        ),
                      ),
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
