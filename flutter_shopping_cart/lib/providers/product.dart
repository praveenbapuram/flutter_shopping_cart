import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  void _setFavouriteValue(bool value) {
    isFavourite = value;
    notifyListeners();
  }

  void toggleFavouriteState() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://flutter-update-95299.firebaseio.com/products/${id}';
    try {
      final response = await http.patch(url,
          body: json.encode(
            {
              'isFavourite': isFavourite,
            },
          ));
      if (response.statusCode > 400) {
        _setFavouriteValue(oldStatus);
      }
    } catch (error) {
      _setFavouriteValue(oldStatus);
    }
  }
}
