import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strykepay_merchant/handlers/payment_handler.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';

class TransactionSuccessPage extends StatelessWidget {
  const TransactionSuccessPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Transform.scale(
                    scale: 1.5,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      backgroundColor: AppColors.accentElement,
                      heroTag: "null",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 12),
                child: Text(
                  "Success!",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Your refund is complete!"),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                WideRoundedButton(
                  title: "Close",
                  onPressed: () {
                    Provider.of<PaymentHandler>(context, listen: false)
                        .setPaymentUrl("");
                    Navigator.popAndPushNamed(context, HomePage.id);
                  },
                  isEnabled: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
