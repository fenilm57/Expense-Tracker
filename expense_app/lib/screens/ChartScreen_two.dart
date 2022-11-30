import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'home_screen.dart';

class ChartApp extends StatelessWidget {
  final int index;
  final categories;
  const ChartApp({super.key, required this.index, this.categories});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(
          color: Color(0xff4B57A3), //<-- SEE HERE
        ),
      ),
      home: _MyHomePage(index: index, categories: categories),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  final int index;
  final categories;

  const _MyHomePage({Key? key, required this.index, this.categories})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ExpenseData {
  final String name;
  final double budget;
  ExpenseData({
    required this.name,
    required this.budget,
  });
}

class _MyHomePageState extends State<_MyHomePage> {
  List<ExpenseData> _chartData = [];
  int _selectedIndex = 0;
  late TooltipBehavior _tool;

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.index;
    _tool = TooltipBehavior(enable: true);
    _chartData = getChartData();
    super.initState();
  }

  List<ExpenseData> getChartData() {
    final List<ExpenseData> chartData = [];

    widget.categories.categories.forEach((element) {
      chartData.add(ExpenseData(name: element.name, budget: element.spent));
    });

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Initialize the chart widget
          SfCircularChart(
            title: ChartTitle(
              text: 'The values are in CAD',
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              alignment: ChartAlignment.center,
            ),
            tooltipBehavior: _tool,
            series: <CircularSeries>[
              DoughnutSeries<ExpenseData, String>(
                dataSource: _chartData,
                xValueMapper: (ExpenseData expense, _) => expense.name,
                yValueMapper: (ExpenseData expense, _) => expense.budget,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enableTooltip: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
