import 'package:expense_app/models/saving.dart';
import 'package:expense_app/provider/savings_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/CustomElevatedButton.dart';
import '../widget/CustomTextField.dart';

class SavingScreen extends StatefulWidget {
  SavingScreen({super.key, required this.title});
  final String title;

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<SavingList>(context, listen: false)
        .fetchandSetData(widget.title)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(
    int index,
    BuildContext context,
  ) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  Future<void> refreshPage(BuildContext context) async {
    await Provider.of<SavingList>(context, listen: false)
        .fetchandSetData(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final savings = Provider.of<SavingList>(context, listen: false).savings;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              bottomSheetCategories(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(
          index,
          context,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Add Expense',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day_outlined),
            label: 'Calender',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refreshPage(context).then((value) {
                  setState(() {});
                });
              },
              child: ListView.builder(
                itemCount: savings.length,
                itemBuilder: ((context, index) => Container(
                      child: Center(
                        child: Text(
                          "Am: ${savings[index].amount.toString()}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )),
              ),
            ),
    );
  }

  // Adding Savings
  TextEditingController savingAmount = TextEditingController();
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

  Future<dynamic> bottomSheetCategories(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Add Category",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: savingAmount,
                hintText: 'Saving Amount',
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
              text: 'Add Saving',
              onPressed: savingAmount.value.text.isNotEmpty
                  ? () {
                      Navigator.pop(context);
                      setState(() {
                        _isLoading = true;
                      });
                      Provider.of<SavingList>(context, listen: false)
                          .addSaving(
                        amount: double.parse(savingAmount.text),
                        date: date,
                        title: widget.title,
                      )
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                      savingAmount.clear();
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}
