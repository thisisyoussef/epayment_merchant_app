import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:strykepay_merchant/main.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/enter_pin_check.dart';
import 'mainScreens/home_page.dart';
import 'loginPages/login_page.dart';
import 'package:flutter/animation.dart';

class SplashScreen extends StatefulWidget {
  static String id = "splash_screen";
  static bool loggedIn = false;
  const SplashScreen({Key key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String obtainedEmail = "";
  String obtainedToken = "";
  String obtainedPassword = "";
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    getLoginData();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 1,
    );
    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Navigator.popAndPushNamed(context, LoginPage.id);
        controller.forward();
      }
    });
    initPlatformState();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();

    super.dispose();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        deviceData = _deviceData;
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Future getDeviceData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
  }

  Future getLoginData() async {
    prefs = await SharedPreferences.getInstance();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    obtainedEmail = prefs.getString('email');
    obtainedToken = prefs.getString('token');
    //print("Obtained Email " + obtainedEmail);

    //obtainedPassword = prefs.getString('password');
    //print("Email: " + obtainedEmail);
    //print("Password :" + obtainedPassword);
    if (obtainedEmail == null ||
        obtainedToken == null ||
        obtainedEmail.isEmpty ||
        obtainedToken.isEmpty) {
      Navigator.popAndPushNamed(context, LoginPage.id);

      /*   print("Email:" + obtainedEmail);
      print("Token:" + obtainedToken);*/
      // Navigator.popAndPushNamed(context, LoginPage.id);
    } else {
      SplashScreen.loggedIn = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EnterPinCheck(
                  nextPageId: HomePage.id,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('assets/images/logo.png'),
              height: animation.value * 130,
            ),
            /*Container(
              child: Image.asset(
                'assets/images/logoBlack.png',
                opacity: AlwaysStoppedAnimation<double>(animation.value),
              ),
              height: 100,
            ),*/
          ],
        ),
      ),
    );
  }
}
