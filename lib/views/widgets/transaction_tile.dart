import 'package:flutter/material.dart';
import 'package:vein_pay_wallet/data/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final isTopUp = transaction.isTopUp;
    final amountColor = isTopUp ? Colors.greenAccent : Colors.white;
    final amountPrefix = isTopUp ? '+' : '-';
    final icon = isTopUp ? Icons.add_circle : Icons.receipt_long;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _formatDate(transaction.timestamp),
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Text(
          '₹${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Unknown date';
    }

    final indiaTime = dateTime.toUtc().add(
      const Duration(hours: 5, minutes: 30),
    );
    final hour = indiaTime.hour % 12 == 0 ? 12 : indiaTime.hour % 12;
    final minute = indiaTime.minute.toString().padLeft(2, '0');
    final suffix = indiaTime.hour >= 12 ? 'PM' : 'AM';
    final month = _monthNames[indiaTime.month - 1];
    return '${indiaTime.day} $month, $hour:$minute $suffix';
  }

  static const List<String> _monthNames = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}
