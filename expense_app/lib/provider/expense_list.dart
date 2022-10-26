import 'dart:io';

import 'package:expense_app/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpenseList extends ChangeNotifier {
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  Future<void> addExpense({
    required String cateroryId,
    required String name,
    required String date,
    required double spent,
    required File image,
  }) {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories/$cateroryId/expenses.json');

    return http
        .post(url,
            body: json.encode({
              'expenseName': name,
              'date': date,
              'spent': spent,
            }))
        .then((value) {
      _expenses.add(
        Expense(
          id: json.decode(value.body)['name'],
          name: name,
          spent: spent,
          date: date,
          image: image,
        ),
      );
      notifyListeners();
    });
  }

  void removeExpense(int index) async {
    var id = _expenses[index].id;
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories/$id.json');
    await http.delete(url);
    _expenses.removeAt(index);
    notifyListeners();
  }

  void updateExpense({
    required String id,
    required String name,
    required double spent,
    required String date,
    required File image,
    required int index,
  }) {
    _expenses[index] =
        Expense(id: id, name: name, spent: spent, date: date, image: image);
    notifyListeners();
  }
}
