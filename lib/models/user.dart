class userData {
  User user;
  String token;

  userData({this.user, this.token});

  userData.fromJson(Map<String, dynamic> json) {
    user =
        json['Merchant'] != null ? new User.fromJson(json['Merchant']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['Merchant'] = this.user.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  Address address;
  String status;
  int numberOfTransaction;
  int numberOfRefund;
  List<String> devices;
  bool isVerified;
  String sId;
  String firstName;
  String lastName;
  String type;
  String dob;
  String phone;
  String email;
  String currentDevice;
  String password;
  List<Null> loyalty;
  List<Null> institution;
  String yapilyuuid;
  String applicationUuid;
  String createdAt;
  String updatedAt;
  int iV;

  User(
      {this.address,
      this.status,
      this.numberOfTransaction,
      this.numberOfRefund,
      this.devices,
      this.isVerified,
      this.sId,
      this.firstName,
      this.lastName,
      this.type,
      this.dob,
      this.phone,
      this.email,
      this.currentDevice,
      this.password,
      this.loyalty,
      this.institution,
      this.yapilyuuid,
      this.applicationUuid,
      this.createdAt,
      this.updatedAt,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    status = json['status'];
    numberOfTransaction = json['numberOfTransaction'];
    numberOfRefund = json['numberOfRefund'];
    devices = json['devices'].cast<String>();
    isVerified = json['isVerified'];
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    type = json['type'];
    dob = json['dob'];
    phone = json['phone'];
    email = json['email'];
    currentDevice = json['currentDevice'];
    password = json['password'];
    if (json['loyalty'] != null) {
      loyalty = new List<Null>();
      /*json['loyalty'].forEach((v) {
        loyalty.add(new fromJson(v));
      });*/
    }
    if (json['institution'] != null) {
      institution = new List<Null>();
      /*json['institution'].forEach((v) {
        institution.add(new Null.fromJson(v));
      });*/
    }
    yapilyuuid = json['yapilyuuid'];
    applicationUuid = json['applicationUuid'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['status'] = this.status;
    data['numberOfTransaction'] = this.numberOfTransaction;
    data['numberOfRefund'] = this.numberOfRefund;
    data['devices'] = this.devices;
    data['isVerified'] = this.isVerified;
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['type'] = this.type;
    data['dob'] = this.dob;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['currentDevice'] = this.currentDevice;
    data['password'] = this.password;
    if (this.loyalty != null) {
/*
      data['loyalty'] = this.loyalty.map((v) => v.toJson()).toList();
*/
    }
    if (this.institution != null) {
/*
      data['institution'] = this.institution.map((v) => v.toJson()).toList();
*/
    }
    data['yapilyuuid'] = this.yapilyuuid;
    data['applicationUuid'] = this.applicationUuid;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Address {
  List<String> addressLine;
  List<String> county;
  String streetName;
  String buildingNumber;
  String postCode;
  String country;
  String department;
  String supDepartment;
  String addressType;

  Address(
      {this.addressLine,
      this.county,
      this.streetName,
      this.buildingNumber,
      this.postCode,
      this.country,
      this.department,
      this.supDepartment,
      this.addressType});

  Address.fromJson(Map<String, dynamic> json) {
    addressLine = json['addressLine'].cast<String>();
    county = json['county'].cast<String>();
    streetName = json['streetName'];
    buildingNumber = json['buildingNumber'];
    postCode = json['postCode'];
    country = json['country'];
    department = json['department'];
    supDepartment = json['supDepartment'];
    addressType = json['addressType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressLine'] = this.addressLine;
    data['county'] = this.county;
    data['streetName'] = this.streetName;
    data['buildingNumber'] = this.buildingNumber;
    data['postCode'] = this.postCode;
    data['country'] = this.country;
    data['department'] = this.department;
    data['supDepartment'] = this.supDepartment;
    data['addressType'] = this.addressType;
    return data;
  }
}
