import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationHandler {
  List<Color> colors = [
    Color(0xffffaf00),
    Color(0xfffff700),
    Color(0xff00fd5d),
    Colors.cyanAccent,
    Colors.deepOrangeAccent
  ];
  String serverToken =
      'AAAARwUkrPg:APA91bF7MuNF46VnZq8grpnXfJRCjDUrapm5em9A48CCUUwSjjm5FatrH189-RMMMuaLgF5-HqXUERQPlMo1LZGb1DEls5dq_wX3VazvPJujVBSqJaXIomcjkUPg6sKJ1n5QM-ITdw9P';

  NotificationHandler._();
  String token;
  factory NotificationHandler() => instance;
  static final NotificationHandler instance = NotificationHandler._();
  final FirebaseMessaging fcm = FirebaseMessaging();
  bool initialized = false;

  Future<String> init(context) async {
    if (!initialized) {
      fcm.requestNotificationPermissions();
      fcm.configure(onMessage: (message) async {
        int c = 0;
        switch (message['data']['stage']) {
          case 'Accepted':
            c = 1;
            break;
          case 'Packed':
            c = 2;
            break;
          case 'Delivered':
            c = 3;
            break;
          case 'Rejected':
            c = 4;
            break;
        }
        ;
        showSimpleNotification(
          Text(
            message['notification']['body'],
          ),
          autoDismiss: true,
          background: colors[c],
          foreground: Colors.black,
          duration: Duration(seconds: 5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          position: NotificationPosition.bottom,
        );
      }, onResume: (message) async {
        debugPrint(message['data']['stage']);
      });

      // For testing purposes print the Firebase Messaging token
      token = await fcm.getToken();
      initialized = true;
    }
    return token;
  }

  Future<void> sendMessage(title, body, nt) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': nt,
        },
      ),
    );
  }
}
