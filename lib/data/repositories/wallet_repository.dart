import 'package:vein_pay_wallet/data/models/transaction_model.dart';
import 'package:vein_pay_wallet/data/models/wallet_model.dart';
import 'package:vein_pay_wallet/data/services/wallet_api_service.dart';

class WalletRepository {
  WalletRepository(this._walletApiService);

  final WalletApiService _walletApiService;

  Future<WalletModel> getWallet() => _walletApiService.getWallet();

  Future<WalletModel> addMoney(double amount) =>
      _walletApiService.addMoney(amount);

  Future<List<TransactionModel>> getTransactions() {
    return _walletApiService.getTransactions();
  }
}
