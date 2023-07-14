import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './http_exception.dart';

class Product with ChangeNotifier {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorites() async {
    var oldFavorites = isFavorite;
    final url =
        'https://shop-app-ed024-default-rtdb.firebaseio.com/products/$id.json';
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        _setFavValue(oldFavorites);
        throw HttpException('Couldn\'t add tp favorite');
      }
    } catch (e) {
      _setFavValue(oldFavorites);
      throw HttpException('Couldn\'t add tp favorite');
    }
  }
}
