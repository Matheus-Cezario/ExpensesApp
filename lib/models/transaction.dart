import 'package:intl/intl.dart';

class Transaction {
  final String id;
  final String title;
  final double value;
  final DateTime date;

  Transaction(
      {required this.id,
      required this.title,
      required this.value,
      required this.date});

  String get formatedDate {
    return DateFormat('dd MMM y').format(date);
  }
}
