import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/products_overview.dart';
import './screens/order_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            primary: Colors.pinkAccent,
            onPrimaryContainer: Colors.pink,
            secondary: Colors.deepOrange,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.pinkAccent,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Lato',
            ),
          ),
          useMaterial3: true,
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
