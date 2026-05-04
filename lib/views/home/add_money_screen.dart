import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vein_pay_wallet/viewmodels/wallet_viewmodel.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletViewModel>().resetAddMoneyStatus();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<WalletViewModel>().addMoney(amount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletViewModel, WalletState>(
      listenWhen: (previous, current) =>
          previous.addMoneyStatus != current.addMoneyStatus,
      listener: (context, state) {
        if (state.addMoneyStatus == WalletRequestStatus.success) {
          Navigator.pop(context, true);
        } else if (state.addMoneyStatus == WalletRequestStatus.error &&
            state.addMoneyMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.addMoneyMessage!)));
        }
      },
      child: BlocBuilder<WalletViewModel, WalletState>(
        builder: (context, state) {
          final isLoading = state.addMoneyStatus == WalletRequestStatus.loading;

          return Scaffold(
            appBar: AppBar(title: const Text('Add Money')),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Enter Amount', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _amountController,
                      enabled: !isLoading,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        prefixText: '₹ ',
                        hintText: '0.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: const TextStyle(fontSize: 24),
                      validator: (value) {
                        final amount = double.tryParse(value?.trim() ?? '');
                        if (amount == null || amount <= 0) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Add to Wallet',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
