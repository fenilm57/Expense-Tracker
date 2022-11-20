import 'package:expense_app/models/investment_category.dart';
import 'package:expense_app/screens/InvestmentScreen.dart';
import 'package:flutter/material.dart';

class InvestmentCategory extends StatelessWidget {
  InvestmentCategory({super.key});

  List<InvesmentCategoryList> investments = [
    InvesmentCategoryList(
      image: 'assets/images/fixeddeposit.png',
      title: 'FD',
    ),
    InvesmentCategoryList(
      image: 'assets/images/gold_investment.png',
      title: 'Gold',
    ),
    InvesmentCategoryList(
      image: 'assets/images/house_investment.png',
      title: 'Housing',
    ),
    InvesmentCategoryList(
      image: 'assets/images/mutual_investment.png',
      title: 'Bonds',
    ),
    InvesmentCategoryList(
      image: 'assets/images/stock_investment.png',
      title: 'Stocks',
    ),
    InvesmentCategoryList(
      image: 'assets/images/other.png',
      title: 'Others',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
      ),
      body: GridView.builder(
        itemCount: investments.length,
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
                    builder: (ctx) => InvestmentScreen(
                      title: investments[index].title,
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
                          investments[index].image,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                    ),
                    child: Center(
                      child: Text(
                        investments[index].title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
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
