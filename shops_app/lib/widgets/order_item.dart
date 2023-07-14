import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as od;

class OrderItem extends StatefulWidget {
  const OrderItem(this.order, {super.key});
  final od.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.price}'),
            subtitle:
                Text(DateFormat('dd/MMM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon:
                  _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: widget.order.items
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
