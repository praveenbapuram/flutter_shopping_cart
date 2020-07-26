import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/products_provider.dart';
import 'package:flutter_shopping_cart/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favoutites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showOnlyFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favoutites) {
                  showOnlyFavourite = true;
                } else {
                  showOnlyFavourite = false;
                }
              });
            },
            icon: Icon(Icons.more),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: FilterOptions.Favoutites,
                ),
                PopupMenuItem(
                  child: Text('Show all.'),
                  value: FilterOptions.All,
                ),
              ];
            },
          )
        ],
      ),
      body: ProductsGrid(showOnlyFavourite),
    );
  }
}
