import 'dart:convert';

import 'package:expense_app/models/saving.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SavingList extends ChangeNotifier {
  List<Saving> _savings = [];
  List<Saving> get savings => _savings;

  double addingSum() {
    double sum = 0;
    savings.forEach((element) {
      sum += element.amount;
    });
    notifyListeners();
    return sum;
  }

  Future<void> fetchandSetData(String title) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/savings/$title.json', {
      "orderBy": "\"creatorId\"",
      "equalTo": "\"$userId\"",
    });

    print(userId);

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
    final userId = FirebaseAuth.instance.currentUser?.uid;
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/savings/$title.json');
    return http
        .post(
      url,
      body: json.encode(
        {
          'amount': amount,
          'date': date,
          'creatorId': userId,
        },
      ),
    )
        .then((value) async {
      await fetchandSetData(title);
      notifyListeners();
    });
  }

  Future<void> updateSavings({
    required String title,
    required String id,
    required double amount,
    required String date,
  }) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/savings/$title/$id.json');

    await http
        .patch(
      url,
      body: json.encode(
        {
          'amount': amount,
          'date': date,
        },
      ),
    )
        .then((value) async {
      await fetchandSetData(title);
    });

    notifyListeners();
  }

  Future<void> removeSaving(int index, String id, String title) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/savings/$title/$id.json');
    await http.delete(url).then((value) async {
      await fetchandSetData(title);
    });
    notifyListeners();
  }
}
