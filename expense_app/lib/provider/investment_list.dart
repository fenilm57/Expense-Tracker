import 'dart:convert';

import 'package:expense_app/models/invesment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InvestmentList extends ChangeNotifier {
  List<Invesment> _invesment = [];
  List<Invesment> get investments => _invesment;

  double addingSum() {
    double sum = 0;
    investments.forEach((element) {
      sum += element.amount;
    });
    notifyListeners();
    return sum;
  }

  Future<void> fetchandSetData(String title) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/investment/$title.json', {
      "orderBy": "\"creatorId\"",
      "equalTo": "\"$userId\"",
    });

    print(userId);

    final response = await http.get(url);
    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Invesment> loadedSavings = [];

      print('Name: ${extractedData}');

      extractedData.forEach((id, expenseValue) {
        //print("Name : ${extractedData[id]['amount']}");
        loadedSavings.add(
          Invesment(
            id: id,
            amount: expenseValue['amount'],
            date: expenseValue['date'],
          ),
        );
      });
      _invesment = loadedSavings;
      notifyListeners();
    } catch (e) {
      print(e);
      _invesment = [];
      notifyListeners();
    }
  }

  Future<void> addInvestment({
    required double amount,
    required String date,
    required String title,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/investment/$title.json');
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

  Future<void> updateInvestment({
    required String title,
    required String id,
    required double amount,
    required String date,
  }) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/investment/$title/$id.json');

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

  Future<void> removeInvestment(int index, String id, String title) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/investment/$title/$id.json');
    await http.delete(url).then((value) async {
      await fetchandSetData(title);
    });
    notifyListeners();
  }
}
