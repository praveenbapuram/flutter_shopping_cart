import 'package:flutter/material.dart';

class ProductDetailScreem extends StatelessWidget {
  final String title;

  const ProductDetailScreem({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
