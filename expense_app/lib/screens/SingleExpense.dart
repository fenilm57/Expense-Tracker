import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/categories_list.dart';

class SingleExpenseScreen extends StatefulWidget {
  final int index;
  const SingleExpenseScreen({super.key, required this.index});

  @override
  State<SingleExpenseScreen> createState() => _SingleExpenseScreenState();
}

class _SingleExpenseScreenState extends State<SingleExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<CatagoriesList>(context, listen: false).categories;
    return Scaffold(
      appBar: AppBar(
        title: Text(categories[widget.index].name.toUpperCase()),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
