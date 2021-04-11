import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sos_driver_app/base/di/locator.dart';
import 'package:sos_driver_app/utils/shared_prefs.dart';

class AppNotification {
  late String token;
  final prefs = locator<SharedPrefs>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Define a top-level named handler which background/terminated messages will
  /// call.
  ///
  /// To verify things are working, check out the native platform logs.
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  Future initialise() async {
    await Future.delayed(Duration(milliseconds: 2500));

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    print(settings.badge);

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'A new onMessageOpenedApp event was published! ${message.data.toString()}');
    });

    Future<void> onActionSelected(String value) async {
      switch (value) {
        case 'subscribe':
          {
            print(
                'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
            await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
            print(
                'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
          }
          break;
        case 'unsubscribe':
          {
            print(
                'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
            await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
            print(
                'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
          }
          break;
        case 'get_apns_token':
          {
            if (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.macOS) {
              print('FlutterFire Messaging Example: Getting APNs token...');
              token = await FirebaseMessaging.instance.getAPNSToken() ?? "";
              prefs.deviceToken = token;
              print('FlutterFire Messaging Example: Got APNs token: $token');
            } else {
              print(
                  'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
            }
          }
          break;
        default:
          break;
      }

      // createLocalNotification();
    }

    Future<void> _showNotification(Map<String, dynamic> message) async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your channel id', 'your channel name',
              'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      if (Platform.isIOS) {
        final payload = message;
        try {
          await flutterLocalNotificationsPlugin.show(
              0,
              message['aps']['alert']['title'],
              message['aps']['alert']['body'],
              platformChannelSpecifics,
              payload: jsonEncode(payload));
        } catch (e) {
          print("ERROR NOTIFICATION IOS");
        }
      }
      //ANDROID
      else {
        try {
          final payload = message['data'] != null
              ? message['data']
              : message['notification'];
          await flutterLocalNotificationsPlugin.show(
              0,
              message['notification']['title'],
              message['notification']['body'],
              platformChannelSpecifics,
              payload: jsonEncode(payload));
        } catch (e) {
          print("ERROR NOTIFICATION ANDROID");
        }
      }
    }

    void requestPermission() async {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
      );

      print(settings.badge);
    }
  }
}
