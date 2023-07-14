import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/cart.dart';

class OrderItem {
  OrderItem(
      {required this.id,
      required this.price,
      required this.items,
      required this.date});
  final String id;
  final double price;
  final List<CartItem> items;
  final DateTime date;
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchAnSetOrders() async {
    const url =
        'https://shop-app-ed024-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(Uri.parse(url));
    var loadedOrders = <OrderItem>[];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, value) {
      loadedOrders.add(
        OrderItem(
            id: orderId,
            price: value['total'],
            items: (value['products'] as List<dynamic>)
                .map(
                  (e) => CartItem(
                      id: e['id'],
                      title: e['title'],
                      quantity: e['quantity'],
                      price: e['price']),
                )
                .toList(),
            date: DateTime.parse(value['date'])),
      );
    });
    _items = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    const url =
        'https://shop-app-ed024-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'total': total,
          'date': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        },
      ),
    );

    _items.insert(
      0,
      OrderItem(
        id: jsonDecode(response.body)['name'],
        price: total,
        items: cartProducts,
        date: timestamp,
      ),
    );
    notifyListeners();
  }
}
