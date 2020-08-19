import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/products_provider.dart';
import 'package:flutter_shopping_cart/screens/edit_product_screen.dart';
import 'package:flutter_shopping_cart/widgets/app_drawer.dart';
import 'package:flutter_shopping_cart/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/userProducts";

  Future<Void> _refreshProducts(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: <Widget>[
                              UerProductItem(
                                  id: productsData.items[i].id,
                                  title: productsData.items[i].title,
                                  imageUrl: productsData.items[i].imageUrl),
                              Divider(),
                            ],
                          ),
                          itemCount: productsData.itemCount,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
