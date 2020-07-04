import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locall/containers/title_text.dart';
import 'package:locall/screens/categories_screen.dart';
import 'package:locall/screens/products_screen.dart';
import 'package:locall/storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  int sel = 1;
  String appBarTitle = 'Store';
  TabController tabController;

  @override
  void initState() {
    tabController = new TabController(length: 4, vsync: this, initialIndex: 1);
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
          appBarTitle = 'Settings';
        }
      });
    });
    super.initState();
    getCart();
  }

  getCart() async {
    await Firestore.instance
        .collection('users')
        .document('sumanth')
        .collection('grocery_cart')
        .snapshots()
        .listen((value) {
      setState(() {
        Storage.cart = value.documents;
//        print(Storage.cart[0]['a']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
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
          Container(),
          Container(),
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
              appBarTitle = 'Settings';
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
            icon: Icon(Icons.settings),
            title: 'Settings',
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
