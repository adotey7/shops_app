import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  NewTextButton(cartData: cartData, order: order)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return CartItem(
                id: cartData.items.values.toList()[index].id,
                productId: cartData.items.keys.toList()[index],
                title: cartData.items.values.toList()[index].title,
                price: cartData.items.values.toList()[index].price,
                quantity: cartData.items.values.toList()[index].quantity,
              );
            },
            itemCount: cartData.itemCount,
          ))
        ],
      ),
    );
  }
}

class NewTextButton extends StatefulWidget {
  const NewTextButton({
    super.key,
    required this.cartData,
    required this.order,
  });

  final Cart cartData;
  final Orders order;

  @override
  State<NewTextButton> createState() => _NewTextButtonState();
}

class _NewTextButtonState extends State<NewTextButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartData.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.order.addOrders(
                  widget.cartData.items.values.toList(),
                  widget.cartData.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cartData.clear();
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('ORDER NOW'),
    );
  }
}
