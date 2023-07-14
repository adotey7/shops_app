import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    final newItems = [..._items];
    return List.unmodifiable(newItems);
  }

  List<Product> get favoritesOnly {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void toggleFavorites(Product product) {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  Future<void> fetchAnSetProducts() async {
    const url =
        'https://shop-app-ed024-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      final loadedProducts = <Product>[];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://shop-app-ed024-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
            'price': product.price,
          }));

      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    final url =
        'https://shop-app-ed024-default-rtdb.firebaseio.com/products/$id.json';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }));
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-ed024-default-rtdb.firebaseio.com/products/$id';

    // Optimistic deletion
    final prodIndex = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[prodIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    // delete from server
    final deleted = await http.delete(Uri.parse(url));
    if (deleted.statusCode >= 400) {
      _items.insert(prodIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
    existingProduct = null;
  }
}
