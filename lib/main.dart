import 'dart:io';
import 'dart:math';

import 'package:expenses_app/components/chart.dart';
import 'package:expenses_app/components/transaction_form.dart';
import 'package:expenses_app/components/transaction_list.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  final _colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
  );
  ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Despesas Pessoais',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        colorScheme: _colorScheme,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: mediaQuery.textScaler.scale(14),
            color: Colors.grey,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: mediaQuery.textScaler.scale(16),
            color: _colorScheme.primary,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: mediaQuery.textScaler.scale(20),
            color: _colorScheme.primary,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: mediaQuery.textScaler.scale(24),
            color: _colorScheme.primary,
          ),
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: mediaQuery.textScaler.scale(22),
              fontWeight: FontWeight.bold,
              color: _colorScheme.primary,
            ),
            actionsIconTheme: IconThemeData(
              color: _colorScheme.primary,
            )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = true;

  void _addTransaction(String title, double value, DateTime selectedDate) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: selectedDate,
    );
    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TransactionForm(
            onSubmit: _addTransaction,
          ),
        );
      },
    );
  }

  List<Transaction> get _recentTransaction {
    return _transactions.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(
          Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    bool showJustOne =
        !kIsWeb && mediaQuery.orientation == Orientation.portrait;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Despesas Pessoais'),
        actions: [
          if (!showJustOne)
            IconButton(
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
              icon: Icon(
                !_showChart ? Icons.bar_chart_rounded : Icons.list_alt_rounded,
              ),
            ),
          IconButton(
            onPressed: () {
              _openTransactionFormModal(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showChart || showJustOne)
            Chart(
              recentTransactions: _recentTransaction,
            ),
          if (!_showChart || showJustOne)
            TransactionList(
              transactions: _transactions,
              onDelete: _deleteTransaction,
            ),
        ],
      ),
      floatingActionButton: !kIsWeb && Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () {
                _openTransactionFormModal(context);
              },
              child: Icon(
                Icons.add,
              ),
            )
          : null,
    );
  }
}
