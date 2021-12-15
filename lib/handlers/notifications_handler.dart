import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:strykepay_merchant/dataHandling/altered_endpoints.dart';
import 'package:strykepay_merchant/handlers/qr_screen_handler.dart';
import 'package:strykepay_merchant/models/user.dart';
import 'package:strykepay_merchant/screens/qr_screen.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_page.dart';

import '../dataHandling/userProfile/onboarding_user_credentials.dart';

import 'package:flutter/material.dart';
import '../dataHandling/receipt.dart';
import '../models/receipt.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../notofication_api.dart';

import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:strykepay_merchant/dataHandling/shared_prefs.dart';
import 'package:strykepay_merchant/main.dart';

class DataWrapper {
  dynamic data;
}

//SharedPrefs prefs = SharedPrefs();

//final prefs = SharedPrefs();

class NotificationsHandler extends ChangeNotifier {
  static SendPort uiSendPort;

  // If enabled it will post a notification whenever the task is running. Handy for debugging tasks);
  static Future<void> callback() async {
    List<String> newNotifications = [];
    delivered() async {
      var response = await http.put(
        Uri.parse(
            "https://profile.services.strykepay.co.uk/merchant/delivered"),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{"notifications": newNotifications}),
      );
      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        return false;
      }
    }

    getNonDelivered() async {
      var headers = {'Authorization': 'Bearer $userToken'};
      print("Token is " + userToken.toString());
      var response = await http.get(
        Uri.https(
          "singlepayment.strykepay.co.uk",
          '/merchant/nonDelivered',
          {},
        ),
        headers: <String, String>{
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        for (var payment in decodedData) {
          newNotifications.add((payment["_id"]));
        }
        return true;
      } else {
        print(response.body);
        return false;
      }
    }

    if (Platform.isIOS) {
      NotificationApi.init();
      print("isIos");

      var scheduledNotificationDateTime =
          DateTime.now().add(Duration(seconds: 10));
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(iOS: iOSPlatformChannelSpecifics);
      print("scheduling");
      void onDidReceiveLocalNotification(
          int id, String title, String body, String payload) async {
        // display a dialog with the notification details, tap ok to go to another page
        print("recieved");
      }

      //print("iso name " + isolateName);
      //prefs.reload();
      // print("user id being sent is" + id);
      IO.Socket socket;
      //socket.disconnect();
/*    NotificationApi.showNotification(
      title: "Socket Checking",
      body: "TEST Alarm Manager",
      payload: "TEST",
    );*/
      socket = IO.io(
          'https://notification.strykepay.co.uk',
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setQuery({"_id": userInfo.id})
              .build());
      //TODO took this out to experiment
      socket.connect();
      socket.onConnect((_) async {
        print('connect');
        /*     NotificationApi.showNotification(
          title: "StrykePay",
          body: "Welcome to StrykePay",
          payload: "",
        );*/
      });
      socket.on('notificationSuccess', (data) {
        print("received");
        print(data.toString());
        TransactionPage.isTrying = false;
        Map<String, dynamic> map = Map<String, dynamic>.from(data);
        print("Msp is " + map.toString());
        TransactionPage.paymentSuccess = true;
        TransactionPage.paymentFailure = false;
        NotificationApi.showNotification(
          title: "Payment Complete",
          body: map["text"],
          payload: "TEST",
        );
        print("notification success");
/*
        socket.onDisconnect((data) => NotificationApi.showNotification(
              title: "Please Open Your StrykePay App to Recieve Notifications",
              body: "TEST",
              payload: "TEST",
            ));*/
        //lastNotification(data["payerId"]);;
      });
      socket.on('notificationFail', (data) {
        print(data.toString());
        print("received fail");
        TransactionPage.isTrying = false;
        Map<String, dynamic> map = Map<String, dynamic>.from(data);
        print("Msp is " + map.toString());
        TransactionPage.paymentFailure = true;
        TransactionPage.paymentSuccess = false;
        NotificationApi.showNotification(
          title: "Payment Failed",
          body: map["text"],
          payload: "TEST",
        );
        print("notification fail");
/*
        socket.onDisconnect((data) => NotificationApi.showNotification(
              title: "Please Open Your StrykePay App to Recieve Notifications",
              body: "TEST",
              payload: "TEST",
            ));*/
        //lastNotification(data["payerId"]);;
      });
      /*   await FlutterLocalNotificationsPlugin()
          .periodicallyShow(0, 'scheduled title', 'scheduled body',
              RepeatInterval.everyMinute, platformChannelSpecifics)
          .whenComplete(() {
        print("doooone");
      });*/
    } else {
      prefs = await SharedPreferences.getInstance();
      print("calling alarm manager");
      try {
        print("id is " + prefs.getString("id"));
      } catch (e) {}
      await AndroidAlarmManager.oneShot(
        const Duration(minutes: 20),
        // Ensure we have a unique alarm ID.
        Random().nextInt(pow(2, 31)),
        NotificationsHandler.callback,
        exact: true,
        wakeup: true,
      );

      ///test doc
      ///
      /// test doc 2
      prefs = await SharedPreferences.getInstance();
      developer.log('Alarm fired!');
      //print("iso name " + isolateName);
      //prefs.reload();
      // print("user id being sent is" + id);
      IO.Socket socket;
      //socket.disconnect();
/*    NotificationApi.showNotification(
      title: "Socket Checking",
      body: "TEST Alarm Manager",
      payload: "TEST",
    );*/
      socket = IO.io(
          'https://notification.strykepay.co.uk',
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setQuery({"_id": prefs.getString("id")})
              .build());
      //TODO took this out to experiment
      socket.connect();
      socket.onConnect((_) async {
        /*    if (await getNonDelivered()) {
          await delivered();
        }*/
        print('connect');
/*      NotificationApi.showNotification(
        title: "StrykePay",
        body: "Welcome to StrykePay",
        payload: "",
      );*/
      });
      socket.on('notificationSuccess', (data) {
        print("received");
        print(data.toString());
        qrHandler.setComplete(true);

        TransactionPage.isTrying = false;
        // Map<String, dynamic> map = Map<String, dynamic>.from(data);
        // print("Msp is " + map.toString());
        TransactionPage.paymentSuccess = true;
        TransactionPage.paymentFailure = false;
        NotificationApi.showNotification(
          title: "Payment Complete",
          body: data,
          payload: "TEST",
        );
        print("notification");
/*
        socket.onDisconnect((data) => NotificationApi.showNotification(
              title: "Please Open Your StrykePay App to Recieve Notifications",
              body: "TEST",
              payload: "TEST",
            ));*/
        //lastNotification(data["payerId"]);;
      });
      socket.on('notificationFail', (data) {
        print(data.toString());
        print("received fail");
        TransactionPage.isTrying = false;
        //Map<String, dynamic> map = Map<String, dynamic>.from(data);
        //  print("Msp is " + map.toString());
        TransactionPage.paymentFailure = true;
        TransactionPage.paymentSuccess = false;
        qrHandler.setComplete(false);
        NotificationApi.showNotification(
          title: "Payment Failed",
          body: data,
          payload: "",
        );
        print("notification fail");
/*
        socket.onDisconnect((data) => NotificationApi.showNotification(
              title: "Please Open Your StrykePay App to Recieve Notifications",
              body: "TEST",
              payload: "TEST",
            ));*/
        //lastNotification(data["payerId"]);;
      });
      // Get the previous cached count and increment it.
      // This will be null if we're running in the background.
      /* uiSendPort = IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send("null");*/
      // This will be null if we're running in the background.
      uiSendPort ??= IsolateNameServer.lookupPortByName('isolate');
      uiSendPort?.send(null);
    }
  }

  getNotifications() {
    notifyListeners();
  }
}
