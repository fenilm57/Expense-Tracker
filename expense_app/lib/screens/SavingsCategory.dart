import 'package:expense_app/screens/SavingScreen.dart';
import 'package:flutter/material.dart';

import '../models/saving_category.dart';

class SavingsCategory extends StatelessWidget {
  SavingsCategory({super.key});

  List<SavingCategory> categories = [
    SavingCategory(
      image: 'assets/images/house.png',
      title: 'Housing',
    ),
    SavingCategory(
      image: 'assets/images/car.png',
      title: 'Vehicle',
    ),
    SavingCategory(
      image: 'assets/images/travelling.png',
      title: 'Travelling',
    ),
    SavingCategory(
      image: 'assets/images/investment.png',
      title: 'Investment',
    ),
    SavingCategory(
      image: 'assets/images/emergency.png',
      title: 'Emergency',
    ),
    SavingCategory(
      image: 'assets/images/other.png',
      title: 'Others',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'),
      ),
      body: GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisExtent: 150,
        ),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SavingScreen(
                      title: categories[index].title,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          categories[index].image,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                    ),
                    child: Text(
                      categories[index].title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
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
}
