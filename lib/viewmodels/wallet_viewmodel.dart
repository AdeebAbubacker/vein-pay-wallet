import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vein_pay_wallet/core/network/api_exception.dart';
import 'package:vein_pay_wallet/data/models/wallet_model.dart';
import 'package:vein_pay_wallet/data/repositories/wallet_repository.dart';

enum WalletRequestStatus { initial, loading, success, error }

class WalletState {
  const WalletState({
    this.walletStatus = WalletRequestStatus.initial,
    this.addMoneyStatus = WalletRequestStatus.initial,
    this.wallet,
    this.errorMessage,
    this.addMoneyMessage,
  });

  final WalletRequestStatus walletStatus;
  final WalletRequestStatus addMoneyStatus;
  final WalletModel? wallet;
  final String? errorMessage;
  final String? addMoneyMessage;

  WalletState copyWith({
    WalletRequestStatus? walletStatus,
    WalletRequestStatus? addMoneyStatus,
    WalletModel? wallet,
    String? errorMessage,
    String? addMoneyMessage,
    bool clearErrorMessage = false,
    bool clearAddMoneyMessage = false,
    bool preserveWallet = true,
  }) {
    return WalletState(
      walletStatus: walletStatus ?? this.walletStatus,
      addMoneyStatus: addMoneyStatus ?? this.addMoneyStatus,
      wallet: preserveWallet ? wallet ?? this.wallet : wallet,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      addMoneyMessage: clearAddMoneyMessage
          ? null
          : addMoneyMessage ?? this.addMoneyMessage,
    );
  }
}

class WalletViewModel extends Cubit<WalletState> {
  WalletViewModel(this._walletRepository) : super(const WalletState());

  final WalletRepository _walletRepository;

  Future<void> loadWallet({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        (state.walletStatus == WalletRequestStatus.loading ||
            state.wallet != null)) {
      return;
    }

    emit(
      state.copyWith(
        walletStatus: WalletRequestStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final wallet = await _walletRepository.getWallet();
      emit(
        state.copyWith(
          walletStatus: WalletRequestStatus.success,
          wallet: wallet,
          clearErrorMessage: true,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          walletStatus: WalletRequestStatus.error,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          walletStatus: WalletRequestStatus.error,
          errorMessage: 'Unable to load your wallet right now.',
        ),
      );
    }
  }

  Future<bool> addMoney(double amount) async {
    emit(
      state.copyWith(
        addMoneyStatus: WalletRequestStatus.loading,
        clearAddMoneyMessage: true,
      ),
    );

    try {
      await _walletRepository.addMoney(amount);
      final wallet = await _walletRepository.getWallet();
      emit(
        state.copyWith(
          walletStatus: WalletRequestStatus.success,
          addMoneyStatus: WalletRequestStatus.success,
          wallet: wallet,
          addMoneyMessage: 'Money added successfully.',
          clearErrorMessage: true,
        ),
      );
      return true;
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          addMoneyStatus: WalletRequestStatus.error,
          addMoneyMessage: error.message,
        ),
      );
      return false;
    } catch (_) {
      emit(
        state.copyWith(
          addMoneyStatus: WalletRequestStatus.error,
          addMoneyMessage: 'Unable to add money right now. Please try again.',
        ),
      );
      return false;
    }
  }

  void resetAddMoneyStatus() {
    emit(
      state.copyWith(
        addMoneyStatus: WalletRequestStatus.initial,
        clearAddMoneyMessage: true,
      ),
    );
  }
}
