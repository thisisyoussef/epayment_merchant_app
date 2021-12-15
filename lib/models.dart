import 'package:strykepay_merchant/models/institution.dart';

import 'models/receipt.dart';

class BusinessInfoDetails {
  String companyNumber = "B";
  String VATNumber = "";
  String addressLine = "";
  String streetName = "streetName";
  String buildingNumber = "buildingNumber";
  String county = "county";
  String country = "country";
  String department = "department";
  String supDepartment = "subDepartment";
  String addressType = "addressType";
  String uniqueId = "ABCD";
  String name = "";
  String dobString = "";
  String postcode = "";
  String email = "";
  String loginPin = "";
  String password = "";
  String number = "";
  String logoUrl = "";
  String noAreaCodeNumber = "";
  String errorMessage = "";
  String sortCode = "";
  String accountNumber = "";
  bool validName = false;
  bool validEmail = false;
  bool validPassword = false;
  bool verifiedPassword = false;
  bool tocAgree = false;
  String token = "";
  String id = "";
  String vatNumber = "";
  String addressline1 = "";
  String addressline2 = "";
  String addressline3 = "";
  List<Institution> userInstitutions = [];
  List<Receipt> userReceipts = [];
  BusinessInfoDetails();
  BusinessInfoDetails.fromLogin({String Email, String Password, String Token}) {
    email = Email;
    password = Password;
    token = Token;
  }
}
