import 'package:expense_app/provider/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/categories_list.dart';
import '../widget/CustomElevatedButton.dart';
import '../widget/CustomTextField.dart';

class SingleExpenseScreen extends StatefulWidget {
  final int index;
  const SingleExpenseScreen({super.key, required this.index});

  @override
  State<SingleExpenseScreen> createState() => _SingleExpenseScreenState();
}

class _SingleExpenseScreenState extends State<SingleExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<CatagoriesList>(context, listen: false).categories;
    final expenses = Provider.of<ExpenseList>(context, listen: false).expenses;

    return Scaffold(
      appBar: AppBar(
        title: Text(categories[widget.index].name.toUpperCase()),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpense(),
            ),
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: 50,
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController namecontroller = TextEditingController();

  TextEditingController spentcontroller = TextEditingController();

  String date = 'Select Date';

  Future<void> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date = selectedDate.toString().replaceAll("00:00:00.000", "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseList>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Text(
              "Add Category",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: namecontroller,
              hintText: 'Category Name',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: spentcontroller,
              hintText: 'Money Spent',
              textInputType: TextInputType.number,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectDate(context);
              });
            },
            child: Text(date),
          ),
          CustomElevatedButton(
            text: 'Add Category',
            onPressed: (namecontroller.value.text.isNotEmpty &&
                    spentcontroller.value.text.isNotEmpty)
                ? () {
                    setState(() {
                      // Add expense
                      provider.addExpense(
                        id: 'id',
                        name: namecontroller.text,
                        date: date,
                        spent: double.parse(spentcontroller.text),
                      );
                    });
                    namecontroller.clear();
                    spentcontroller.clear();
                    Navigator.pop(context);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
