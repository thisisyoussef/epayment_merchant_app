import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:strykepay_merchant/dataHandling/revenue.dart';
import 'package:strykepay_merchant/handlers/receipts_handler.dart';
import 'package:strykepay_merchant/handlers/strykeout_handler.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/screens/strykeoutPages/strykeout_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:strykepay_merchant/values/values.dart';

class CashOutPage extends StatefulWidget {
  const CashOutPage({Key key}) : super(key: key);
  static String id = "cash_out_page";

  @override
  State<CashOutPage> createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  int _index = 0;
  dynamic amountDue;
  dynamic currentVolume;
  dynamic lastMonthVolume;
  double percentage;
  loadRevenue() async {
    if (await getRevenue()) {
      setState(() {
        amountDue = getAmountDue();
        currentVolume = getCurrentVolume();
        percentage = getPercentage();
      });
    }
  }

  @override
  void initState() {
    getRevenue();
    loadRevenue();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StrykeAppBar(
        popCallback: () {
          Navigator.pop(context);
        },
      ),
      body: LoadingOverlay(
        isLoading: getLoading(),
        opacity: 0.8,
        progressIndicator: Container(
          child: Image.asset('assets/images/logo.png'),
          height: 130,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 76,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color.fromARGB(77, 156, 155, 156),
                          ),
                          borderRadius: Radii.k9pxRadius,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "Amount Transacted",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(right: 18),
                              child: Text(
                                "£$currentVolume",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 75, 74, 75),
                                  fontFamily: "",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Text(
                                    "Transaction Fee",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 75, 74, 75),
                                      fontFamily: "",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      "-$percentage%",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 75, 74, 75),
                                        fontFamily: "",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 76,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color.fromARGB(77, 151, 151, 151),
                          ),
                          borderRadius: Radii.k9pxRadius,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                "Cash out",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(right: 17),
                              child: Text(
                                "£$amountDue",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 75, 74, 75),
                                  fontFamily: "",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20.0, horizontal: 6),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          "You Owe £$amountDue",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      WideRoundedButton(
                          title: "Total Fees",
                          onPressed: () async {
                            Provider.of<StrykeOutHandler>(context,
                                    listen: false)
                                .setPaymentUrl("");
                            Provider.of<StrykeOutHandler>(context,
                                    listen: false)
                                .registerPayment(amountDue.toDouble());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StrykeOutPage(
                                          totalPrice: amountDue.toDouble(),
                                        )));
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
