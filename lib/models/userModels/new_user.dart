import 'package:intl/intl.dart';
import 'package:strykepay_merchant/data/device_data.dart';

class NewUser {
  String number = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String phone = "";
  String dob = DateFormat('M-d-yyyy').format(DateTime.now());
  String streetName = " ";
  String buildingNumber = " ";
  String postCode = "";
  String county = " ";
  String country = " ";
  String department = " ";
  String supDepartment = " ";
  String addressType = " ";
  String addressLine = " ";
  String uniqueId = deviceData["uniqueId"];

  NewUser(
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phone,
      this.dob,
      this.streetName,
      this.buildingNumber,
      this.postCode,
      this.county,
      this.country,
      this.department,
      this.supDepartment,
      this.addressType,
      this.addressLine,
      this.uniqueId,
      this.number);
  NewUser.fromNewUser();
}
