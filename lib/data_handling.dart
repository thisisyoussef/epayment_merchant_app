import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'models/institution.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

void _launchURL(String _url) async {
  if (_url.contains('www.')) {
    _url = _url.replaceAll("www.", "");
    print(_url);
  }
  await canLaunch(_url)
      ? await launch(_url, forceSafariVC: false, forceWebView: false)
      : print("Could not launch $_url");
}

BusinessInfoDetails businessInfo = BusinessInfoDetails();
Map<String, dynamic> deviceData = <String, dynamic>{};

String errorMessage = "";
Future<void> readDeviceData() async {
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }

  try {
    if (kIsWeb) {
      deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
    } else {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      } else if (Platform.isLinux) {
        deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
      } else if (Platform.isMacOS) {
        deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
      } else if (Platform.isWindows) {
        deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
      }
    }
  } on PlatformException {
    deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
  }
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString('uniqueId', deviceData["id"].toString());
  print("Device Data ID " + deviceData["id"].toString());
}

void addTransaction(
    {String payee,
    String runner,
    double amount,
    String description,
    double tip}) async {
  var response = await http.post(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/payment/addTransaction"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${businessInfo.token}',
    },
    body: jsonEncode(<String, dynamic>{
      "payee": payee,
      "runner": runner,
      "amount": amount,
      "description": description,
      "tip": tip
    }),
  );
  print(response.body);
}

readToken(var data, Function errorMessageCallback) async {
  try {
    if (data == "Invalid email or password") {
      errorMessageCallback(data);
    } else {
      print(data);
      var decodedData = jsonDecode(data);

      //merchantInfo.setToken(token);
      print(businessInfo.token);
      if (decodedData['message'] == null) {
        print("No message");
        errorMessageCallback("");
      }
      print("The token in response is " + decodedData['token']);
      if (decodedData['token'] != null) {
        businessInfo.token = decodedData['token'];
        print(businessInfo.token);
      }

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', businessInfo.token);
      print("Token grabbed from local storage " + businessInfo.token);
      sharedPreferences.getString('token');
    }
  } catch (e) {
    print(e);
  }
}

checkToken(var data, Function errorMessageCallback, String token) async {
  if (data == "Invalid email or password") {
    errorMessageCallback(data);
  } else {
    print(data);
    var decodedData = jsonDecode(data);
    if (decodedData['message'] == null) {
      errorMessageCallback("");
    }
    if (decodedData['token'] == null || decodedData['token'] != token) {
      errorMessageCallback(data);
    } else {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', businessInfo.token);
    }
  }
}

readEmail(var data) async {
  try {
    if (data != "Invalid email or password") {
      var decodedData = jsonDecode(data);
      dynamic email = decodedData['merchant']['email'];
      print(email);
      businessInfo.email = email;
      print(businessInfo.email);
    }

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('email', businessInfo.email);
  } catch (e) {
    print(e);
  }
}

readPassword(var data) async {
  if (data != "Invalid email or password") {
    var decodedData = jsonDecode(data);
    dynamic password = decodedData['merchant']['password'];
    print(password);
    businessInfo.password = password;
    print(businessInfo.password);
  }

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString('password', businessInfo.password);
}

generatePin() async {
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/generatePin/${businessInfo.email}"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{}),
  );
  print(response.body);
}

getInstitutionLogo(String sortCode, Function callBack) async {
  Image suggestedInstitutionLogo;
  if (sortCode == "") {
    suggestedInstitutionLogo = null;
  } else {
    var response = await http.get(
      Uri.http(
        "institutionfilter.strykepay.co.uk",
        '/institution/institutionFilter',
        {'sortCode': sortCode},
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${businessInfo.token}',
      },
    );
    var decodedData = jsonDecode(response.body);
    callBack(Image.network(decodedData[0]['logo']));
  }
}

sortCodeToBank(String sortCode, Function updateList) async {
  //Attempts to
  //loadingNotifier(true);
  String currentInstitutionId = "";
  String currentInstitutionName = "";
  Image suggestedInstitutionLogo;
  List<Image> institutionLogos = [];
  List<Institution> results = [];
  if (sortCode == "") {
    suggestedInstitutionLogo = null;
  }
  var response = await http.get(
    Uri.http(
      "institutionfilter.strykepay.co.uk",
      '/institution/institutionFilter',
      {'sortCode': sortCode},
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${businessInfo.token}',
    },
  );
  var decodedData;
  if (sortCode == "") {
    return false;
  }
  if (response.statusCode == 200) {
    decodedData = jsonDecode(response.body);
    suggestedInstitutionLogo = null;
    suggestedInstitutionLogo = Image.network(decodedData[0]['logo']);
    currentInstitutionId = decodedData[0]['_id'];
    for (var result in decodedData) {
      if (result['institutionId'] != currentInstitutionId) {
        //  if (result['name'] != currentInstitutionName) {
        currentInstitutionName = result['name'];
        results.add(Institution(
            id: result['_id'],
            name: currentInstitutionName,
            logo: result['logo'],
            logoImage: Image.network(result['logo']),
            personal: result['personal'],
            business: result['business']));
        print(result['name']);
        // }
      }
    }
    updateList(results);
    return true;
  } else {
    print("error response");
    return false;
  }
}

addInstitution(String institutionId, String accountNumber) async {
  String token = businessInfo.token;
  if (token.isEmpty) {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/addInstitution/"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "institution_id": institutionId,
      "accountNumber": accountNumber,
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return true;
  } else {
    print(response.body);
    return false;
  }
}

removeInstitution(String institutionId) async {
  print("deleting with id: " + institutionId);
  String token = businessInfo.token;
  if (token.isEmpty) {
    print("Empty token when removing inst");
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/removeInstitution/$institutionId"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      // "institutionId": institutionId,
    }),
  );

//  businessInfo.userInstitutions.removeAt(businessInfo.userInstitutions
  //    .indexWhere((element) => element.getId() == institutionId));
  print("Response from removing: " + response.body);
}

removeAccount(String accountNumber, String institutionId) async {
  String token = businessInfo.token;
  if (token.isEmpty) {
    print("Empty token when removing inst");
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }
  final queryParameters = {
    'accountNumber': accountNumber,
    'institution': institutionId,
    "asdsad": "sada",
  };
  var response = await http.put(
    Uri.https('profile.services.strykepay.co.uk',
        '/merchant/removeInstitutionAccount/', queryParameters),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

//  businessInfo.userInstitutions.removeAt(businessInfo.userInstitutions
  //    .indexWhere((element) => element.getId() == institutionId));
  print("Response from removing account: " + response.body);
}

verifyPin(String _pin, Function errorMessageCallback) async {
  var response = await http.put(
      Uri.parse(
          "https://profile.services.strykepay.co.uk/merchant/verifyyMerchant/${businessInfo.email}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "pin": _pin,
      }));
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    if (decodedData['message'] != null) {
      if (decodedData['message'] == "Pin is not correct") {
        errorMessageCallback("Code is incorrect, please try again");
      } else {
        errorMessageCallback("");
      }
    }
    print(response.body);
    return true;
  } else {
    print("couldn't verify pin");
    return false;
  }
}

createPin(String loginPin) async {
  print("Creating Pin..");
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/setLoginPin/${businessInfo.email}"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "loginPin": loginPin,
      "confirmLoginPin": loginPin,
    }),
  );
  print(response.body);
  return response.body;
}

resetPin(String loginPin) async {
  print("Resetting Pin..");
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/updateLoginPin/"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ${businessInfo.token}',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "oldLoginPin": businessInfo.loginPin,
      "newLoginPin": loginPin,
      "confirmLoginPin": loginPin,
    }),
  );
  if (response.statusCode == 200) {
    print("Sent OTP");
    return true;
  } else {
    print("No OTP Sent");
    return false;
  }
}

checkInstitution(
    {String token, Function emptyCallBack, Function notEmptyCallBack}) async {
  if (token == null || token.isEmpty) {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }
  print("Token is " + token);
  var response = await myProfile(token);
  var decodedData = jsonDecode(response);
  List institutions = decodedData['merchant']['institution'];
  if (institutions.isEmpty) {
    print("No institutions");
    emptyCallBack();
  } else {
    print("Institution(s) exist");

    notEmptyCallBack(institutions);
  }
  return institutions;
}

clearInstitutions() {
  while (businessInfo.userInstitutions.isNotEmpty) {
    print("Not empty");
    checkInstitution(
        token: businessInfo.token,
        notEmptyCallBack: (var x) {
          removeInstitution(
            businessInfo.userInstitutions[0].getId(),
          );
        },
        emptyCallBack: () {});
    businessInfo.userInstitutions.removeAt(0);
  }
  print("Emptied");
}

setInstitution(
    {String token, Function errorCallback, Function successCallBack}) async {
  if (token == null || token.isEmpty) {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }
  print("Token is " + token);
  var response = await myProfile(token);
  print(myProfile(token));
  var decodedData = await jsonDecode(response);
  List institutions = await decodedData['merchant']['institution'];
  if (institutions.isEmpty) {
    print("No institutions");
    errorCallback();
  } else {
    List<Institution> institutionObjects = [];
    for (var institution in institutions) {
      institutionObjects.add(Institution(
        //institutionID: institution['institutionId'],
        id: institution['_id'],
        //sortCode: institution['sortCode'],
        //accountNumber: institution['accountNumber'],
        logo: institution['institution']['logo'],
        institutionID: institution['institution']['_id'],
        accountNumber: institution['accountNumber'],
        name: institution['institution']['name'],
      ));
      print(institutions[institutions.indexOf(institution)]);
    }
    print("Institution(s) exist");
    businessInfo.userInstitutions = institutionObjects;
    successCallBack(institutionObjects);
  }
  return institutions;
}

// print(businessInfo.token);
logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

myProfile(String token) async {
  String errorMessage;
  print("Checking my profile..");
  if (businessInfo.token == null ||
      businessInfo.token.isEmpty ||
      token.isEmpty ||
      token == null) {
    print("empty token");
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    businessInfo.token = sharedPreferences.getString('token');
    token = sharedPreferences.getString('token');
  }
  var response;
  print("Token is " + businessInfo.token.toString());
  response = await http.get(
    Uri.parse("https://profile.services.strykepay.co.uk/merchant/myProfile"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ${businessInfo.token}',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(businessInfo.token);
  print("My profile response :" + response.body);
  var decodedData;
  decodedData = jsonDecode(response.body);
  //print("Decoded data is " + decodedData);
  businessInfo.email = decodedData['Merchant']['email'];
  businessInfo.name = decodedData['Merchant']['businessName'];
  businessInfo.dobString = decodedData['Merchant']['dob'];
  businessInfo.postcode = decodedData['Merchant']['address']['postCode'];
  businessInfo.loginPin = decodedData['Merchant']['loginPin'];
  businessInfo.id = decodedData['Merchant']['_id'];
  businessInfo.vatNumber = decodedData['Merchant']['VATNumber'];
  businessInfo.addressLine = decodedData['Merchant']['address'];
  businessInfo.addressline1 = businessInfo.addressLine.split("\n")[0];
  businessInfo.addressline2 = businessInfo.addressLine.split("\n")[1];
  businessInfo.addressline3 = businessInfo.addressLine.split("\n")[2];
  print("Merchant id " + businessInfo.id);
  // DateTime.tryParse(businessInfo.dobString);
  businessInfo.userInstitutions = [];
  businessInfo.userInstitutions.clear();
  for (var inst in decodedData['Merchant']['institution']) {
    businessInfo.userInstitutions.add(
      Institution(
        id: inst['_id'],
        logo: inst['institution']['logo'],
        accountNumber: inst['accountNumber'],
        institutionID: inst['institution']['_id'],
        name: inst['institution']['name'],
        logoImage: Image.network(inst['institution']['logo']),
      ),
    );
    print("Recorded institution with id :" +
        inst['_id'].toString() +
        inst['institution']['logo'].toString());
  }
  return response.body;
}

checkPin(String token, String pin, Function errorCallback,
    Function successCallback) async {
  print("Checking PIN: " + pin);
  print("Token is: " + token);
  var response = await myProfile(token);
  print(businessInfo.token);
  var decodedData = jsonDecode(response.body);
  print(response.body);
  if (decodedData['merchant']['loginPin'] == pin) {
    print("Correct Pin");
    print(decodedData['merchant']['loginPin']);
    successCallback();
    return true;
  } else {
    print("Wrong Pin");
    errorCallback();
    return false;
  }
}

signUp(
    {BusinessInfoDetails businessInfoWrapper,
    Function errorMessageCallBack}) async {
  businessInfoWrapper.errorMessage = "";

  print("Signing up..");
  var response = await http.post(
    Uri.parse("https://profile.services.strykepay.co.uk/merchant/signUp"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "businessName": businessInfoWrapper.name,
      "companyNumber": businessInfoWrapper.number,
      "password": businessInfoWrapper.password,
      "email": businessInfoWrapper.email,
      //"dob": businessInfoWrapper.dobString,
      "postCode": " ",
      "phone": businessInfoWrapper.number,
      "VATNumber": "A VATNumber",
      "addressLine": "abc",
      "streetName": "streetName",
      "buildingNumber": "buildingNumber",
      "county": "county",
      "country": "country",
      "department": "department",
      "supDepartment": "subDepartment",
      "addressType": "addressType",
      "uniqueId": deviceData["id"].toString()
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
    var decodedData = jsonDecode(response.body);
    businessInfo.token = decodedData['token'];
    businessInfo.email = decodedData['merchant']['email'];
    businessInfo.token = decodedData['token'];
    print(decodedData['token']);
    print(decodedData);
    print("INfoo");
    print("token is " + businessInfo.token);
    print(response.body);
    return true;
  } else {
    return false;
  }
  //var decodedData = jsonDecode(response.body);
  //print(decodedData['token']);
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString('uniqueId', deviceData["id"].toString());
}

updateInfo(
    {BusinessInfoDetails businessInfoWrapper,
    Function errorMessageCallBack}) async {
  var headers = {
    'Authorization': 'Bearer ${businessInfo.token}',
    'Content-Type': 'application/json'
  };
  var request = http.Request(
      'PUT',
      Uri.parse(
          'https://profile.services.strykepay.co.uk/merchant/updateInfo'));
  request.body = json.encode({
    "phone": businessInfoWrapper.number,
    "businessName": businessInfoWrapper.name,
    "addressLine": businessInfoWrapper.addressLine,
    "streetName": "streetName",
    "buildingNumber": "buildingNumber",
    "postCode": businessInfoWrapper.postcode,
    "county": "county",
    "country": "country",
    "department": "department",
    "supDepartment": "subDepartment",
    "addressType": "addressType",
    "VATNumber": businessInfoWrapper.VATNumber
  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

updatePassword(
    {BusinessInfoDetails businessInfoWrapper,
    Function errorMessageCallBack}) async {
  businessInfoWrapper.errorMessage = "";
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/updatePassword/${businessInfo.email}"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ${businessInfo.token}',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "password": businessInfoWrapper.password,
      "confirmPassword": businessInfoWrapper.password,
    }),
  );

  if (response.statusCode != 200) {
    var decodedData = jsonDecode(response.body);
    errorMessageCallBack(decodedData['message']);
  }
  print(response.body);
}

remoteLogout(String pin) async {
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/remoteLogout/${businessInfo.email}"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ${businessInfo.token}',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "loginPin": pin,
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return true;
  } else {
    print(response.body);
    print(response.statusCode);
    return false;
  }
}

login(
    {BusinessInfoDetails businessInfoWrapper,
    Function errorMessageCallBack}) async {
  businessInfoWrapper.errorMessage = "";
  print("Logging in..");
  print("Logging in with: " +
      businessInfoWrapper.email +
      businessInfoWrapper.password);
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString('uniqueId', deviceData["id"].toString());
  var response = await http.post(
    Uri.parse("https://profile.services.strykepay.co.uk/merchant/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "password": businessInfoWrapper.password,
      "email": businessInfoWrapper.email,
      "uniqueId": deviceData["id"].toString(), //deviceData["id"].toString(),
      //"os": "Android",
    }),
  );
  print(deviceData["id"].toString());
  if (response.statusCode == 400) {
    print("400");
    print(response.body);
    errorMessageCallBack("Invalid Email or Password");
    return false;
  } else if (response.statusCode == 401) {
    print("401");
    print(response.body);
    if (response.body ==
        "You are logging from new device, Would you like to add it to you your devices?.") {
      errorMessageCallBack(402);
      return false;
    } else {
      errorMessageCallBack(401);
      return false;
    }
  } else {
    var decodedData = jsonDecode(response.body);
    businessInfo.token = decodedData['token'];
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('token', businessInfo.token);
    sharedPreferences.setString('email', businessInfo.email);
    print("Token grabbed from local storage " + businessInfo.token);
    sharedPreferences.getString('token');
    return true;
  }
}

addDevice(String pin) async {
  print("Adding Device..");
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString('uniqueId', deviceData["id"].toString());
  deviceData.addAll(<String, String>{
    "loginPin": pin,
    "os": "IOS",
    "version.securityPatch": "build.version.securityPatch",
    "uniqueId":
        sharedPreferences.getString("id"), //deviceData["id"].toString(),
    //"os": "Android",
  });
  var response = await http.post(
      Uri.parse(
          "https://profile.services.strykepay.co.uk/merchant/addDevice/${businessInfo.email}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "loginPin": pin,
        "os": "IOS",
        "version.securityPatch": "build.version.securityPatch",
        "uniqueId": deviceData["id"].toString(),
        //"os": "Android",
      }));
  print("Add device response :" + response.body);
  if (response.statusCode == 200) {
    return true;
  } else {
    print(response.statusCode);
    return false;
  }
}

checkIn({String token}) async {
  if (businessInfo.token == null ||
      businessInfo.token.isEmpty ||
      token.isEmpty ||
      token == null) {
    print("empty token");
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    businessInfo.token = sharedPreferences.getString('token');
    token = sharedPreferences.getString('token');
  }
  print("Token is " + businessInfo.token.toString());
  var response = await http.get(
    Uri.parse("https://profile.services.strykepay.co.uk/merchant/myProfile"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer ${businessInfo.token}',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

requestResetPassword(
    String email, Function errorCallback, Function successCallBack) async {
  var response = await http.post(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/requestResetPassword/$email"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    businessInfo.number = decodedData['Merchant'];
    print(response.body);
    successCallBack();
  } else {
    print("error");
    errorCallback();
  }
}

checkOTP(String email, Function errorCallBack, Function successCallBack) async {
  print(email);
  var response = await http.get(
    Uri.http(
      "profile.services.strykepay.co.uk",
      '/merchant/checkOTP/$email',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    print(response.body);
    successCallBack();
  } else {
    print(response.body);
    print("Invalid COde");
    errorCallBack();
  }
}

addLogo(String path) async {
  var headers = {'Authorization': 'Bearer ${businessInfo.token}'};
  var request = http.MultipartRequest('PUT',
      Uri.parse('https://profile.services.strykepay.co.uk/merchant/addLogo'));
  if (path == null) {
    return false;
  }
  request.files.add(await http.MultipartFile.fromPath('upload', path));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}

verifyMerchant(String email, Function errorCallBack, Function successCallBack,
    String otp) async {
  var response = await http.put(
    Uri.parse(
        'https://profile.services.strykepay.co.uk/merchant/verifyMerchant/$email'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "pin": otp,
    }),
  );

  if (response.statusCode == 200) {
    print(await response.body);
    var decodedData = jsonDecode(response.body);
    businessInfo.token = decodedData['token'];
    return true;
  } else {
    print(response.reasonPhrase);
    return false;
  }
}
