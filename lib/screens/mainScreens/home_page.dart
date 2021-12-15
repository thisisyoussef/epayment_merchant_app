import 'dart:async';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:strykepay_merchant/dataHandling/altered_endpoints.dart';
import 'package:strykepay_merchant/dataHandling/shared_prefs.dart';
import 'package:strykepay_merchant/handlers/notifications_handler.dart';
import 'package:strykepay_merchant/screens/loginPages/login_page.dart';
import 'package:strykepay_merchant/screens/receipts_page.dart';
import 'package:strykepay_merchant/screens/collection_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/account_page.dart';
import 'dart:io';

import '../../dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static String id = "home_page";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController tabController;
  StreamController streamController;
  void onPauseHandler() {
    print('on Pause');
  }

  void streamAction() async {
    streamController.add(await getCurrentDevice());
  }

  StreamSubscription _sub;

  final tabs = <Tab>[
    Tab(
      child: Icon(
        Icons.history,
        size: 36,
      ),
    ),
    Tab(
      child: Icon(
        Icons.bolt,
        size: 36,
      ),
    ),
    Tab(
      child: Icon(
        Icons.person,
        size: 30,
      ),
    ),
  ];

  @override
  void initState() {
    streamController = new StreamController(
      onPause: onPauseHandler,
    );
    _sub = streamController.stream.listen(
      (event) {
        print("event " + event.toString());
        if (event == false) {
          print("restarting app");
          Navigator.popAndPushNamed(context, LoginPage.id);
        }
      },
      onDone: () {
        print("done");
      },
    );
    // TODO: implement initState
    tabController =
        TabController(length: tabs.length, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myProfile();
    //prefs = SharedPrefs().init();
    notifs() async {
      if (await getUserId() != "") {
        print("setting up background function");
        try {
          prefs.setString("id", await getUserId());
        } catch (e) {}
        if (Platform.isIOS) {
          NotificationsHandler.callback();
        } else {
          await AndroidAlarmManager.periodic(
            const Duration(minutes: 1),
            // Ensure we have a unique alarm ID.
            Random().nextInt(pow(2, 31)),
            NotificationsHandler.callback,
            exact: true,
            wakeup: true,
          );
        }
      }
    }

    print("rebuilding");
    notifs();
    return Scaffold(
      body: TabBarView(
        children: <Widget>[ReceiptsPage(), CollectionPage(), AccountPage()],
        controller: tabController,
      ),
      bottomNavigationBar: Material(
        child: TabBar(
          labelColor: AppColors.accentElement,
          indicatorColor: AppColors.accentElement,
          unselectedLabelColor: AppColors.secondaryAccent,
          tabs: tabs,
          controller: tabController,
        ),
      ),
      backgroundColor: AppColors.primaryBackground,
    );
  }
}
