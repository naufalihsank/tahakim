import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:tahakim/models/user.dart';

mixin MainUtility on Model {
  bool isLoading = false;
  User authenticatedUser;
  List<dynamic> listKetinggianWU = [];
  List<dynamic> listKetinggianSaluran1 = [];
  List<dynamic> listKetinggianSaluran2 = [];
  List<dynamic> listKetinggianAliran1 = [];
  List<dynamic> listKetinggianAliran2 = [];

  bool get getIsLoading {
    return isLoading;
  }

  User get getUser {
    return authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(
      String username, String password) async {
    // Kalau async, fungsi nya harus berupa Future<>
    // print('Masuk Authenticate');
    isLoading = true;
    // print(isLoading);
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email':
          username, //nama key yang ada '' nya harus sesuai dengan key yang diminta di docs
      'password':
          password, //nama key yang ada '' nya harus sesuai dengan key yang diminta di docs
    };
    // print(authData);
    bool hasError = true;
    String message = 'Something went wrong';
    try {
      http.Response response;
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB0duIxVtv-5OnOx35Yh007EdgzS8GOHd4',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );

      // print('RESPONSE LOGIN');

      // MULAI PROSES RESPONSE APAKAH BERHASIL ATAU TIDAK

      final Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);

      if (responseData['idToken'] != null) {
        message = responseData['msg'];

        // Setting Time Out Session

        hasError = false;
        message = 'Authentication Succeeded!';
        authenticatedUser = User(
          email: responseData['email'],
        );
      } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
        // Key dari error code yang sering muncul ada di docs firebase
        //struktur responseData didapatkan saat nge print response body yang sudah di decode
        message = 'This email already exists.';
      } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
        // Key dari error code yang sering muncul ada di docs firebase
        //struktur responseData didapatkan saat nge print response body yang sudah di decode
        message = 'This email was not found.';
      } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
        // Key dari error code yang sering muncul ada di docs firebase
        //struktur responseData didapatkan saat nge print response body yang sudah di decode
        message = 'The password is invalid.';
      }
      isLoading = false;
      notifyListeners();

      return {
        'success': !hasError,
        'message': message,
      };
    } catch (error) {
      isLoading = false;
      notifyListeners();
      // print('MASUK ERROR');
      // print('ERROR nya' + error.toString());
      if (error.toString() ==
          "SocketException: Failed host lookup: 'mybrains.telkom.co.id' (OS Error: No address associated with hostname, errno = 7)") {
        message = 'Please connect to intranet connection';
      } else {
        message = error.toString();
      }
      return {
        'success': !hasError,
        'message': message,
      };
    }
  }

  void logout() {
    authenticatedUser = null;
  }

  // Future<double> fetchData() async {
  //   isLoading = true;
  //   notifyListeners();
  //   http.Response response = await http
  //       .get('https://cobalagilagi6969.firebaseio.com/cobalagilagi6969.json');
  //   print('Beres fetch data');
  //   listKetinggian = [];
  //   final Map<String, dynamic> responseData = json.decode(response.body);
  //   responseData.forEach((key, value) {
  //     listKetinggian.add(value);
  //   });
  //   print('Ketinggian Akhir');
  //   print(listKetinggian[listKetinggian.length - 1]['tinggi']);
  //   isLoading = false;
  //   notifyListeners();
  //   return listKetinggian[listKetinggian.length - 1]['tinggi'];
  // }

  Future<bool> postManualGate(String numberGate, bool value) async {
    // isLoading = true;
    // notifyListeners();
    Map<String, bool> gateData = {
      "bukaan": value,
    };
    final http.Response response = await http.put(
      //await sama kayak .then()
      'https://cobalagilagi6969.firebaseio.com/gerbang$numberGate.json', // auth=${_authenticatedUser.token} untuk mengikutsertakan token dari user saat fetching data
      body: json.encode(gateData),
    );
    // print(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);
    // isLoading = false;
    // notifyListeners();
    return true;
  }

  Future<bool> postModeKontrol(bool value) async {
    // isLoading = true;
    // notifyListeners();
    Map<String, bool> gateData = {
      "value": value,
    };
    final http.Response response = await http.put(
      //await sama kayak .then()
      'https://cobalagilagi6969.firebaseio.com/controltab.json', // auth=${_authenticatedUser.token} untuk mengikutsertakan token dari user saat fetching data
      body: json.encode(gateData),
    );
    // print(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);
    // isLoading = false;
    // notifyListeners();
    return true;
  }

  List<dynamic> get getlistKetinggianWU {
    return listKetinggianWU;
  }

  List<dynamic> get getlistKetinggianSaluran1 {
    return listKetinggianSaluran1;
  }

  List<dynamic> get getlistKetinggianSaluran2 {
    return listKetinggianSaluran2;
  }

  List<dynamic> get getlistKetinggianAliran1 {
    return listKetinggianAliran1;
  }

  List<dynamic> get getlistKetinggianAliran2 {
    return listKetinggianAliran2;
  }

  void addKetinggianWU(dynamic value) {
    if (listKetinggianWU.length < 150) {
      listKetinggianWU.add(value);
    } else {
      listKetinggianWU.removeAt(0);
      listKetinggianWU.add(value);
    }
    notifyListeners();
  }

  void addKetinggianSaluran1(dynamic value) {
    if (listKetinggianSaluran1.length < 150) {
      listKetinggianSaluran1.add(value);
    } else {
      listKetinggianSaluran1.removeAt(0);
      listKetinggianSaluran1.add(value);
    }
    notifyListeners();
  }

  void addKetinggianSaluran2(dynamic value) {
    if (listKetinggianSaluran2.length < 150) {
      listKetinggianSaluran2.add(value);
    } else {
      listKetinggianSaluran2.removeAt(0);
      listKetinggianSaluran2.add(value);
    }
    notifyListeners();
  }

  void addKetinggianAliran1(dynamic value) {
    if (listKetinggianAliran1.length < 150) {
      listKetinggianAliran1.add(value);
    } else {
      listKetinggianAliran1.removeAt(0);
      listKetinggianAliran1.add(value);
    }
    notifyListeners();
  }

  void addKetinggianAliran2(dynamic value) {
    if (listKetinggianAliran2.length < 150) {
      listKetinggianAliran2.add(value);
    } else {
      listKetinggianAliran2.removeAt(0);
      listKetinggianAliran2.add(value);
    }
    notifyListeners();
  }
}
