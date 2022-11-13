import 'dart:convert';

import 'package:expense_app/models/saving.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SavingList extends ChangeNotifier {
  List<Saving> _savings = [];
  List<Saving> get savings => _savings;

  Future<void> fetchandSetData(String title) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/savings/$title.json');

    final response = await http.get(url);
    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Saving> loadedSavings = [];

      print('Name: ${extractedData}');

      extractedData.forEach((id, expenseValue) {
        //print("Name : ${extractedData[id]['amount']}");
        loadedSavings.add(
          Saving(
            id: id,
            amount: expenseValue['amount'],
            date: expenseValue['date'],
          ),
        );
      });
      _savings = loadedSavings;
      notifyListeners();
    } catch (e) {
      print(e);
      _savings = [];
      notifyListeners();
    }
  }

  Future<void> addSaving({
    required double amount,
    required String date,
    required String title,
  }) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/savings/$title.json');
    return http
        .post(
      url,
      body: json.encode(
        {
          'amount': amount,
          'date': date,
        },
      ),
    )
        .then((value) {
      fetchandSetData(title);
      notifyListeners();
    });
  }
}
