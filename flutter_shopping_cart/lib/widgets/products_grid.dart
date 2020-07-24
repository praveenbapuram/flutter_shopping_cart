import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/products_provider.dart';
import 'package:flutter_shopping_cart/widgets/products_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of rows
        childAspectRatio: 3 / 2, // length to height ratio
        crossAxisSpacing: 10, // horizontal spacing between the grid items.
        mainAxisSpacing: 10, // vertical spacing between the grid items.
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider(
          create: (ct) => products[index],
          child: ProductsItem(
              /*  id: products[index].id,
            title: products[index].title,
            imageUrl: products[index].imageUrl, */
              ),
        );
      },
      itemCount: products.length,
    );
  }
}
