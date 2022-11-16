import 'dart:convert';

import 'package:expense_app/models/category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatagoriesList extends ChangeNotifier {
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> fetchandSetData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories.json', {
      "orderBy": "\"creatorId\"",
      "equalTo": "\"$userId\"",
    });

    final response = await http.get(url);
    print("object");
    print('Deocde: $userId');
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Category> loadedCategories = [];

    extractedData.forEach((id, categoryValue) {
      loadedCategories.add(
        Category(
          id: id,
          name: categoryValue['categoryName'],
          budget: categoryValue['budget'],
          impCategory: categoryValue['impCategory'],
          spent: categoryValue['spent'],
        ),
      );
    });
    _categories = loadedCategories;
    notifyListeners();
  }

  Future<void> addCategories({
    required String name,
    double budget = 0.0,
    bool imp = false,
  }) {
    // Firebase Categories being created
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories.json');
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return http
        .post(
      url,
      body: json.encode(
        {
          'categoryName': name,
          'budget': budget,
          'impCategory': imp,
          'spent': 0,
          'creatorId': userId,
        },
      ),
    )
        .then((value) {
      print("json.decode(value.body)['name']");
      _categories.add(
        Category(
          id: json.decode(value.body)['name'],
          name: name,
          budget: budget,
          impCategory: imp,
          spent: 0,
        ),
      );
      notifyListeners();
    });
  }

  Future<void> removeCategory(int index) async {
    var id = _categories[index].id;
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories/$id.json');
    await http.delete(url);
    _categories.removeAt(index);
    notifyListeners();
  }

  Future<void> updateCategories({
    required String id,
    required String name,
    double budget = 0.0,
    bool imp = false,
    required int index,
    required double spent,
  }) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories/$id.json');
    print("ids $id");
    await http.patch(
      url,
      body: json.encode(
        {
          'categoryName': name,
          'budget': budget,
          'impCategory': imp,
          'spent': spent,
        },
      ),
    );
    _categories[index] = Category(
      id: id,
      name: name,
      budget: budget,
      impCategory: imp,
      spent: spent,
    );

    notifyListeners();
  }
}
