import 'dart:ffi';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/models/http_exception.dart';
import 'package:flutter_shopping_cart/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class ProductsProvider with ChangeNotifier {
  final String token;
  final String userId;

  ProductsProvider(this.token, this._items, this.userId);
  /* List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];*/

  /* var showFavoritesOnly = false; */
  List<Product> get items {
    /*  if (showFavoritesOnly) {
      return loadProducts.where((product) => product.isFavourite).toList();
    } else { */
    return _items;
    /* } */
  }

  List<Product> _items = [];

  Future<Void> addProduct(Product product) async {
    String url =
        'https://flutter-update-95299.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price.toString(),
          'description': product.description,
          'imageUrl': product.imageUrl,
          'createrId': userId,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Void> fetchAndSetProducts([bool filterByUser = false]) async {
    var filterByQuery =
        filterByUser ? 'orderBy="createrId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-update-95299.firebaseio.com/products.json?auth=${token}&${filterByQuery}';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final favUrl =
          'https://flutter-update-95299.firebaseio.com/userFavourites/$userId/.json?auth=$token';

      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: double.parse(prodData['price']),
          imageUrl: prodData['imageUrl'],
          isFavourite: favData == null
              ? false
              : (favData[prodId] == null) ? false : favData[prodId],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Void> updateProduct(
      String edittedProductId, Product newProduct) async {
    final index =
        _items.indexWhere((element) => element.id == edittedProductId);
    if (index > 0) {
      final url =
          'https://flutter-update-95299.firebaseio.com/products/${edittedProductId}.json?auth=$token';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price.toString(),
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl
          }));

      _items[index] = newProduct;
    }
    notifyListeners();
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  List<Product> get getFavouriteProducts {
    return _items.where((product) => product.isFavourite).toList();
  }

  int get itemCount {
    return _items.length;
  }

  void deleteProduct(String edittedProductId) async {
    final url =
        'https://flutter-update-95299.firebaseio.com/products/${edittedProductId}.json?auth=$token';

    final existingIndex =
        _items.indexWhere((element) => element.id == edittedProductId);
    var existingProd = _items[existingIndex];

    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode > 400) {
      _items.insert(existingIndex, existingProd);
      notifyListeners();
      throw HttpsException('could not delete product');
    }
    existingProd = null;
  }

  /*  void showFavouritesOnly() {
    showFavoritesOnly = true;
    notifyListeners();
  }

  void showAllProducts() {
    showFavoritesOnly = false;
    notifyListeners();
  } */
}
