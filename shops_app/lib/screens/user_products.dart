import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/drawer.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAnSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _refreshProducts(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (context, index) {
              return UserProductItem(
                id: products.items[index].id!,
                title: products.items[index].title,
                imageUrl: products.items[index].imageUrl,
              );
            },
          ),
        ),
      ),
    );
  }
}
