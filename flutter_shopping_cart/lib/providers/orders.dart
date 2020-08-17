import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_shopping_cart/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get orders {
    return [..._orderItems];
  }

  Future<Void> fetchAndSetOrders() async {
    String url = 'https://flutter-update-95299.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    var extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: ((orderData['products']) as List<dynamic>)
              .map((cartItem) => CartItem(
                  id: cartItem['id'],
                  price: cartItem['price'],
                  title: cartItem['title'],
                  quantity: cartItem['quantity']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });

    _orderItems = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const String url =
        'https://flutter-update-95299.firebaseio.com/orders.json';
    var time = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': time.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'tittle': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orderItems.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
