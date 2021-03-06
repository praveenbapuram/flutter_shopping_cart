import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/auth.dart';
import 'package:flutter_shopping_cart/providers/cart_provider.dart';
import 'package:flutter_shopping_cart/providers/product.dart';
import 'package:flutter_shopping_cart/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductsItem extends StatelessWidget {
/*   final String id;
  final String title;
  final String imageUrl;

  static const routeName = '/productDetail';
  const ProductsItem({Key key, this.id, this.title, this.imageUrl})
      : super(key: key); */
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context, listen: false);
    final cartData = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productData.id);
          },
          child: Image.network(
            productData.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                productData.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                productData.toggleFavouriteState(auth.token, auth.userId);
              },
            ),
            child: Text('Never changes'),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cartData.addItem(
                  productData.id, productData.price, productData.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added Item to cart.'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cartData.removeSingleItem(productData.id);
                  },
                ),
              ));
            },
          ),
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
