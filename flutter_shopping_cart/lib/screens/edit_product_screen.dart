import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/product.dart';
import 'package:flutter_shopping_cart/providers/products_provider.dart';
import 'package:flutter_shopping_cart/screens/product_details_screen.dart';
import 'package:flutter_shopping_cart/screens/products_overview_screen.dart';
import 'package:flutter_shopping_cart/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProductScreen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imeageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var edittedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  @override
  void initState() {
    // TODO: implement initState
    _imeageURLController.addListener(_updateImageURL);
    super.initState();
  }

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        edittedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);

        _isInit = false;

        _initValues = {
          'title': edittedProduct.title,
          'price': edittedProduct.price.toString(),
          'description': edittedProduct.description,
          // 'imageUrl': edittedProduct.imageUrl,
          'imageUrl': '',
        };
        _imeageURLController.text = edittedProduct.imageUrl;
      }
    }

    super.didChangeDependencies();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      var value = _imeageURLController.text;
      if (value.isEmpty ||
          (!(value.startsWith('http') ||
              value.startsWith('https') ||
              value.endsWith('jpeg') ||
              value.endsWith('png')))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imeageURLController.removeListener(_updateImageURL);
    _imeageURLController.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      print(edittedProduct.title);
      print(edittedProduct.description);
      print(edittedProduct.price);
      print(edittedProduct.imageUrl);
    }
    _form.currentState.save();
    if (edittedProduct.id == null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(edittedProduct);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(edittedProduct.id, edittedProduct);
    }

    Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                initialValue: _initValues['title'],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a Value';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  edittedProduct = Product(
                    title: value,
                    description: edittedProduct.description,
                    price: edittedProduct.price,
                    imageUrl: edittedProduct.imageUrl,
                    id: edittedProduct.id,
                    isFavourite: edittedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  initialValue: _initValues['price'],
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a Value';
                    } else if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    } else if (double.tryParse(value) <= 0) {
                      return 'Please enter a number greater than 0';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    edittedProduct = Product(
                      title: edittedProduct.title,
                      description: edittedProduct.description,
                      price: double.parse(value),
                      imageUrl: edittedProduct.imageUrl,
                      id: edittedProduct.id,
                      isFavourite: edittedProduct.isFavourite,
                    );
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  initialValue: _initValues['description'],
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a Value';
                    } else if (value.length <= 10) {
                      return 'Please enter atleast 10 characters';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    edittedProduct = Product(
                      title: edittedProduct.title,
                      description: value,
                      price: edittedProduct.price,
                      imageUrl: edittedProduct.imageUrl,
                      id: edittedProduct.id,
                      isFavourite: edittedProduct.isFavourite,
                    );
                  }),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1), color: Colors.grey),
                    child: _imeageURLController.text.isEmpty
                        ? Text('Enter image url')
                        : FittedBox(
                            child: Image.network(_imeageURLController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    child: Expanded(
                      child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imeageURLController,
                          focusNode: _imageURLFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a url';
                            } else if (!(value.startsWith('http') ||
                                value.startsWith('https'))) {
                              return 'enter valid url';
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (value) {
                            edittedProduct = Product(
                              title: edittedProduct.title,
                              description: edittedProduct.description,
                              price: edittedProduct.price,
                              imageUrl: value,
                              id: edittedProduct.id,
                              isFavourite: edittedProduct.isFavourite,
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
