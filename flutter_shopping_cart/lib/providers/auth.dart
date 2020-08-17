import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shopping_cart/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiyDate;
  String _userId;
  static const _API_KEY = 'AIzaSyA9ldOkOobPVPr4Z_7i-ZT1cSZWO77_S8k';

  bool get isAuth {
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  String get token {
    if (_expiyDate != null &&
        _expiyDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> authenticate(
      String email, String password, String action) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:${action}?key=${_API_KEY}';
    var reponse;
    try {
      reponse = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print(json.decode(reponse.body));
      var responseData = json.decode(reponse.body);
      if (responseData['error'] != null) {
        throw HttpsException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expiyDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return await authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return await authenticate(email, password, 'signInWithPassword');
  }
}
