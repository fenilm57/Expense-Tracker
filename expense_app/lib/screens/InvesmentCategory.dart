import 'package:expense_app/models/investment_category.dart';
import 'package:expense_app/screens/InvestmentScreen.dart';
import 'package:flutter/material.dart';

class InvestmentCategory extends StatelessWidget {
  InvestmentCategory({super.key});

  List<InvesmentCategoryList> investments = [
    InvesmentCategoryList(
      image: 'assets/images/fd.jpeg',
      title: 'FD',
    ),
    InvesmentCategoryList(
      image: 'assets/images/golds.jpeg',
      title: 'Gold',
    ),
    InvesmentCategoryList(
      image: 'assets/images/housing.jpeg',
      title: 'Housing',
    ),
    InvesmentCategoryList(
      image: 'assets/images/bonds.jpeg',
      title: 'Bonds',
    ),
    InvesmentCategoryList(
      image: 'assets/images/stocks.jpeg',
      title: 'Stocks',
    ),
    InvesmentCategoryList(
      image: 'assets/images/others.jpeg',
      title: 'Others',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Investments',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: GridView.builder(
          itemCount: investments.length,
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
                      builder: (ctx) => InvestmentScreen(
                        investment: investments[index],
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
                                investments[index].image,
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
                                  investments[index].title,
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
