import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Storage {
  static List<DocumentSnapshot> products;
  static List<DocumentSnapshot> cart;
  static List<String> cart_products_id = new List();
}
