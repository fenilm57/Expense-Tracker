import 'package:expense_app/models/category.dart';
import 'package:flutter/material.dart';

class CatagoriesList extends ChangeNotifier {
  final List<Category> _categories = [];
  List<Category> get categories => _categories;

  void addCategories({
    required String id,
    required String name,
    double budget = 0.0,
    bool imp = false,
  }) {
    _categories
        .add(Category(id: id, name: name, budget: budget, impCategory: imp));
    notifyListeners();
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
