import 'package:expense_app/screens/SingleExpense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/categories_list.dart';
import 'CustomElevatedButton.dart';
import 'CustomTextField.dart';

class CustomGridView extends StatefulWidget {
  final int index;
  const CustomGridView({
    super.key,
    required this.index,
  });

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController budgetcontroller = TextEditingController();
  bool impNote = false;
  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<CatagoriesList>(context, listen: false).categories;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleExpenseScreen(index: widget.index)),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTile(
            footer: GridTileBar(
              leading: GestureDetector(
                child: const Icon(Icons.edit, size: 30),
                onTap: () {
                  bottomSheetCategories(context);
                },
              ),
              title: const SizedBox(
                width: 50,
              ),
              trailing: GestureDetector(
                child: const Icon(Icons.delete, size: 30),
                onTap: () {},
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple, Colors.blue],
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
                    categories[widget.index].budget.toString(),
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
