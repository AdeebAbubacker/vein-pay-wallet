import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vein_pay_wallet/core/network/api_exception.dart';
import 'package:vein_pay_wallet/data/models/transaction_model.dart';
import 'package:vein_pay_wallet/data/repositories/wallet_repository.dart';

enum TransactionStatus { initial, loading, success, error }

class TransactionState {
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const <TransactionModel>[],
    this.errorMessage,
  });

  final TransactionStatus status;
  final List<TransactionModel> transactions;
  final String? errorMessage;

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionModel>? transactions,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class TransactionViewModel extends Cubit<TransactionState> {
  TransactionViewModel(this._walletRepository)
    : super(const TransactionState());

  final WalletRepository _walletRepository;

  Future<void> loadTransactions({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        (state.status == TransactionStatus.loading ||
            state.transactions.isNotEmpty)) {
      return;
    }

    emit(
      state.copyWith(
        status: TransactionStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final transactions = await _walletRepository.getTransactions();
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: transactions,
          clearErrorMessage: true,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: 'Unable to load your transactions right now.',
        ),
      );
    }
  }
}
