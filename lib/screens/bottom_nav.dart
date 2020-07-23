import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:locall/containers/title_text.dart';
import 'package:locall/screens/categories_screen.dart';
import 'package:locall/screens/products_screen.dart';
import 'package:locall/screens/profile.dart';
import 'package:locall/service/notification_handler.dart';
import 'package:locall/storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  int sel = 2;
  String appBarTitle = 'Home';
  TabController tabController;

  @override
  void initState() {
    NotificationHandler.instance.init(context);
    tabController = new TabController(length: 4, vsync: this, initialIndex: 2);
    tabController.addListener(() {
      setState(() {
        int i = tabController.index;
        sel = i;
        if (i == 0) {
          appBarTitle = 'Categories';
        }
        if (i == 1) {
          appBarTitle = 'Store';
        }
        if (i == 2) {
          appBarTitle = 'Home';
        }
        if (i == 3) {
          appBarTitle = 'Profile';
        }
      });
    });
    super.initState();
    getCart();
  }

  getCart() async {
    Firestore.instance
        .collection('users')
        .document('${Storage.user['customer_id']}')
        .collection('grocery_cart')
        .snapshots()
        .listen((value) {
      setState(() {
        Storage.cart = value.documents;
        Storage.cart_products_id.length = 0;
        Storage.cart.forEach((element) {
          Storage.cart_products_id.add(element['product_id']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: TitleText(
          appBarTitle,
          cart: false,
        ),
      ),
      backgroundColor: Color(0xffa6e553),
      body: TabBarView(
        children: <Widget>[
          CategoriesScreen(),
          ProductsScreen(),
          //Home Screen
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Storage.area_details['groceries']['store_name'],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Order by',
                  style: TextStyle(
                      fontSize: 18, decoration: TextDecoration.underline),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Call',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Icon(
                      Icons.call,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () async {
                        if (await canLaunch('tel:9157871432')) {
                          await launch('tel:9157871432');
                        } else {
                          throw 'Could not launch tel:9157871432';
                        }
                      },
                      child: Text(
                        Storage.area_details['groceries']['mobile'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Message',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Icon(
                      Icons.message,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () async {
                        if (await canLaunch('sms:9157871432')) {
                          await launch('sms:9157871432');
                        } else {
                          throw 'Could not launch sms:9157871432';
                        }
                      },
                      child: Text(
                        Storage.area_details['groceries']['message'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Whatsapp',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () async {
                        String url() {
                          if (Platform.isIOS) {
                            return "whatsapp://wa.me/919157871432";
                          } else {
                            return "whatsapp://send?phone=919157871432";
                          }
                        }

                        if (await canLaunch(url())) {
                          await launch(url());
                        } else {
                          throw 'Could not launch ${url()}';
                        }
                      },
                      child: Text(
                        Storage.area_details['groceries']['whatsapp'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'App',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    FaIcon(
                      FontAwesomeIcons.mobileAlt,
                      size: 16,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        tabController.animateTo(1);
                      },
                      child: Text(
                        'Go to Store',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Profile()
        ],
        controller: tabController,
        physics: BouncingScrollPhysics(),
      ),
      bottomNavigationBar: PersistentBottomNavBar(
        navBarHeight: 64,
        showElevation: true,
        navBarStyle: NavBarStyle.style1,
        selectedIndex: sel,
        backgroundColor: Colors.white,
        popScreensOnTapOfSelectedTab: false,
        onItemSelected: (i) {
          setState(() {
            sel = i;
            tabController.animateTo(sel);
            if (i == 0) {
              appBarTitle = 'Categories';
            }
            if (i == 1) {
              appBarTitle = 'Store';
            }
            if (i == 2) {
              appBarTitle = 'Home';
            }
            if (i == 3) {
              appBarTitle = 'Profile';
            }
          });
        },
        items: <PersistentBottomNavBarItem>[
          PersistentBottomNavBarItem(
            icon: Icon(
              Icons.view_module,
            ),
            activeColor: Colors.green,
            inactiveColor: Colors.orange,
            title: 'Categories',
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.category),
            activeColor: Colors.green,
            inactiveColor: Colors.orange,
            title: 'Store',
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.home),
            title: 'Home',
            activeColor: Colors.green,
            inactiveColor: Colors.orange,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.person),
            title: 'Profile',
            activeColor: Colors.green,
            inactiveColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
