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
/*
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
  }*/

  @override
  Widget build(BuildContext context) {
    // var orderProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataSnapShot.error != null) {
              //error handling
              return Center(
                child: Text('error occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderProvider, child) => ListView.builder(
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (ctx, index) =>
                      otW.OrderItem(order: orderProvider.orders[index]),
                ),
              );
            }
          }),
    );
  }
}
