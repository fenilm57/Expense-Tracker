import 'package:expense_app/screens/SavingScreen.dart';
import 'package:flutter/material.dart';

import '../models/saving_category.dart';

class SavingsCategory extends StatelessWidget {
  SavingsCategory({super.key});

  List<SavingCategory> categories = [
    SavingCategory(
      image: 'assets/images/housing.jpeg',
      title: 'Housing',
    ),
    SavingCategory(
      image: 'assets/images/car.png',
      title: 'Vehicle',
    ),
    SavingCategory(
      image: 'assets/images/travelling.jpeg',
      title: 'Travelling',
    ),
    SavingCategory(
      image: 'assets/images/investment.jpeg',
      title: 'Investment',
    ),
    SavingCategory(
      image: 'assets/images/emegency.jpeg',
      title: 'Emergency',
    ),
    SavingCategory(
      image: 'assets/images/others.jpeg',
      title: 'Others',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Savings',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisExtent: 210,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => SavingScreen(
                        saving: categories[index],
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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                categories[index].image,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 160),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                // color to rgba(84,83,79,255)
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  categories[index].title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
