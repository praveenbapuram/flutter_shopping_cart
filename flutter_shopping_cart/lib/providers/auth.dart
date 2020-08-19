import 'package:flutter/cupertino.dart';
import 'package:flutter_shopping_cart/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiyDate;
  String _userId;
  Timer _authTimer;
  static const _API_KEY = 'AIzaSyA9ldOkOobPVPr4Z_7i-ZT1cSZWO77_S8k';

  bool get isAuth {
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  String get userId {
    return _userId;
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
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiry': _expiyDate.toIso8601String()
      });
      prefs.setString('userData', userData);
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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.get('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedUserData['expiry']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiyDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiyDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    var timetoExpiry = _expiyDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timetoExpiry), logout);
  }
}
