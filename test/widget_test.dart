import 'package:flutter_test/flutter_test.dart';
import 'package:vein_pay_wallet/data/models/transaction_model.dart';
import 'package:vein_pay_wallet/data/models/wallet_model.dart';

void main() {
  test('wallet model parses string balance safely', () {
    final wallet = WalletModel.fromJson({
      'id': 9,
      'owner_username': 'user1',
      'balance': '250.00',
      'updated_at': '2026-05-04T10:32:56.690966+05:30',
    });

    expect(wallet.id, 9);
    expect(wallet.ownerUsername, 'user1');
    expect(wallet.balance, 250);
  });

  test('transaction model parses amount safely', () {
    final transaction = TransactionModel.fromJson({
      'id': 2,
      'amount': '20.00',
      'timestamp': '2026-05-03T22:23:14.742408+05:30',
      'bill': 2,
      'source_wallet': 9,
      'destination_wallet': 2,
    });

    expect(transaction.id, 2);
    expect(transaction.amount, 20);
    expect(transaction.title, 'Bill #2');
  });
}
