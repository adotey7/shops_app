import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.productId,
      required this.quantity,
      super.key});
  final String id;
  final double price;
  final String productId;
  final int quantity;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove item from cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              'Total: \$${price * quantity}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
