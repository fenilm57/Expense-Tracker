import 'dart:io';

class Expense {
  final String id;
  final String name;
  final double spent;
  final String date;
  final String image;
  Expense({
    required this.id,
    required this.name,
    required this.spent,
    required this.date,
    required this.image,
  });
}
