import 'package:expenses_app/components/chart_bar.dart';
import 'package:expenses_app/models/group_transaction_day.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart({super.key, required this.recentTransactions});

  List<GroupTransactionDay> get groupedTransactions {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(
        days: index,
      ));
      final totalSum = recentTransactions.fold(0.0, (acc, tr) {
        final dateFormat = DateFormat('y/M/d');
        if (dateFormat.format(weekday) == dateFormat.format(tr.date)) {
          return acc + tr.value;
        }
        return acc;
      });
      return GroupTransactionDay(
        day: DateFormat.E().format(weekday)[0],
        value: totalSum,
      );
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + tr.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactions.map((tr) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  label: tr.day,
                  value: tr.value,
                  percent: _weekTotalValue > 0 ? tr.value / _weekTotalValue : 0,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
