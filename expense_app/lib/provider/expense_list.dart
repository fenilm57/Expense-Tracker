import 'dart:convert';
import 'dart:io';
import 'package:expense_app/provider/categories_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:expense_app/models/expense.dart';

class ExpenseList extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  double calc = 0;
  Future<void> sum({
    required String id,
    required int index,
    required String name,
    required double budget,
    required bool imp,
  }) async {
    double total = 0;
    for (var element in _expenses) {
      total += element.spent;
    }
    calc = total;
    CatagoriesList catagoriesList = CatagoriesList();

    print("Inside Expense List");
    catagoriesList.updateCategories(
      spent: total,
      id: id,
      index: index,
      name: name,
      budget: budget,
      imp: imp,
      realUpdate: true,
    );

    notifyListeners();
  }

  Future<void> addExpense({
    required String cateroryId,
    required String name,
    required String date,
    required double spent,
    required File image,
  }) async {
    var uuid = const Uuid();
    String id = uuid.v1();
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories/$cateroryId/expenses.json');
    var imageUrl = '';

    if (image.path == "assets/images/emergency.jpeg") {
      imageUrl =
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';
    } else {
      imageUrl = await uploadImage(image, id);
    }

    await http
        .post(url,
            body: json.encode({
              'expenseName': name,
              'date': date,
              'spent': spent,
              'image': imageUrl,
            }))
        .then((value) async {
      _expenses.add(
        Expense(
          id: json.decode(value.body)['name'],
          name: name,
          spent: spent,
          date: date,
          image: imageUrl,
        ),
      );
      notifyListeners();
    });
  }

  Future<String> uploadImage(File image, String id) async {
    final _firebaseStorage = FirebaseStorage.instance;
    var file = File(image.path);

    if (image != null) {
      //Upload to Firebase
      var snapshot =
          await _firebaseStorage.ref().child('images/$id').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } else {
      print('No Image Path Received');
      return '';
    }
  }

  Future<void> removeExpense(
      int index, String categoryId, String expenseId) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories/$categoryId/expenses/$expenseId.json');
    if (expenses[index].image ==
        'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg') {
      await http.delete(url).then((value) {
        _expenses.removeAt(index);

        notifyListeners();
      });
    } else {
      await FirebaseStorage.instance.refFromURL(expenses[index].image).delete();
      await http.delete(url).then((value) {
        _expenses.removeAt(index);
        notifyListeners();
      });
    }
  }

  Future<void> updateExpense({
    required String categoryId,
    required String id,
    required String name,
    required double spent,
    required String date,
    required File image,
    required int index,
  }) async {
    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories/$categoryId/expenses/$id.json');

    var imageUrl = expenses[index].image;

    if ((imageUrl).isEmpty) {
      if (image.path == "assets/images/emergency.jpeg") {
        imageUrl =
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';
      } else {
        imageUrl = await uploadImage(image, id);
      }
    }

    await http.patch(
      url,
      body: json.encode(
        {
          'expenseName': name,
          'date': date,
          'spent': spent,
          'image': imageUrl,
        },
      ),
    );
    _expenses[index] =
        Expense(id: id, name: name, spent: spent, date: date, image: imageUrl);
    notifyListeners();
  }

  Future<void> fetchandSetData(String categoryId) async {
    calc = 0;

    var url = Uri.https('expense-tracker-9be0b-default-rtdb.firebaseio.com',
        '/categories/$categoryId.json');
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Expense> loadedExpenses = [];
    //print("Extract: ${extractedData['expenses']}");

    if (extractedData['expenses'] == null) {
      _expenses = [];
      notifyListeners();
    } else {
      extractedData['expenses'].forEach((id, expenseValue) {
        loadedExpenses.add(
          Expense(
            id: id,
            name: expenseValue['expenseName'],
            date: expenseValue['date'],
            spent: expenseValue['spent'],
            image: expenseValue['image'],
          ),
        );
      });
      _expenses = loadedExpenses;
      _expenses.forEach((element) {
        calc += element.spent;
      });
      notifyListeners();
    }
  }
}
