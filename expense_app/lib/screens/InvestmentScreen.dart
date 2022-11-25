import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/investment_list.dart';
import '../widget/CustomElevatedButton.dart';
import '../widget/CustomTextField.dart';

class InvestmentScreen extends StatefulWidget {
  final investment;

  const InvestmentScreen({super.key, required this.investment});

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
        .fetchandSetData(widget.investment.title)
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
        .fetchandSetData(widget.investment.title);
  }

  @override
  Widget build(BuildContext context) {
    final investments =
        Provider.of<InvestmentList>(context, listen: false).investments;
    final investmentProvider =
        Provider.of<InvestmentList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.investment.title} (${investmentProvider.addingSum()})"),
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
              child: Column(
                children: [
                  stackImageWithTitle(context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: investments.length,
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
                                    investments[index].amount.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff4B57A3),
                                    ),
                                  ),
                                  subtitle: Text(
                                    investments[index].date,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff4B57A3),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // edit investment
                                          bottomSheetEditCategories(
                                            context,
                                            investments[index]
                                                .amount
                                                .toString(),
                                            investments[index].date,
                                            index,
                                          );
                                        },
                                        color: Colors.green,
                                        icon: const Icon(
                                          Icons.edit,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          // edit investment
                                          print("In Dialog");
                                          showDeleteDialog(
                                            context,
                                            index,
                                            widget.investment.title,
                                            investments[index].id,
                                          );
                                        },
                                        color: Colors.red,
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
                widget.investment.image,
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
                widget.investment.title,
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
                Navigator.of(ctx).pop();
              });
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
                              title: widget.investment.title,
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
                        title: widget.investment.title,
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
