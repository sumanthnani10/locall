import 'package:flutter/material.dart';
import 'package:locall/containers/category_card.dart';
import 'package:locall/screens/category_screen.dart';
import 'package:locall/storage.dart';

class CategoriesScreen extends StatelessWidget {
  List<String> categories = [
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
    //'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffa6e553),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            return GridView.count(
              crossAxisCount: 2,
              children: List.generate(categories.length, (index) {
                return CategoryCard(
                  categories[index],
                  onTap: () {
                    Navigator.of(context).push(createRoute(CategoryScreen(
                        categories[index],
                        products: List.from(Storage.products.where((element) {
                      return element['category'] == categories[index];
                    })))));
                  },
                  index: (index % 2) + 1,
                );
              }).toList(),
            );
          } else {
            return GridView.count(
              crossAxisCount: 4,
              children: List.generate(categories.length, (index) {
                return CategoryCard(
                  categories[index],
                  onTap: () {
                    Navigator.of(context).push(createRoute(CategoryScreen(
                        categories[index],
                        products: List.from(Storage.products.where((element) {
                      return element['category'] == categories[index];
                    })))));
                  },
                  index: (index % 2) + 1,
                );
              }).toList(),
            );
          }
        }),
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
}
