class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.amount,
    required this.timestamp,
    this.bill,
    this.sourceWallet,
    this.destinationWallet,
  });

  final int id;
  final double amount;
  final DateTime? timestamp;
  final int? bill;
  final int? sourceWallet;
  final int? destinationWallet;

  bool get isTopUp => sourceWallet == null;

  String get title {
    if (isTopUp) {
      return 'Wallet Top-up';
    }
    if (bill != null) {
      return 'Bill #$bill';
    }
    return 'Transaction #$id';
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: _parseInt(json['id']),
      amount: _parseDouble(json['amount']),
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? ''),
      bill: _parseNullableInt(json['bill']),
      sourceWallet: _parseNullableInt(json['source_wallet']),
      destinationWallet: _parseNullableInt(json['destination_wallet']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    return _parseInt(value);
  }
}
