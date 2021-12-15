import 'package:flutter/material.dart';
import 'package:strykepay_merchant/dataHandling/ticket.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';

import '../../account_updated.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({Key key}) : super(key: key);

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  String errorMessage = "";
  String subject = "";
  String body = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StrykeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 33,
                ),
                child: Text(
                  'Send us a Message!',
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay-Regular',
                    fontSize: 24,
                    color: const Color(0xff444444),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 38, top: 9, right: 50),
                child: Text(
                  "We'll get back to you on email",
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay-Regular',
                    fontSize: 16,
                    color: const Color(0xff444444),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 9),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.accentElement,
                    fontFamily: "",
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: TextFormField(
                  initialValue: subject,
                  onChanged: (input) {
                    setState(() {
                      subject = input;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter a subject here",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.accentElement, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                  ),
                  maxLines: 1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
                child: TextFormField(
                  initialValue: body,
                  onChanged: (input) {
                    setState(() {
                      body = input;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter your message here (this box expands)",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.accentElement, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: WideRoundedButton(
                  title: "Send Message",
                  onPressed: () async {
                    if (await addTicket(subject, body)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountUpdatedPage()),
                      );
                    } else {
                      setState(() {
                        errorMessage =
                            "Something went wrong, please make sure your original password is correct and your new password is more than 8 characters";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
