import 'dart:convert';

import 'package:expense_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatagoriesList extends ChangeNotifier {
  final List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> addCategories({
    required String id,
    required String name,
    double budget = 0.0,
    bool imp = false,
  }) {
    // Firebase Categories being created
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories.json');
    return http
        .post(url,
            body: json.encode({
              'categoryName': name,
              'budget': budget,
              'impCategory': imp,
            }))
        .then((value) {
      print(json.decode(value.body)['name']);
      _categories.add(
        Category(
          id: json.decode(value.body)['name'],
          name: name,
          budget: budget,
          impCategory: imp,
        ),
      );
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void removeCategory(int index) {
    _categories.removeAt(index);
    notifyListeners();
  }

  void updateCategories({
    required String id,
    required String name,
    double budget = 0.0,
    bool imp = false,
    required int index,
  }) {
    _categories[index] =
        Category(id: id, name: name, budget: budget, impCategory: imp);

    notifyListeners();
  }
}
