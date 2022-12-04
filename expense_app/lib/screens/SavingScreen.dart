import 'package:expense_app/models/saving.dart';
import 'package:expense_app/provider/savings_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/CustomElevatedButton.dart';
import '../widget/CustomTextField.dart';

class SavingScreen extends StatefulWidget {
  const SavingScreen({super.key, required this.saving});
  final saving;

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
        .fetchandSetData(widget.saving.title)
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
        .fetchandSetData(widget.saving.title);
  }

  @override
  Widget build(BuildContext context) {
    final savings = Provider.of<SavingList>(context, listen: false).savings;
    final savingProvider = Provider.of<SavingList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.saving.title} (${savingProvider.addingSum()})"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await bottomSheetCategories(context).then((value) {
            setState(() {});
          });
          date = 'Select Date';
        },
        backgroundColor: Color(0xff4B57A3),
        child: const Icon(Icons.add),
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
              child: Column(
                children: [
                  stackImageWithTitle(context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: savings.length,
                      itemBuilder: ((context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                // list for displaying the investments along with edit and delete icon
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  tileColor: const Color(0xffa7a6a2),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Color(0xff4B57A3),
                                    child: FittedBox(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    savings[index].amount.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff4B57A3),
                                    ),
                                  ),
                                  subtitle: Text(
                                    savings[index].date,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff4B57A3),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          // edit investment
                                          print(date);

                                          await bottomSheetEditCategories(
                                            context,
                                            savings[index].amount.toString(),
                                            savings[index].date,
                                            index,
                                          ).then((value) {
                                            setState(() {});
                                          });
                                          print(date);
                                        },
                                        color: Colors.green,
                                        icon: const Icon(
                                          Icons.edit,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          print("In Dialog");
                                          await showDeleteDialog(
                                            context,
                                            index,
                                            widget.saving.title,
                                            savings[index].id,
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        color: Colors.red[900],
                                        icon: const Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
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
              await Provider.of<SavingList>(context, listen: false)
                  .removeSaving(index, id, title)
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
      BuildContext context, String text, String date2, int index) {
    savingAmount.text = text;
    String date1 = date2;
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // only topleft and topright
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Edit Expense",
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
                    selectDate(context).then((value) {
                      setState(() {
                        date1 = date;
                      });
                    });
                  });
                },
                child: Text(
                  date1,
                  style: const TextStyle(
                    color: Color(0xff4B57A3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomElevatedButton(
                text: 'Save Saving',
                onPressed: savingAmount.value.text.isNotEmpty
                    ? () {
                        setState(() {
                          _isLoading = true;
                        });
                        Provider.of<SavingList>(context, listen: false)
                            .updateSavings(
                                amount: double.parse(savingAmount.text),
                                date: date1,
                                title: widget.saving.title,
                                id: Provider.of<SavingList>(context,
                                        listen: false)
                                    .savings[index]
                                    .id)
                            .then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                        });
                        savingAmount.clear();
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> bottomSheetCategories(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // only topleft and topright
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add Expense",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xff4B57A3),
                      ),
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
                    selectDate(context).then((value) {
                      setState(() {});
                    });
                  });
                },
                child: Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xff4B57A3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomElevatedButton(
                text: 'Add Saving',
                onPressed: savingAmount.value.text.isNotEmpty
                    ? () {
                        setState(() {
                          _isLoading = true;
                        });
                        Provider.of<SavingList>(context, listen: false)
                            .addSaving(
                          amount: double.parse(savingAmount.text),
                          date: date,
                          title: widget.saving.title,
                        )
                            .then((value) {
                          setState(() {
                            _isLoading = false;
                            Navigator.pop(context);
                          });
                        });
                        savingAmount.clear();
                        date = 'Select Date';
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Stack stackImageWithTitle(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                widget.saving.image,
              ),
            ),
          ),
        ),
        // stack for text
        Positioned(
          top: 50,
          left: 10,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                widget.saving.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
