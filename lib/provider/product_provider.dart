import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:grocery_payment/models/product.dart';

class ProductsController extends ChangeNotifier {
  List<Product> _productsInStock = [
    Product(
        name: 'Red Delicious Apple',
        picPath: 'assets/apple.png',
        price: '\$16.20',
        weight: '500g'),
    Product(
        name: 'Totapuri Mango',
        picPath: 'assets/mango.png',
        price: '\$11.55',
        weight: '700g'),
    Product(
        name: 'Manzano Banana',
        picPath: 'assets/banana.png',
        price: '\$9.90',
        weight: '500g'),
    Product(
        name: 'Broccoli',
        picPath: 'assets/broccoli.png',
        price: '\$6.99',
        weight: '1000g'),
    Product(
        name: 'Coca-Cola',
        picPath: 'assets/coke.png',
        price: '\$2.99',
        weight: '550g'),
    Product(
        name: 'Cereals',
        picPath: 'assets/cereals.png',
        price: '\$24.75',
        weight: '1000g'),
    Product(
        name: 'Organic Flour',
        picPath: 'assets/flour.png',
        price: '\$12.95',
        weight: '250g'),
    Product(
        name: 'Pure Milk',
        picPath: 'assets/milk.png',
        price: '\$17.25',
        weight: '500g'),
  ];

  List<Product> _shoppingCart = [];
  late VoidCallback onCheckOutCallback;

  void onCheckOut({required VoidCallback onCheckOutCallback}) {
    this.onCheckOutCallback = onCheckOutCallback;
  }

  UnmodifiableListView<Product> get productsInStock {
    return UnmodifiableListView(_productsInStock);
  }

  UnmodifiableListView<Product> get cart {
    return UnmodifiableListView(_shoppingCart);
  }

  void addProductToCart(int index, {int bulkOrder = 0}) {
    bool inCart = false;
    int indexInCard = 0;
    if (_shoppingCart.length != 0) {
      for (int i = 0; i < _shoppingCart.length; i++) {
        if (_shoppingCart[i].name == _productsInStock[index].name &&
            _shoppingCart[i].picPath == _productsInStock[index].picPath) {
          indexInCard = i;
          inCart = true;
          break;
        }
      }
    }
    if (inCart == false) {
      _shoppingCart.add(
        Product(
          name: _productsInStock[index].name,
          picPath: _productsInStock[index].picPath,
          price: _productsInStock[index].price,
          weight: _productsInStock[index].weight,
          orderedQuantity:
              _productsInStock[index].orderedQuantity + (bulkOrder - 1),
        ),
      );
      notifyListeners();
    } else {
      _shoppingCart[indexInCard].makeOrder(bulkOrder: bulkOrder);
      notifyListeners();
    }
  }

  double _totalCost = 0.00;

  void returnTotalCost() {
    if (_totalCost == 0) {
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost +=
            (double.parse(_shoppingCart[i].price.replaceAll('\$', '')) *
                _shoppingCart[i].orderedQuantity);
      }
      notifyListeners();
    } else {
      _totalCost = 0.0;
      for (int i = 0; i < _shoppingCart.length; i++) {
        _totalCost +=
            (double.parse(_shoppingCart[i].price.replaceAll('\$', '')) *
                _shoppingCart[i].orderedQuantity);
      }
      notifyListeners();
    }
  }

  void deleteFromCart(int index) {
    _shoppingCart.removeAt(index);
    notifyListeners();
  }

  double get totalCost {
    return double.parse(_totalCost.toStringAsExponential(3));
  }

  void clearCart() {
    _shoppingCart.clear();
    onCheckOutCallback();
    notifyListeners();
  }
}
