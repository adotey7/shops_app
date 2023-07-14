import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _isInit = true;
  var _loadedProducts = <String, String>{};
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _loadedProducts = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) {
        setState(() {});
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final validated = _formKey.currentState?.validate() ?? false;
    if (!validated) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      // this means we're updating
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('An error has occurred!'),
                content: const Text('Something went wrong.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okay'),
                  )
                ],
              );
            });
      }
    }
    setState(() {
      _isLoading = false;
    });
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      initialValue: _loadedProducts['title'],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: newValue!,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      initialValue: _loadedProducts['price'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a valid number ';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            isFavorite: _editedProduct.isFavorite,
                            description: _editedProduct.description,
                            price: double.parse(newValue!),
                            imageUrl: _editedProduct.imageUrl);
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      initialValue: _loadedProducts['description'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        if (value.length < 10) {
                          return 'Please enter at least 10 characters';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            isFavorite: _editedProduct.isFavorite,
                            description: newValue!,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 20, right: 30),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              // if (!value.endsWith('.jpeg') &&
                              //     !value.endsWith('.png') &&
                              //     !value.endsWith('.jpg')) {
                              //   return 'Please provider a valid image';
                              // }
                              return null;
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  isFavorite: _editedProduct.isFavorite,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue!);
                            },
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
