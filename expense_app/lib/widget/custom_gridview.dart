import 'package:expense_app/screens/SingleExpense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/categories_list.dart';

class CustomGridView extends StatelessWidget {
  final int index;
  const CustomGridView({
    super.key,
    required this.index,
  });

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
                builder: (context) => SingleExpenseScreen(index: index)),
          );
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.blue],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  categories[index].name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  categories[index].budget.toString(),
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
    );
  }
}
