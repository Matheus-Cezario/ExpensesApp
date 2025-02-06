import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expenses_app/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onDelete;
  final void Function(int, int) onReorder;
  const TransactionList({
    super.key,
    required this.transactions,
    required this.onDelete,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: transactions.isEmpty
          ? const EmptyList()
          : Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: ReorderableListView.builder(
                itemCount: transactions.length,
                itemBuilder: (ctx, index) {
                  final tr = transactions[index];
                  return ListItem(
                    tr: tr,
                    onDelete: onDelete,
                    key: ValueKey(tr.id),
                  );
                },
                onReorder: onReorder,
              ),
            ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.tr, required this.onDelete});

  final Transaction tr;
  final void Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                'R\$ ${tr.value.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
        title: Text(
          tr.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          tr.formatedDate,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: MediaQuery.of(context).size.width > 500
            ? TextButton.icon(
                onPressed: () => onDelete(tr.id),
                label: Text('Excluir'),
                icon: Icon(Icons.delete),
                style: ButtonStyle(
                  iconColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.error,
                  ),
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              )
            : IconButton(
                onPressed: () => onDelete(tr.id),
                icon: Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
              ),
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                'Nenhuma transação cadastrada!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover,
                color: Theme.of(context).colorScheme.primary,
                opacity: AlwaysStoppedAnimation(0.3),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
