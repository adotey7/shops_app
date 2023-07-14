import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';
import '../widgets/drawer.dart';
import '../widgets/badge.dart' as badge;

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavorites = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAnSetProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == FilterOptions.favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Show Favorites'),
                value: FilterOptions.favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) {
              return badge.Badge(
                value: cart.itemCount.toString(),
                child: ch!,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavorites),
    );
  }
}
