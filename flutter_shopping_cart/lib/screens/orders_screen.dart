import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/orders.dart';
import 'package:flutter_shopping_cart/widgets/app_drawer.dart';
import 'package:flutter_shopping_cart/widgets/order_item.dart' as otW;
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderProvider.orders.length,
        itemBuilder: (ctx, index) =>
            otW.OrderItem(order: orderProvider.orders[index]),
      ),
    );
  }
}
