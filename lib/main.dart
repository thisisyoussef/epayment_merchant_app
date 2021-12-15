import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strykepay_merchant/handlers/payment_handler.dart';
import 'package:strykepay_merchant/handlers/qr_screen_handler.dart';
import 'package:strykepay_merchant/handlers/receipts_handler.dart';
import 'package:strykepay_merchant/handlers/strykeout_handler.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/cash_out_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/update_password_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/accountScreens/edit_personal_details_page.dart';
import 'package:strykepay_merchant/screens/forgotPasswordModule/new_password_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/add_information_page.dart';
import 'package:strykepay_merchant/screens/create_pin_page.dart';
import 'package:strykepay_merchant/screens/dialogs/add_institution_dialog.dart';
import 'package:strykepay_merchant/screens/forgotPasswordModule/enter_email_page.dart';
import 'package:strykepay_merchant/screens/loginPages//enter_pin_page.dart';
import 'package:strykepay_merchant/screens/loginPages//login_page.dart';
import 'package:strykepay_merchant/screens/onboarding/intro_screen.dart';
import 'package:strykepay_merchant/screens/splash_screen.dart';
import 'package:strykepay_merchant/screens/verify_email_page.dart';
import 'package:strykepay_merchant/screens/verify_otp_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/register.dart';

import 'data/device_data.dart';
import 'data/user_info.dart';
import 'dataHandling/userProfile/onboarding_user_credentials.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

/// The [SharedPreferences] key to access the alarm fire count.
const String countKey = 'count';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

/// Global [SharedPreferences] object.
SharedPreferences prefs;

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    userToken = "";
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readDevice();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserInfo()),
        ChangeNotifierProvider(create: (context) => ReceiptsHandler()),
        ChangeNotifierProvider(create: (context) => PaymentHandler()),
        ChangeNotifierProvider(create: (context) => QRScreenHandler()),
        ChangeNotifierProvider(create: (context) => StrykeOutHandler()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            splashColor: AppColors.accentElement,
            canvasColor: Colors.white,
            //platform: TargetPlatform.iOS,
            primaryColor: AppColors.accentElement,
            backgroundColor: AppColors.primaryBackground,
            dialogBackgroundColor: AppColors.primaryBackground,
            colorScheme: ColorScheme.light(primary: AppColors.accentElement)
                .copyWith(secondary: AppColors.accentElement)),
        initialRoute: SplashScreen.id,
        routes: {
          EditPersonalDetailsPage.id: (context) => EditPersonalDetailsPage(),
          VerifyOtpPage.id: (context) => VerifyOtpPage(),
          EnterEmailPage.id: (context) => EnterEmailPage(),
          EnterPinPage.id: (context) => EnterPinPage(),
          SplashScreen.id: (context) => SplashScreen(),
          EnterPinPage.id: (context) => EnterPinPage(),
          HomePage.id: (context) => HomePage(),
          LoginPage.id: (context) => LoginPage(),
          VerifyEmailPage.id: (context) => VerifyEmailPage(),
          IntroScreen.id: (context) => IntroScreen(),
          Register.id: (context) => Register(),
          AddInformationPage.id: (context) => AddInformationPage(),
          CreatePin.id: (context) => CreatePin(),
          AddInstitutionDialog.id: (context) => AddInstitutionDialog(),
          CashOutPage.id: (context) => CashOutPage(),
          NewPasswordPage.id: (context) => NewPasswordPage(),
          UpdatePasswordPage.id: (context) => UpdatePasswordPage(),
        },
      ),
    );
  }
}
