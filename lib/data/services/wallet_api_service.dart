import 'dart:convert';
import 'package:vein_pay_wallet/core/constants/api_constants.dart';
import 'package:vein_pay_wallet/core/network/api_client.dart';
import 'package:vein_pay_wallet/data/models/transaction_model.dart';
import 'package:vein_pay_wallet/data/models/wallet_model.dart';

class WalletApiService {
  WalletApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<WalletModel> getWallet() async {
    final response = await _apiClient.get(ApiConstants.wallet);
    return WalletModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }

  Future<WalletModel> addMoney(double amount) async {
    final response = await _apiClient.post(
      ApiConstants.addMoney,
      body: <String, dynamic>{'amount': amount},
    );

    return WalletModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final response = await _apiClient.get(ApiConstants.transactions);
    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map(
          (item) =>
              TransactionModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(growable: false);
  }
}
