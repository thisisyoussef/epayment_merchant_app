MyProfileData profileInfo = MyProfileData();

class MyProfileData {
  User user;

  MyProfileData({this.user});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    user =
        json['Merchant'] != null ? new User.fromJson(json['Merchant']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['Merchant'] = this.user.toJson();
    }
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
  String firstName = " ";
  String lastName = " ";
  String type;
  String dob;
  String phone;
  String email;
  String password;
  List<Loyalty> loyalty;
  List<Institution> institution;
  String yapilyuuid;
  String applicationUuid;
  String createdAt;
  String updatedAt;
  int iV;
  String pin;
  String loginPin;
  String currentDevice;

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
      this.password,
      this.loyalty,
      this.institution,
      this.yapilyuuid,
      this.applicationUuid,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.pin,
      this.loginPin,
      this.currentDevice});

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
    password = json['password'];
    if (json['loyalty'] != null) {
      loyalty = new List<Loyalty>();
      json['loyalty'].forEach((v) {
        loyalty.add(new Loyalty.fromJson(v));
      });
    }
    if (json['institution'] != null) {
      institution = new List<Institution>();
      json['institution'].forEach((v) {
        institution.add(new Institution.fromJson(v));
      });
    }
    yapilyuuid = json['yapilyuuid'];
    applicationUuid = json['applicationUuid'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    pin = json['pin'];
    loginPin = json['loginPin'];
    currentDevice = json['currentDevice'];
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
    data['password'] = this.password;
    if (this.loyalty != null) {
      data['loyalty'] = this.loyalty.map((v) => v.toJson()).toList();
    }
    if (this.institution != null) {
      data['institution'] = this.institution.map((v) => v.toJson()).toList();
    }
    data['yapilyuuid'] = this.yapilyuuid;
    data['applicationUuid'] = this.applicationUuid;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['pin'] = this.pin;
    data['loginPin'] = this.loginPin;
    data['currentDevice'] = this.currentDevice;
    return data;
  }
}

class Address {
  Null addressLine;
  Null county;
  Null streetName;
  Null buildingNumber;
  String postCode;
  Null country;
  Null department;
  Null supDepartment;
  Null addressType;

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
    addressLine = json['addressLine'];
    county = json['county'];
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

class Loyalty {
  String sId;
  String merchantId;
  int points;

  Loyalty({this.sId, this.merchantId, this.points});

  Loyalty.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    merchantId = json['merchantId'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['merchantId'] = this.merchantId;
    data['points'] = this.points;
    return data;
  }
}

class Institution {
  String sId;
  Institution institution;
  String accountNumber;

  Institution({this.sId, this.institution, this.accountNumber});

  Institution.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    institution = json['institution'] != null
        ? new Institution.fromJson(json['institution'])
        : null;
    accountNumber = json['accountNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.institution != null) {
      data['institution'] = this.institution.toJson();
    }
    data['accountNumber'] = this.accountNumber;
    return data;
  }
}
/*
class Institution {
  String sId;
  String name;
  String institutionId;
  String logo;
  bool personal;
  bool business;
  String sortCode;

  Institution(
      {this.sId,
        this.name,
        this.institutionId,
        this.logo,
        this.personal,
        this.business,
        this.sortCode});

  Institution.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    institutionId = json['institutionId'];
    logo = json['logo'];
    personal = json['personal'];
    business = json['business'];
    sortCode = json['sortCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['institutionId'] = this.institutionId;
    data['logo'] = this.logo;
    data['personal'] = this.personal;
    data['business'] = this.business;
    data['sortCode'] = this.sortCode;
    return data;
  }
}*/
