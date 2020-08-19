import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/providers/auth.dart';
import 'package:flutter_shopping_cart/providers/cart_provider.dart';
import 'package:flutter_shopping_cart/providers/orders.dart';
import 'package:flutter_shopping_cart/providers/products_provider.dart';
import 'package:flutter_shopping_cart/screens/auth_screen.dart';
import 'package:flutter_shopping_cart/screens/cart_screen.dart';
import 'package:flutter_shopping_cart/screens/edit_product_screen.dart';
import 'package:flutter_shopping_cart/screens/orders_screen.dart';
import 'package:flutter_shopping_cart/screens/splash_screen.dart';
import 'package:flutter_shopping_cart/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shopping_cart/screens/product_details_screen.dart';
import 'package:flutter_shopping_cart/screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            update: (ctx, auth, previousProducts) => ProductsProvider(
                auth.token,
                previousProducts == null ? null : previousProducts.items,
                auth.userId)),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrder) => Orders(auth.token,
              previousOrder == null ? [] : previousOrder.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
