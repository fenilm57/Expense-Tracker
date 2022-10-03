import 'dart:ffi';
import 'dart:ui';

import 'package:expense_app/provider/categories_list.dart';
import 'package:expense_app/widget/CustomElevatedButton.dart';
import 'package:expense_app/widget/CustomTextField.dart';
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
  bool impNote = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    final categoriesProvider =
        Provider.of<CatagoriesList>(context, listen: false);

    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text(
          'Expense App',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
          itemCount: categoriesProvider.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.amber,
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomSheetCategories(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> bottomSheetCategories(BuildContext context) {
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
                return Switch(
                  value: impNote,
                  onChanged: (val) {
                    stateSetter(() {
                      impNote = val;
                    });
                  },
                );
              },
            ),
            CustomElevatedButton(
              text: 'Add Category',
              onPressed: namecontroller.value.text.isNotEmpty
                  ? () {
                      double budget;
                      if (budgetcontroller.text == '') {
                        budget = 0;
                      } else {
                        budget = double.parse(budgetcontroller.text);
                      }
                      setState(() {
                        provider.addCategories(
                          name: namecontroller.text,
                          budget: budget,
                          imp: impNote,
                        );
                      });

                      namecontroller.clear();
                      budgetcontroller.clear();
                      Navigator.pop(context);
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}
