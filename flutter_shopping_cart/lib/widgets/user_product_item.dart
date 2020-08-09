import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/products_provider.dart';
import 'package:flutter_shopping_cart/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UerProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UerProductItem({Key key, this.title, this.imageUrl, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
