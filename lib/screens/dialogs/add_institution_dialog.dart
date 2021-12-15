import 'package:flutter/material.dart';
import 'package:strykepay_merchant/data_handling.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';

import '../mainScreens/home_page.dart';

class AddInstitutionDialog extends StatefulWidget {
  static String id = "add_institution_dialog";
  const AddInstitutionDialog({Key key}) : super(key: key);

  @override
  _AddInstitutionDialogState createState() => _AddInstitutionDialogState();
}

class _AddInstitutionDialogState extends State<AddInstitutionDialog> {
  String institutionId = "";
  String sortCode = "";
  String accountNumber = "";
  List<String> sortCodeSuggestions = [];
  String selectedSortCode = "";
  Image selectedInstitutionImage;
  bool loadingImage = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (sortCodeSuggestions.isNotEmpty) {
      selectedSortCode = sortCodeSuggestions[0];
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StrykeAppBar(
        popCallback: () {
          Navigator.popAndPushNamed(context, HomePage.id);
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Column(
                children: [
                  UserInputField(
                    imageInput: loadingImage
                        ? Container(
                            child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CircularProgressIndicator(),
                          ))
                        : selectedInstitutionImage != null
                            ? selectedInstitutionImage
                            : null,
                    maxLength: 6,
                    isPassword: false,
                    title: "Sort Code",
                    isValid: true,
                    isEnabled: true,
                    showSymbols: false,
                    initialValue: sortCode,
                    callback: (String input) {
                      setState(() {
                        sortCode = input;
                        sortCodeToBank(
                          sortCode,
                          (var results, List images, var _institutionId) {
                            setState(() {
                              institutionId = _institutionId;
                              sortCodeSuggestions = results;
                              if (images.length > 0) {
                                selectedInstitutionImage = images[0];
                              } else {
                                print("no images");
                                selectedInstitutionImage = null;
                              }
                            });
                          },
                        );
                      });
                    },
                  ),
                  UserInputField(
                    //TODOa
                    //make min length 7 for account number, need to check with backend to test
                    maxLength: 8,
                    isPassword: false,
                    title: "Account Number",
                    isValid: true,
                    isEnabled: true,
                    showSymbols: false,
                    initialValue: accountNumber,
                    callback: (String input) {
                      setState(() {
                        accountNumber = input;
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              WideRoundedButton(
                title: "Add Institution",
                onPressed: () {
                  addInstitution(institutionId, accountNumber);
                  Navigator.popAndPushNamed(context, HomePage.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
