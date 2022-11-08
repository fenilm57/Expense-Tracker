import 'dart:ffi';
import 'dart:ui';

import 'package:expense_app/provider/categories_list.dart';
import 'package:expense_app/screens/ChartScreen_two.dart';
import 'package:expense_app/widget/CustomElevatedButton.dart';
import 'package:expense_app/widget/CustomTextField.dart';
import 'package:expense_app/widget/custom_gridview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/google_signin.dart';
import '../widget/navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController budgetcontroller = TextEditingController();
  bool isLoading = false;
  bool impNote = false;
  final snackBar = const SnackBar(
    content: Text('Yay! A SnackBar!'),
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<CatagoriesList>(context, listen: false)
        .fetchandSetData()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> refreshPage(BuildContext context) async {
    await Provider.of<CatagoriesList>(context, listen: false).fetchandSetData();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context, dynamic categories) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });

    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      );
    } else if (_selectedIndex == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => ChartApp(
            index: index,
            categories: categories,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    final categoriesProvider =
        Provider.of<CatagoriesList>(context, listen: false);
    final dialogContext = context;

    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text(
          'Expense App',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(
          index,
          context,
          categoriesProvider,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'IMP Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Charts',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refreshPage(context).then((value) {
                  setState(() {});
                });
              },
              child: GridView.builder(
                  itemCount: categoriesProvider.categories.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    mainAxisExtent: 180,
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 10,
                      height: 10,
                      child: categoriesProvider.categories.isEmpty
                          ? const Center(
                              child: Text('No Expense Yet'),
                            )
                          : CustomGridView(
                              index: index,
                              deleteCategory: () {
                                setState(() {
                                  categoriesProvider.removeCategory(index);
                                });
                              }),
                    );
                  }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomSheetCategories(context, dialogContext);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> bottomSheetCategories(
      BuildContext context, BuildContext dialogContext) {
    final provider = Provider.of<CatagoriesList>(context, listen: false);
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
                controller: namecontroller,
                hintText: 'Category Name',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: budgetcontroller,
                hintText: 'Budget (Optional)',
                textInputType: TextInputType.number,
              ),
            ),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "IMP",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: impNote,
                      onChanged: (val) {
                        stateSetter(() {
                          impNote = val;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            CustomElevatedButton(
              text: 'Add Category',
              onPressed: namecontroller.value.text.isNotEmpty
                  ? () {
                      Navigator.pop(context);
                      setState(() {
                        isLoading = true;
                      });
                      double budget;
                      if (budgetcontroller.text == '') {
                        budget = 0;
                      } else {
                        budget = double.parse(budgetcontroller.text);
                      }
                      // Adding category
                      provider
                          .addCategories(
                        name: namecontroller.text,
                        budget: budget,
                        imp: impNote,
                      )
                          .catchError((error) {
                        showDialogError(dialogContext);
                      }).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        namecontroller.clear();
                        budgetcontroller.clear();
                      });
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showDialogError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(
                'Error!',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: const Text(
                'Something went wrong!',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'),
                )
              ],
            ));
  }
}
