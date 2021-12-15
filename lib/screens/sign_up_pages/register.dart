import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:strykepay_merchant/models.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/password_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/phone_number_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/user_info_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/verify_user_page.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'dart:io' show Platform;
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

class Register extends StatefulWidget {
  static String id = "register";

  static bool tocAgree = false;
  static bool validatedPassword = false;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  bool showSymbols = false;
  TabController _tabController;
  var tabs = <Tab>[
    Tab(child: SizedBox()),
    Tab(child: SizedBox()),
  ];
  Animation animation;
  AnimationController controller;
  bool loading = false;
  String errorMessage = "";

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

  BusinessInfoDetails localUserInfo = BusinessInfoDetails();
  @override
  void initState() {
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
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    // TODO: implement initState
    _tabController = TabController(length: tabs.length, vsync: this);
    localUserInfo = BusinessInfoDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: StrykeAppBar(
                popCallback: (_tabController.index > 0)
                    ? () {
                        setState(() {
                          _tabController.animateTo(_tabController.index - 1);
                          print(_tabController.index);
                        });
                      }
                    : null),
            body: LoadingOverlay(
              isLoading: loading,
              opacity: 0.8,
              progressIndicator: Container(
                child: Image.asset('assets/images/logo.png'),
                height: animation.value * 130,
              ),
              child: SafeArea(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 15, bottom: 8, top: 0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _tabController.index == 0
                              ? UserInfoPage(
                                  user: localUserInfo,
                                  errorMessage: errorMessage,
                                )
                              : _tabController.index == 1
                                  ? PhoneNumberPage(
                                      userInfo: localUserInfo,
                                      errorMessage: errorMessage,
                                    )
                                  : SizedBox(),
                          SizedBox(
                            height: 20,
                          ),
                          WideRoundedButton(
                            isEnabled: true,
                            //color: Colors.redAccent,
                            onPressed: () async {
                              setState(() {
                                errorMessage = "";
                              });
                              if (localUserInfo.name.isEmpty) {
                                setState(() {
                                  errorMessage =
                                      "Please enter your first and last name";
                                });
                              } else if (localUserInfo.companyNumber.isEmpty) {
                                setState(() {
                                  errorMessage = "Please enter your postcode";
                                });
                              } else if (localUserInfo.email.isEmpty) {
                                setState(() {
                                  errorMessage = "Please enter your email";
                                });
                              } else if (_tabController.index == 2 &&
                                  localUserInfo.password.isEmpty) {
                                setState(() {
                                  errorMessage = "Please enter a password";
                                });
                              } else if (_tabController.index == 2 &&
                                  localUserInfo.password.length < 8) {
                                setState(() {
                                  errorMessage =
                                      "Please set a password that is at least 8 characters";
                                });
                              } else if (Register.validatedPassword == false) {
                                setState(() {
                                  errorMessage =
                                      "Please make sure your passwords match";
                                });
                              } else if (_tabController.index == 1 &&
                                  localUserInfo.number.isEmpty) {
                                setState(() {
                                  errorMessage =
                                      "Please enter your phone number";
                                });
                              } else if (Register.tocAgree != true) {
                                setState(() {
                                  errorMessage =
                                      "Please accept the terms and conditions before signing up";
                                });
                              } else if (_tabController.index < 1) {
                                setState(() {
                                  errorMessage = "";
                                  _tabController
                                      .animateTo(_tabController.index + 1);
                                });
                              } else if (_tabController.index == 1 &&
                                  localUserInfo.number.length < 13) {
                                setState(() {
                                  errorMessage =
                                      "Please enter a valid phone number";
                                });
                              } else {
                                load();
                                //TODO: set error messages (setstate)
                                var response = await signUp(localUserInfo);
                                print(localUserInfo.email);
                                print(localUserInfo.uniqueId.toString());
                                print("hello");
                                print(response);
                                if (response.toString() == "true") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerifyUserPage(
                                        email: localUserInfo.email,
                                        userNumber: localUserInfo.number,
                                      ),
                                    ),
                                  );
                                  endLoad();
                                } else {
                                  setState(() {
                                    errorMessage =
                                        "This user is already registered";
                                  });
                                  endLoad();
                                }
                              }
                            },
                            title: _tabController.index != 0
                                ? "Get Started"
                                : "Continue",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Material(
              color: Colors.white,
              child: Visibility(
                visible: false,
                child: TabBar(
                  controller: _tabController,
                  tabs: tabs,
                ),
              ),
            )),
      ],
    );
  }
}
