import 'dart:io';
import 'dart:ui';
import 'package:expense_app/models/expense.dart';
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
  final String categoryId;
  const SingleExpenseScreen(
      {super.key, required this.index, required this.categoryId});

  @override
  State<SingleExpenseScreen> createState() => _SingleExpenseScreenState();
}

class _SingleExpenseScreenState extends State<SingleExpenseScreen> {
  bool searchData = false;
  bool isLoading = false;
  double total = 0;
  var focusNode = FocusNode();

  List<Expense> expenses = [];

  @override
  dispose() {
    focusNode.dispose();
    super.dispose();
  }

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
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<ExpenseList>(context, listen: false)
        .fetchandSetData(widget.categoryId)
        .onError((error, stackTrace) => null)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      expenses = Provider.of<ExpenseList>(context, listen: false).expenses;
    });
  }

  Future<void> refreshPage(BuildContext context) async {
    await Provider.of<ExpenseList>(context, listen: false)
        .fetchandSetData(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<CatagoriesList>(context, listen: false).categories;
    final provider = Provider.of<ExpenseList>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: searchData
            ? TextField(
                focusNode: focusNode,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                onChanged: searchExpense,
              )
            : Text(categories[widget.index].name.toUpperCase()),
        centerTitle: true,
        actions: [
          //search icon
          IconButton(
            onPressed: () {
              setState(() {
                searchData = true;
                FocusScope.of(context).requestFocus(focusNode);
              });
            },
            icon: const Icon(Icons.search),
          ),
          searchData
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchData = false;
                      FocusScope.of(context).requestFocus(focusNode);
                    });
                  },
                  icon: const Icon(Icons.cancel),
                )
              : PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Total: ${await Provider.of<CatagoriesList>(context, listen: false).spentReturn(widget.index)} spent so far..",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text("Total"),
                      ),
                    ),
                  ],
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpense(
                  categoryId: widget.categoryId, index: widget.index),
            ),
          ).then((value) => setState(() {
                Provider.of<ExpenseList>(context, listen: false)
                    .fetchandSetData(widget.categoryId)
                    .onError((error, stackTrace) => null)
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  expenses =
                      Provider.of<ExpenseList>(context, listen: false).expenses;
                });
              }));
        },
        child: const Icon(Icons.add),
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
              child: provider.expenses.length == 0
                  ? const Center(
                      child: Text(
                        'No Expense Yet',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        searchData = false;
                      },
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          searchData = false;
                        },
                        child: Column(
                          children: [
                            stackImageWithTitle(context, expenses),
                            Expanded(
                              child: ListView.builder(
                                itemCount: expenses.length,
                                itemBuilder: ((context, index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              //
                                            },
                                            child: ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              tileColor:
                                                  const Color(0xffa7a6a2),
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: ((context) =>
                                                            BigImage(
                                                                index: index)),
                                                      ),
                                                    );
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            expenses[index]
                                                                .image),
                                                    radius: 30,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                "${expenses[index].name}",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff4B57A3),
                                                ),
                                              ),
                                              subtitle: Text(
                                                "${expenses[index].date}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xff4B57A3),
                                                ),
                                              ),
                                              //  trailing with row of 2 buttons

                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Colors.green[400],
                                                    child: FittedBox(
                                                      child: Text(
                                                        '${expenses[index].spent}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // popup menu button for edit and delete
                                                  PopupMenuButton(
                                                    icon: const Icon(
                                                        Icons.more_vert),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        EditExpense(
                                                                  categoryIndex:
                                                                      widget
                                                                          .index,
                                                                  index: index,
                                                                  expenses:
                                                                      expenses,
                                                                  categoryId: widget
                                                                      .categoryId,
                                                                ),
                                                              ),
                                                            ).then(
                                                                (value) =>
                                                                    setState(
                                                                        () {
                                                                      Provider.of<ExpenseList>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .fetchandSetData(widget
                                                                              .categoryId)
                                                                          .onError((error, stackTrace) =>
                                                                              null)
                                                                          .then(
                                                                              (value) {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              false;
                                                                        });
                                                                        expenses =
                                                                            Provider.of<ExpenseList>(context, listen: false).expenses;
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    }));
                                                          },
                                                          child: const Text(
                                                              "Edit"),
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        child: TextButton(
                                                          onPressed: () async {
                                                            await showDeleteDialog(
                                                                context,
                                                                () async {
                                                              final categoriesProvider =
                                                                  Provider.of<
                                                                          CatagoriesList>(
                                                                      context,
                                                                      listen:
                                                                          false);

                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              await provider
                                                                  .removeExpense(
                                                                      index,
                                                                      widget
                                                                          .categoryId,
                                                                      expenses[
                                                                              index]
                                                                          .id)
                                                                  .then(
                                                                      (value) async {
                                                                await provider
                                                                    .sum(
                                                                  id: widget
                                                                      .categoryId,
                                                                  budget: categoriesProvider
                                                                      .categories[
                                                                          widget
                                                                              .index]
                                                                      .budget,
                                                                  imp: categoriesProvider
                                                                      .categories[
                                                                          widget
                                                                              .index]
                                                                      .impCategory,
                                                                  index: widget
                                                                      .index,
                                                                  name: categoriesProvider
                                                                      .categories[
                                                                          widget
                                                                              .index]
                                                                      .name,
                                                                );
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                              });
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Delete"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
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
                    ),
            ),
    );
  }

  Stack stackImageWithTitle(BuildContext context, List<Expense> expenses) {
    TextEditingController controller = TextEditingController();
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/travelling.jpeg',
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
                Provider.of<CatagoriesList>(context)
                    .categories[widget.index]
                    .name,
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

  void searchExpense(String value) {
    expenses = Provider.of<ExpenseList>(context, listen: false).expenses;

    final suggestion = expenses
        .where((element) => element.name.toLowerCase().contains(value))
        .toList();
    setState(() {
      expenses = suggestion;
    });
    // when backspace is pressed
  }
}

class AddExpense extends StatefulWidget {
  final String categoryId;
  final int index;
  const AddExpense({super.key, required this.categoryId, required this.index});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController spentcontroller = TextEditingController();
  bool isLoading = false;
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
      body: isLoading
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
          : SingleChildScrollView(
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
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    text: 'Add Expense',
                    onPressed: (namecontroller.value.text.isNotEmpty &&
                            spentcontroller.value.text.isNotEmpty)
                        ? () async {
                            final categoriesProvider =
                                Provider.of<CatagoriesList>(context,
                                    listen: false);

                            image ??= File("assets/images/emergency.jpeg");
                            // Add expense
                            setState(() {
                              isLoading = true;
                            });
                            print("Adding Index: ${widget.index}");
                            await provider
                                .addExpense(
                                    cateroryId: widget.categoryId,
                                    name: namecontroller.text,
                                    date: date,
                                    spent: double.parse(spentcontroller.text),
                                    image: image!)
                                .then((value) async {
                              await provider.sum(
                                id: widget.categoryId,
                                budget: categoriesProvider
                                    .categories[widget.index].budget,
                                imp: categoriesProvider
                                    .categories[widget.index].impCategory,
                                index: widget.index,
                                name: categoriesProvider
                                    .categories[widget.index].name,
                              );
                              setState(() {
                                isLoading = false;
                              });
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
        child: Image.network(
          expenses[index].image,
        ),
      ),
    ));
  }
}

class EditExpense extends StatefulWidget {
  final int index;
  final expenses;
  final int categoryIndex;
  final String categoryId;
  const EditExpense({
    super.key,
    required this.index,
    required this.expenses,
    required this.categoryId,
    required this.categoryIndex,
  });

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController spentcontroller = TextEditingController();
  bool isLoading = false;
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
                    onTap: () async {
                      await pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SelectPhoto(
                  textLabel: 'Gallery',
                  icon: Icons.image,
                  onTap: () async {
                    await pickImage(ImageSource.gallery);
                    Navigator.pop(context);
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
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //image = widget.expenses[widget.index].image;
    namecontroller.text = widget.expenses[widget.index].name;
    spentcontroller.text = widget.expenses[widget.index].spent.toString();
    date = widget.expenses[widget.index].date;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseList>(context, listen: false);

    return Scaffold(
      body: isLoading
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
          : SingleChildScrollView(
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
                    onTap: () async {
                      print(image?.path.length);
                      await showModalSheetForImagePicking(context)
                          .then((value) {
                        setState(() {});
                      });
                      print(image?.path.length);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: image?.path.length == null
                          ? CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                widget.expenses[widget.index].image,
                              ),
                            )
                          : CircleAvatar(
                              radius: 40,
                              backgroundImage: FileImage(
                                image!,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    text: 'Update Category',
                    onPressed: (namecontroller.value.text.isNotEmpty &&
                            spentcontroller.value.text.isNotEmpty)
                        ? () async {
                            image ??= File("assets/images/emergency.jpeg");

                            setState(() {
                              isLoading = true;
                            });
                            // Edit expense
                            final categoriesProvider =
                                Provider.of<CatagoriesList>(context,
                                    listen: false);
                            print("Cateory Index: ${widget.index}");
                            await provider
                                .updateExpense(
                              categoryId: widget.categoryId,
                              index: widget.index,
                              id: provider.expenses[widget.index].id,
                              name: namecontroller.text,
                              date: date,
                              spent: double.parse(spentcontroller.text),
                              image: image!,
                            )
                                .then((value) async {
                              // need index of category here in place of expense index
                              await provider.sum(
                                id: widget.categoryId,
                                budget: categoriesProvider
                                    .categories[widget.categoryIndex].budget,
                                imp: categoriesProvider
                                    .categories[widget.categoryIndex]
                                    .impCategory,
                                index: widget.index,
                                name: categoriesProvider
                                    .categories[widget.categoryIndex].name,
                              );
                              setState(() {
                                isLoading = false;
                              });
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
