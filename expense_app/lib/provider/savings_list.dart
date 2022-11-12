import 'dart:convert';

import 'package:expense_app/models/saving.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SavingList extends ChangeNotifier {
  List<Saving> _savings = [];
  List<Saving> get savings => _savings;

  Future<void> addSaving({
    required double amount,
    required String date,
  }) async {
    var url = Uri.https(
        'expense-tracker-9be0b-default-rtdb.firebaseio.com', '/savings.json');
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
      print("json.decode(value.body)['name']");
      _savings.add(
        Saving(
          id: json.decode(value.body)['name'],
          amount: amount,
          date: date,
        ),
      );
      notifyListeners();
    });
  }
}
