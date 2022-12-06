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
      padding: const EdgeInsets.only(left: 35, top: 20, right: 35),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: GestureDetector(
          onTap: () {
            print("GridIndex: ${widget.index}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => SingleExpenseScreen(
                  index: widget.index,
                  categoryId: categories[widget.index].id,
                ),
              ),
            );
          },
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfsOHXhuTglJ9IGSygRRa8IQCcf7clftNy1Q&usqp=CAU",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        // color to rgba(84,83,79,255)
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '${categories[widget.index].name}',
                                  //investments[index].title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '\$${categories[widget.index].budget}',
                                  //investments[index].title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // delete button
                          IconButton(
                            onPressed: () {
                              showDeleteDialog(context, categoriesProvider);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 35),
                            child: IconButton(
                              onPressed: () {
                                namecontroller.text =
                                    categories[widget.index].name;
                                budgetcontroller.text =
                                    categories[widget.index].budget.toString();
                                bottomSheetCategories(context);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: Text(
                "Edit Category",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(
                        0xff4B57A3,
                      ),
                    ),
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
