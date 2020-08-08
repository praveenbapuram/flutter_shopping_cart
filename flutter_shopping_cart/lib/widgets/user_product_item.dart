import 'package:flutter/material.dart';

class UerProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UerProductItem({Key key, this.title, this.imageUrl}) : super(key: key);

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
              onPressed: null,
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: null,
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
