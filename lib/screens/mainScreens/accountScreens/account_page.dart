import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strykepay_merchant/data/my_profile_data.dart';
import 'package:strykepay_merchant/data/user_data.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/cash_out_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/create_ticket_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/edit_personal_details_page.dart';
import 'package:strykepay_merchant/screens/loginPages/enter_pin_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/enter_pin_check.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/update_password_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/password_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/set_login_pin_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/screens/create_pin_page.dart';
import '../../loginPages/login_page.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

import 'pin_security_check.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: loading,
        opacity: 0.8,
        progressIndicator: Container(
          child: Image.asset('assets/images/logo.png'),
          height: animation.value * 130,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 0,
                          top: MediaQuery.of(context).size.height * 0.10,
                          right: 0),
                      child: Text(
                        userInfo.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 75, 74, 75),
                          fontFamily: "",
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        "Manage Account",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, CashOutPage.id);
                      },
                      child: ListTile(
                        leading: Icon(Icons.attach_money_outlined),
                        title: Text(
                          "Cash Out",
                          style: TextStyle(
                            color: AppColors.accentText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.popAndPushNamed(
                                context, EditPersonalDetailsPage.id)
                            .then((value) => setState(() {
                                  print("resetting state");
                                  /* nameString = verifiedUser.firstName +
                                      " " +
                                      verifiedUser.lastName;*/
                                }));
                        ;
                      },
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text(
                          "Business Details",
                          style: TextStyle(
                            color: AppColors.accentText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EnterPinCheck(nextPageId: CreatePin.id)),
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.lock),
                        title: Text(
                          "Reset PIN",
                          style: TextStyle(
                            color: AppColors.accentText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, UpdatePasswordPage.id);
                      },
                      child: ListTile(
                        leading: Icon(Icons.vpn_key),
                        title: Text(
                          "Reset Password",
                          style: TextStyle(
                            color: AppColors.accentText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        "About Us",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.view_headline_outlined),
                        title: Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            color: AppColors.accentText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateTicketPage()),
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.help_outline_outlined),
                        title: Text(
                          " Help",
                          style: TextStyle(
                            color: AppColors.accentText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        load();
                        if (await logout()) {
                          Navigator.popAndPushNamed(context, LoginPage.id);
                        }
                        load();
                      },
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                            color: AppColors.accentText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    myProfile();
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
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}
