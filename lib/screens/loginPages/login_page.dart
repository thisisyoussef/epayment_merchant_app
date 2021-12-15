import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strykepay_merchant/dataHandling/altered_endpoints.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/update.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/models.dart';
import 'package:strykepay_merchant/screens/loginPages/enter_pin_page.dart';
import 'package:strykepay_merchant/screens/loginPages/remote_logout_pin_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/register.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/verify_user_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:strykepay_merchant/main.dart';
import 'package:strykepay_merchant/notofication_api.dart';
import 'package:strykepay_merchant/screens/forgotPasswordModule/enter_email_page.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'add_device_pin_page.dart';

/// The [SharedPreferences] key to access the alarm fire count.
const String countKey = 'count';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

/// Global [SharedPreferences] object.
//SharedPreferences prefs;

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);

  static String id = "login_page";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  int _counter;
  void load() {
    setState(() {
      loading = true;
      controller.forward();
    });
  }

  void endLoad() {
    setState(() {
      loading = false;
      controller.stop();
    });
  }

  Animation animation;
  AnimationController controller;
  bool loading = false;
  bool showSymbols = false;
  BusinessInfoDetails user = BusinessInfoDetails();
  String error = "";
  prefsSetup() async {
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(countKey)) {
      await prefs.setInt(countKey, 0);
    }
  }

  @override
  void initState() {
    AndroidAlarmManager.initialize();

    prefsSetup();
    user = BusinessInfoDetails();
    // TODO: implement initState
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 1,
    );
    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    // controller.forward();
    controller.addListener(() {
      setState(() {});
      //print(animation.value);
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Navigator.popAndPushNamed(context, LoginPage.id);
        controller.forward();
      }
    });
    AndroidAlarmManager.initialize();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  Future<void> _incrementCounter() async {
    developer.log('Increment counter!');
    // Ensure we've loaded the updated count from the background isolate.
    await prefs.reload();

    setState(() {
      _counter++;
    });
  }

  static SendPort uiSendPort;

  static Future<void> callback() async {
    developer.log('Alarm fired!');
    NotificationApi.showNotification(
      title: "callback notif: ",
      body: "TEST Alarm Manager",
      payload: "TEST",
    );
    IO.Socket socket = IO.io(
        'https://notification.strykepay.co.uk',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({"_id": '6149dfe8630fa31fd4c003b6'})
            .build());
    socket.connect();
    socket.onConnect((_) async {
      print('connect');
      NotificationApi.showNotification(
        title: "Socket connects",
        body: "TEST",
        payload: "TEST",
      );
    });
    socket.on('notification', (data) {
      print("notification");
      NotificationApi.showNotification(
        title: "Payment",
        body: "TEST Payment",
        payload: "TEST",
      );
      //lastNotification(data["payerId"]);;
      print(data);
      // This will be null if we're running in the background.
/*      uiSendPort = IsolateNameServer.lookupPortByName(isolateName);
      uiSendPort?.send("null");*/
    });
    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey);
    await prefs.setInt(countKey, currentCount + 1);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StrykeAppBar(
        canPop: false,
        hasButton: true,
        buttonText: "Register",
        buttonCallback: () {
          Navigator.pushNamed(context, Register.id);
        },
      ),
      body: LoadingOverlay(
        isLoading: loading,
        opacity: 0.8,
        progressIndicator: Container(
          child: Image.asset('assets/images/logo.png'),
          height: animation.value * 130,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.asset('assets/images/logoBlack.png',
                              width: MediaQuery.of(context).size.width * 0.4,
                              height:
                                  MediaQuery.of(context).size.height * 0.075),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0, top: 5, right: 0),
                          child: Text(
                            "Business",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontFamily: "",
                              fontWeight: FontWeight.w400,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0, top: 5, right: 0),
                          child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontFamily: "",
                              fontWeight: FontWeight.w400,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 9),
                          child: Text(
                            error,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.accentElement,
                              fontFamily: "",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: UserInputField(
                          showSymbols: showSymbols,
                          isValid: user.validEmail,
                          initialValue: user.email,
                          title: "Email",
                          isPassword: false,
                          callback: (String input) {
                            setState(() {
                              user.email = input;
                              user.validEmail = EmailValidator.validate(
                                  user.email.toLowerCase());
                            });
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: UserInputField(
                            showSymbols: showSymbols,
                            isValid: user.validPassword,
                            maxLength: 15,
                            isPassword: true,
                            title: "Password",
                            initialValue: user.password,
                            callback: (input) {
                              setState(() {
                                user.password = input;
                                user.validPassword = user.password.length >= 7;
                              });
                            }),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 9),
                    child: TextButton(
                      child: Text(
                        "Forgot Password?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.accentElement,
                          fontFamily: "",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, EnterEmailPage.id);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: WideRoundedButton(
                      title: "Login",
                      isEnabled: true,
                      onPressed: () async {
                        setState(() {
                          error = "";
                        });
                        // port.listen((_) async => await call());
                        load();
                        if (user.email.isEmpty) {
                          setState(() {
                            error = "Please enter your email";
                          });
                        } else if (!EmailValidator.validate(
                            user.email.toLowerCase())) {
                          setState(() {
                            error =
                                "Please make sure you've entered a correct email";
                          });
                        } else if (user.password.isEmpty) {
                          error = "Please enter your password";
                        } else {
                          var response = await login(
                              user.email.toLowerCase(), user.password);
                          if (response == true) {
                            print(response);
                            if (await myProfile()) {
                              Navigator.popAndPushNamed(context, HomePage.id);
                            } else {
                              generatePin(user.email);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyUserPage(
                                    email: user.email,
                                  ),
                                ),
                              );
                              /*
                              setState(() {
                                error =
                                    "Something went wrong, please try again";
                              });*/
                            }
                          } else if (response == 401) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RemoteLogoutPinPage(
                                        email: user.email.toLowerCase(),
                                        password: user.password,
                                      )),
                            );
                          } else if (response == 402) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddDevicePinPage(
                                        email: user.email,
                                        password: user.password,
                                      )),
                            );
                          } else {
                            endLoad();
                            setState(() {
                              if (response == 400) {
                                error = "Invalid Email or Password";
                              } else {
                                error = response.toString();
                              }
                            });
                          }
                        }
                        endLoad();
                        // showSymbols = true;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
