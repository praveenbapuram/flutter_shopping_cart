import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/orders.dart';
import 'package:flutter_shopping_cart/widgets/app_drawer.dart';
import 'package:flutter_shopping_cart/widgets/order_item.dart' as otW;
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    // Future.delayed(Duration.zero).then((_) async {

    _isLoading = true;

    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .then((_) => setState(() {
              _isLoading = false;
            }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderProvider.orders.length,
              itemBuilder: (ctx, index) =>
                  otW.OrderItem(order: orderProvider.orders[index]),
            ),
    );
  }
}
