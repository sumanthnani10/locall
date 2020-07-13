import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  String catName;
  VoidCallback onTap;
  int index;

  CategoryCard(this.catName, {@required this.onTap, @required this.index});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1).animate(_controller),
      child: GestureDetector(
        /*onTapDown: (d) {
          _controller.reverse(from: 0.9);
        },
        onTapCancel: () {
          _controller.forward();
        },*/
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: widget.onTap,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.fromLTRB(2, 8, 2, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.asset(
                        'assets/categories/${widget.catName}.jpg',
                      ),
                    ),
                    Text(
                      widget.catName,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
