import 'dart:ui';

import 'package:expense_app/screens/SingleExpense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/categories_list.dart';
import 'CustomElevatedButton.dart';
import 'CustomTextField.dart';

class CustomGridView extends StatefulWidget {
  final int index;
  final VoidCallback deleteCategory;
  const CustomGridView({
    super.key,
    required this.index,
    required this.deleteCategory,
  });

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController budgetcontroller = TextEditingController();
  bool impNote = false;
  void insertDataIntoController() {
    print(namecontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<CatagoriesList>(context, listen: false).categories;
    final categoriesProvider =
        Provider.of<CatagoriesList>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          //print(categories[widget.index].id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleExpenseScreen(
                index: widget.index,
                categoryId: categories[widget.index].id,
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTile(
            footer: GridTileBar(
              leading: GestureDetector(
                child: const Icon(Icons.edit, size: 30),
                onTap: () {
                  namecontroller.text = categories[widget.index].name;
                  budgetcontroller.text =
                      categories[widget.index].budget.toString();
                  bottomSheetCategories(context);
                },
              ),
              title: const SizedBox(
                width: 50,
              ),
              trailing: GestureDetector(
                child: const Icon(Icons.delete, size: 30),
                onTap: () {
                  showDeleteDialog(context, categoriesProvider);
                },
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple,
                    Colors.blue,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    categories[widget.index].name.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    " ${categories[widget.index].spent} / ${categories[widget.index].budget}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDeleteDialog(
      BuildContext context, CatagoriesList categoriesProvider) {
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
            onPressed: () {
              setState(() {
                widget.deleteCategory();
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
              text: 'Update Category',
              onPressed: namecontroller.value.text.isNotEmpty
                  ? () async {
                      double budget;
                      if (budgetcontroller.text == '') {
                        budget = 0;
                      } else {
                        budget = double.parse(budgetcontroller.text);
                      }

                      await provider
                          .updateCategories(
                        id: provider.categories[widget.index].id,
                        name: namecontroller.text,
                        budget: budget,
                        imp: impNote,
                        index: widget.index,
                        spent: provider.categories[widget.index].spent,
                      )
                          .then((value) {
                        setState(() {});
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
