import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:strykepay_merchant/dataHandling/altered_endpoints.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/models.dart';
import 'package:strykepay_merchant/models/institution.dart';
import 'package:strykepay_merchant/screens/account_updated.dart';
import 'package:strykepay_merchant/screens/create_pin_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/set_login_pin_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/update.dart';
import '../home_page.dart';
import 'dart:io';
import 'dart:async';
import 'package:strykepay_merchant/dataHandling/sortcode_to_bank.dart';
import 'package:strykepay_merchant/dataHandling/institution_endpoints.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class EditPersonalDetailsPage extends StatefulWidget {
  static String id = "edit_personal_details_page";
  const EditPersonalDetailsPage({Key key}) : super(key: key);

  @override
  State<EditPersonalDetailsPage> createState() =>
      _EditPersonalDetailsPageState();
}

enum AccountType { Personal, Business, Corporate, Wealth }

class _EditPersonalDetailsPageState extends State<EditPersonalDetailsPage> {
  void setId() async {
    institutionId = await sortCodeToBank(
      business.sortCode,
    );
    print("id is " + institutionId);
  }

  BusinessInfoDetails business = BusinessInfoDetails();
  bool showSymbols = false;
  String line1 = "";
  String line2 = "";
  String line3 = "";
  String sortCode = "";
  String accountNumber = "";
  String errorMessage = "";
  Image selectedInstitutionImage;
  bool loadingImage = false;
  bool checkingAccountType;
  String institutionId = "";
  List<Institution> institutions = [];
  AccountType _character = AccountType.Personal;
  bool isPersonal = true;
  bool isBusiness = false;
  bool showOptions = false;
  final ImagePicker _picker = ImagePicker();
  File _image = File("a");
  _imgFromGallery() async {
    final image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      /* File croppedFile = await ImageCropper.cropImage(
          cropStyle: CropStyle.circle,
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: AppColors.accentElement,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));*/
      setState(() {
        _image = File(image.path);
      });
    }
    return true;
  }

  void setImage() async {
    _image = File(await FlutterDownloader.enqueue(
      url: userInfo.logoUrl,
      savedDir: 'the path of directory where you want to save downloaded files',
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    ));
  }

  @override
  void initState() {
    business = userInfo;
    setId();
    setImage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StrykeAppBar(
        popCallback: () {
          Navigator.popAndPushNamed(context, HomePage.id);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    if (await _imgFromGallery()) {
                      //await addLogo(_image.path);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            new Border.all(color: Colors.black38, width: 1)),
                    child: _image == null
                        ? Center(
                            child: CircleAvatar(
                                backgroundColor: AppColors.primaryBackground,
                                //backgroundImage: AssetImage('assets/images/logo.png'),
                                radius: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_rounded,
                                        color: Colors.black38),
                                    Text(
                                      "LOGO",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black38),
                                    ),
                                  ],
                                )),
                          )
                        : Center(
                            child: CircleAvatar(
                            backgroundImage: FileImage(_image),
                            radius: 60,
                          )),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 0, top: 22, right: 0),
                    child: Text(
                      "Update your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: "",
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 63, top: 9, right: 63),
                    child: Text(
                      "Tell us about your business",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: "",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 9),
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
                Container(
                  width: (MediaQuery.of(context).size.width),
                  child: UserInputField(
                    isValid: userInfo.addressLine.isNotEmpty,
                    autofocus: false,
                    showSymbols: showSymbols,
                    initialValue: business.addressLine,
                    title: "Address",
                    isPassword: false,
                    callback: (String input) {
                      setState(() {
                        business.addressLine = input;
                      });
                    },
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  child: UserInputField(
                    isValid: business.postcode.length != 6,
                    autofocus: false,
                    showSymbols: showSymbols,
                    initialValue: business.postcode,
                    maxLength: 8,
                    title: "Postcode",
                    isPassword: false,
                    callback: (String input) {
                      setState(() {
                        business.postcode = input;
                      });
                    },
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width),
                  child: UserInputField(
                    autofocus: false,
                    isValid: business.VATNumber.isNotEmpty,
                    showSymbols: showSymbols,
                    initialValue: business.VATNumber,
                    title: "VAT Number",
                    isPassword: false,
                    callback: (String input) {
                      setState(() {
                        business.VATNumber = input;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                UserInputField(
                  //TODOa
                  //make min length 7 for account number, need to check with backend to test
                  maxLength: 13,
                  isPassword: false,
                  title: "Phone Number",
                  isValid: true,
                  isEnabled: true,
                  showSymbols: false,
                  initialValue: business.number,
                  callback: (String input) {
                    setState(() {
                      business.number = input;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    child: Text(
                      "Bank Details",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: "",
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    "This makes it easier when cashing out your credit",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontFamily: "",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                      initialValue: business.sortCode,
                      callback: (String input) async {
                        if (input.length == 6) {
                          setId();
                        }
                        setState(() {
                          business.sortCode = input;
                        });
                        if (input.length == 6 &&
                            showOptions == false &&
                            await institutionHasOptions(input) == true) {
                          print("multiple account types");
                          setState(() {
                            showOptions = true;
                          });
                        } else {
                          setState(() {
                            showOptions = false;
                          });
                        }
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
                      initialValue: business.accountNumber,
                      callback: (String input) {
                        setState(() {
                          business.accountNumber = input;
                        });
                      },
                    )
                  ],
                ),
                /*  showOptions
                    ? Column(
                        children: [
                          ListTile(
                            title: const Text('Personal'),
                            leading: Radio<AccountType>(
                              value: AccountType.Personal,
                              groupValue: _character,
                              onChanged: (AccountType value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Business'),
                            leading: Radio<AccountType>(
                              value: AccountType.Business,
                              groupValue: _character,
                              onChanged: (AccountType value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),*/

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: WideRoundedButton(
                    isEnabled: true,
                    //color: Colors.redAccent,
                    onPressed: () async {
                      if (await addInstitution(
                          institutionId, business.accountNumber)) {
                        try {
                          await addLogo(_image.path);
                        } catch (e) {}
                        if (await updateInfo(business)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountUpdatedPage()),
                          );
                        } else {
                          setState(() {
                            errorMessage =
                                "Please make sure your account details are valid";
                          });
                        }
                      } else {
                        setState(() {
                          errorMessage =
                              "Please make sure your institution details are correct";
                        });
                        print(institutionId);
                        print(accountNumber);
                      }
                    },
                    title: "Save & Continue",
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
