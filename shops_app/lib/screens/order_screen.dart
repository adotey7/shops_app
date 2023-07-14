import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';
import '../widgets/drawer.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = '/order-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _setProducts;
  @override
  void initState() {
    _setProducts =
        Provider.of<Orders>(context, listen: false).fetchAnSetOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    print('rebuilding');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders '),
        ),
        drawer: const MyDrawer(),
        body: FutureBuilder(
          future: _setProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong...'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                    itemBuilder: (context, index) {
                      return OrderItem(orderData.items[index]);
                    },
                    itemCount: orderData.items.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
