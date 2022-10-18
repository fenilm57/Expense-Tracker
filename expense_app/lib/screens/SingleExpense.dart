import 'dart:io';
import 'package:expense_app/provider/expense_list.dart';
import 'package:expense_app/widget/select_image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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
  Future<dynamic> showDeleteDialog(BuildContext context, Function function) {
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
                function();
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

  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<CatagoriesList>(context, listen: false).categories;
    final expenses = Provider.of<ExpenseList>(context, listen: false).expenses;
    final provider = Provider.of<ExpenseList>(context, listen: false);

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
          return Container(
            padding: const EdgeInsets.all(8.0),
            height: 100,
            child: ListTile(
              tileColor: Colors.lightBlue,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => BigImage(index: index)),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(expenses[index].image),
                    radius: 40,
                  ),
                ),
              ),
              title: Text(
                expenses[index].name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                expenses[index].date,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Column(
                children: [
                  Text(
                    expenses[index].spent.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  GestureDetector(
                    child: const Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditExpense(
                            index: index,
                            expenses: expenses,
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                  ),
                  GestureDetector(
                    child: const Icon(Icons.delete),
                    onTap: () {
                      setState(() {
                        showDeleteDialog(context, () {
                          provider.removeExpense(index);
                        });
                      });
                    },
                  ),
                ],
              ),
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

  File? image;

  Future showModalSheetForImagePicking(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: SelectPhoto(
                    textLabel: 'Camera',
                    icon: Icons.camera,
                    onTap: () {
                      pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SelectPhoto(
                  textLabel: 'Gallery',
                  icon: Icons.image,
                  onTap: () {
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseList>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Text(
                "Add Expense",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: namecontroller,
                hintText: 'Expense Name',
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
            // Image will be here

            GestureDetector(
              onTap: () {
                print(image?.path.length);
                showModalSheetForImagePicking(context);
                print(image?.path.length);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: image?.path.length == null
                    ? const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green,
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(image!),
                      ),
              ),
            ),
            CustomElevatedButton(
              text: 'Add Expense',
              onPressed: (namecontroller.value.text.isNotEmpty &&
                      spentcontroller.value.text.isNotEmpty)
                  ? () {
                      print(image!.path.toString());
                      setState(() {
                        // Add expense
                        provider.addExpense(
                            id: 'id',
                            name: namecontroller.text,
                            date: date,
                            spent: double.parse(spentcontroller.text),
                            image: image!);
                      });
                      namecontroller.clear();
                      spentcontroller.clear();
                      Navigator.pop(context);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class BigImage extends StatelessWidget {
  final int index;
  const BigImage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseList>(context, listen: false).expenses;

    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: InteractiveViewer(
        panEnabled: false, // Set it to false
        boundaryMargin: EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2,
        child: Image.file(
          expenses[index].image,
        ),
      ),
    ));
  }
}

class EditExpense extends StatefulWidget {
  final int index;
  final expenses;
  const EditExpense({super.key, required this.index, required this.expenses});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
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

  File? image;

  Future showModalSheetForImagePicking(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: SelectPhoto(
                    textLabel: 'Camera',
                    icon: Icons.camera,
                    onTap: () {
                      pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SelectPhoto(
                  textLabel: 'Gallery',
                  icon: Icons.image,
                  onTap: () {
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image = widget.expenses[widget.index].image;
    namecontroller.text = widget.expenses[widget.index].name;
    spentcontroller.text = widget.expenses[widget.index].spent.toString();
    date = widget.expenses[widget.index].date;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseList>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Text(
                "Update Expense",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: namecontroller,
                hintText: 'Expense Name',
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
            // Image will be here

            GestureDetector(
              onTap: () {
                print(image?.path.length);
                showModalSheetForImagePicking(context);
                print(image?.path.length);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: image?.path.length == null
                    ? const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green,
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(image!),
                      ),
              ),
            ),
            CustomElevatedButton(
              text: 'Update Category',
              onPressed: (namecontroller.value.text.isNotEmpty &&
                      spentcontroller.value.text.isNotEmpty)
                  ? () {
                      print(image!.path.toString());
                      setState(() {
                        // Add expense
                        provider.updateExpense(
                          index: widget.index,
                          id: 'id',
                          name: namecontroller.text,
                          date: date,
                          spent: double.parse(spentcontroller.text),
                          image: image!,
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
      ),
    );
  }
}
