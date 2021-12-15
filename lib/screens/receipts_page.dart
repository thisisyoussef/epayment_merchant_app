import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strykepay_merchant/dataHandling/receipt.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/handlers/payment_handler.dart';
import 'package:strykepay_merchant/handlers/receipts_handler.dart';
import 'package:strykepay_merchant/models/institution.dart';
import 'package:strykepay_merchant/models/institution.dart';
import 'package:strykepay_merchant/models/receipt.dart';
import 'package:strykepay_merchant/screens/collection_page.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/search_bar.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'mainScreens/home_page.dart';
import 'dialogs/add_institution_dialog.dart';
import 'package:loading_overlay/loading_overlay.dart';

List<Receipt> receipts = [];
List<Receipt> outgoing = [];
List<Receipt> incoming = [];

class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({Key key}) : super(key: key);

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage>
    with SingleTickerProviderStateMixin {
  int segmentedControlGroupValue = 1;
  List<Receipt> currentList = [];
  bool loading = true;
  Animation animation;
  AnimationController controller;
  ScrollController scrollController;
  bool noInstitutions = true;
  String selectedInstitutionName = "";
  List<Institution> userInstitutions = [];
  List<Image> institutionLogos = [];
  int _index = 0;
  bool longPress = false;
  String searchKey = "";
  Map<int, Widget> myTabs;
  Institution _selectedInstitution = Institution();
  Future<void> getRec() async {
    receipts.clear();
    currentList.clear();
    incoming.clear();
    outgoing.clear();
    receipts = List.from((await getAllReceipts()).reversed);
    print("getting");
    for (var item in receipts) {
      if (item.refund == true) {
        outgoing.add(item);
      } else {
        incoming.add(item);
      }
    }
    setState(() {
      switch (segmentedControlGroupValue) {
        case 0:
          setState(() {
            currentList = incoming;
          });
          break;
        case 1:
          setState(() {
            currentList = receipts;
          });
          break;
        case 2:
          setState(() {
            currentList = outgoing;
          });
          break;
        default:
          {
            currentList = receipts;
            break;
          }
      }
      receipts = receipts;
    });
  }

  @override
  void initState() {
    if (receipts.isEmpty || currentList.isEmpty) {
      getRec();
    }
    //  Provider.of<ReceiptsHandler>(context, listen: false).setReceipts();
    loading = true;
    // TODO: implement initState
    controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
        upperBound: 1,
        lowerBound: 0.4);
    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Navigator.popAndPushNamed(context, LoginPage.id);
        controller.forward();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myTabs = <int, Widget>{
      0: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Text(
          'Incoming',
          style: TextStyle(
            fontFamily: 'Hussar',
            fontSize: 16,
            color: segmentedControlGroupValue != 0
                ? AppColors.accentElement
                : Color(0xffffffff),
            letterSpacing: 0.96,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      1: Text(
        'All',
        style: TextStyle(
          fontFamily: 'Hussar',
          fontSize: 16,
          color: segmentedControlGroupValue != 1
              ? AppColors.accentElement
              : Color(0xffffffff),
          letterSpacing: 0.96,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      2: Text(
        'Outgoing',
        style: TextStyle(
          fontFamily: 'Hussar',
          fontSize: 16,
          color: segmentedControlGroupValue != 2
              ? AppColors.accentElement
              : Color(0xffffffff),
          letterSpacing: 0.96,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
/*

*/
    };
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 20, bottom: 20),
                child: SearchBar(
                  callback: (String newKey) {
                    setState(() {
                      searchKey = newKey;
                    });
                  },
                )),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, left: 24, right: 24, bottom: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoSlidingSegmentedControl(
                      thumbColor: AppColors.accentElement,
                      groupValue: segmentedControlGroupValue,
                      children: myTabs,
                      onValueChanged: (i) {
                        setState(() {
                          segmentedControlGroupValue = i;
                          switch (i) {
                            case 0:
                              setState(() {
                                currentList = incoming;
                              });
                              break;
                            case 1:
                              setState(() {
                                currentList = receipts;
                              });
                              break;
                            case 2:
                              setState(() {
                                currentList = outgoing;
                              });
                              break;
                            default:
                              {
                                break;
                              }
                          }
                        });
                      }),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width,
                child: LoadingOverlay(
                  isLoading: currentList == null,
                  opacity: 0.9,
                  progressIndicator: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset('assets/images/logo.png'),
                        height: animation.value * 130,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Text("Importing your strykes..")
                    ],
                  ),
                  child: Container(
                    child: RefreshIndicator(
                      onRefresh: getRec,
                      child: currentList.isEmpty
                          ? Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 50, top: 87, right: 50),
                                  child: Text(
                                    "Your strykes will be shown here",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.primaryText,
                                      fontFamily: "",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: currentList.length,
                              itemBuilder: (context, items) {
                                return currentList[items]
                                            .transactionNumber
                                            .contains(searchKey) ||
                                        searchKey.isEmpty
                                    ? Column(
                                        children: [
                                          items == 0
                                              ? Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Pull down to refresh",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_downward,
                                                        color: AppColors
                                                            .accentElement,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  isDismissible: true,
                                                  builder:
                                                      (context) =>
                                                          SingleChildScrollView(
                                                            child: Container(
                                                              padding: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom),
                                                              child: Column(
                                                                children: [
                                                                  StrykeAppBar(),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            50.0,
                                                                        top:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          "Receipt",
                                                                          style:
                                                                              TextStyle(fontSize: 30),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            70.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 20.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text(
                                                                                currentList[items].date,
                                                                                style: TextStyle(fontSize: 15),
                                                                              ),
                                                                              Text(
                                                                                "TN " + currentList[items].transactionNumber,
                                                                                style: TextStyle(fontSize: 15),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 30),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Total",
                                                                                style: TextStyle(fontSize: 25),
                                                                              ),
                                                                              Text(
                                                                                "£" + currentList[items].amount.toString(),
                                                                                style: TextStyle(fontSize: 25),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 10.0),
                                                                          child:
                                                                              WideRoundedButton(
                                                                            title:
                                                                                "Refund",
                                                                            onPressed:
                                                                                () async {
                                                                              Provider.of<PaymentHandler>(context, listen: false).setPaymentUrl("");
                                                                              Provider.of<PaymentHandler>(context, listen: false).registerPayment(currentList[items].transactionNumber);
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => TransactionPage(
                                                                                            transactionNumber: currentList[items].transactionNumber,
                                                                                            totalPrice: currentList[items].amount,
                                                                                          )));
                                                                            },
                                                                            isEnabled:
                                                                                true,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                            },
                                            child: Card(
                                              child: ListTile(
                                                leading: Icon(
                                                    Icons.fastfood_outlined),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(currentList[items]
                                                        .transactionNumber),
                                                    Text(
                                                        currentList[items].date)
                                                  ],
                                                ),
                                                trailing: Text("£" +
                                                    currentList[items]
                                                        .amount
                                                        .toString()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox();
                              }),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
