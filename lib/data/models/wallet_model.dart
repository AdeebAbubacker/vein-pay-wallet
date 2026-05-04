class WalletModel {
  const WalletModel({
    required this.id,
    required this.ownerUsername,
    required this.balance,
    required this.updatedAt,
  });

  final int id;
  final String ownerUsername;
  final double balance;
  final DateTime? updatedAt;

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: _parseInt(json['id']),
      ownerUsername: json['owner_username']?.toString() ?? '',
      balance: _parseDouble(json['balance']),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
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
}
