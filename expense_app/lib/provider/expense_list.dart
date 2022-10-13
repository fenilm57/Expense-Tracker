import 'dart:io';

import 'package:expense_app/models/expense.dart';
import 'package:flutter/cupertino.dart';

class ExpenseList extends ChangeNotifier {
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  void addExpense({
    required String id,
    required String name,
    required String date,
    required double spent,
    required File image,
  }) {
    _expenses.add(
      Expense(
        id: id,
        name: name,
        spent: spent,
        date: date,
        image: image,
      ),
    );
    notifyListeners();
  }

  void removeExpense(int index) {
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
