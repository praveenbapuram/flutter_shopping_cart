import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    ProductsProvider productsProvider = Provider.of<ProductsProvider>(context);
    String productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        productsProvider.items.firstWhere((product) => product.id == productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
