import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {
      // required this.onPressedCart,
      super.key});

  // final VoidCallback onPressedCart;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () async {
              try {
                await product.toggleFavorites();
                if (product.isFavorite) {
                  scaffold.showSnackBar(const SnackBar(
                      content: Text('Successfully added as favorite')));
                } else {
                  scaffold.showSnackBar(const SnackBar(
                      content: Text('Successfully removed as favorite')));
                }
              } catch (e) {
                if (product.isFavorite) {
                  scaffold.showSnackBar(const SnackBar(
                      content:
                          Text('Failed to remove as favorite. Try again...')));
                } else {
                  scaffold.showSnackBar(const SnackBar(
                      content:
                          Text('Failed to add as favorite. Try again...')));
                }
              }
            },
            icon: product.isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(
                    Icons.favorite_outline,
                  ),
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            product.title,
            // style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id!, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Added to cart successfully!'),
                duration: const Duration(
                  seconds: 2,
                ),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id!);
                    }),
              ));
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
