import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  ProductsGrid(
    this.isFavorite, {
    super.key,
  });
  bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        isFavorite ? productsData.favoritesOnly : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: const ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
