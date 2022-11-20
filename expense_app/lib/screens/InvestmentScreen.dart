import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/investment_list.dart';
import '../widget/CustomElevatedButton.dart';
import '../widget/CustomTextField.dart';

class InvestmentScreen extends StatefulWidget {
  final String title;

  const InvestmentScreen({super.key, required this.title});

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<InvestmentList>(context, listen: false)
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
    await Provider.of<InvestmentList>(context, listen: false)
        .fetchandSetData(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final investments =
        Provider.of<InvestmentList>(context, listen: false).investments;
    final investmentProvider =
        Provider.of<InvestmentList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} (${investmentProvider.addingSum()})"),
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
            label: 'Add Investment',
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
                itemCount: investments.length,
                itemBuilder: ((context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.amber,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            "${investments[index].amount}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            investments[index].date,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  bottomSheetEditCategories(
                                    context,
                                    investments[index].amount.toString(),
                                    investments[index].date,
                                    index,
                                  );
                                },
                                child: const Icon(Icons.edit),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //
                                  showDeleteDialog(
                                    context,
                                    index,
                                    widget.title,
                                    investments[index].id,
                                  );
                                },
                                child: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
    );
  }

  Future<dynamic> showDeleteDialog(
      BuildContext context, int index, String title, String id) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text(
          "You want to delete this?",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("No"),
            ),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<InvestmentList>(context, listen: false)
                  .removeInvestment(index, id, title)
                  .then((value) {
                setState(() {});
              });
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("Yes"),
            ),
          ),
        ],
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

  Future<dynamic> bottomSheetEditCategories(
      BuildContext context, String text, String date, int index) {
    savingAmount.text = text;
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
                "Edit Investment",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: savingAmount,
                hintText: 'Investment Amount',
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
              text: 'Save Investment',
              onPressed: savingAmount.value.text.isNotEmpty
                  ? () {
                      Navigator.pop(context);
                      setState(() {
                        _isLoading = true;
                      });
                      Provider.of<InvestmentList>(context, listen: false)
                          .updateInvestment(
                              amount: double.parse(savingAmount.text),
                              date: date,
                              title: widget.title,
                              id: Provider.of<InvestmentList>(context,
                                      listen: false)
                                  .investments[index]
                                  .id)
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

  Future<dynamic> bottomSheetCategories(
    BuildContext context,
  ) {
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
                "Add Investment",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: savingAmount,
                hintText: 'Investment Amount',
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
              text: 'Add Investment',
              onPressed: savingAmount.value.text.isNotEmpty
                  ? () {
                      Navigator.pop(context);
                      setState(() {
                        _isLoading = true;
                      });
                      Provider.of<InvestmentList>(context, listen: false)
                          .addInvestment(
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
