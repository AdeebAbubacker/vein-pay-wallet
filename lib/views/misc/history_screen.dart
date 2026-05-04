import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vein_pay_wallet/viewmodels/transaction_viewmodel.dart';
import 'package:vein_pay_wallet/views/widgets/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionViewModel>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: BlocBuilder<TransactionViewModel, TransactionState>(
        builder: (context, state) {
          if (state.status == TransactionStatus.loading &&
              state.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TransactionStatus.error &&
              state.transactions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ??
                          'Unable to load transaction history.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TransactionViewModel>().loadTransactions(
                          forceRefresh: true,
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return context.read<TransactionViewModel>().loadTransactions(
                forceRefresh: true,
              );
            },
            child: state.transactions.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('No transactions found yet.')),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(
                        transaction: state.transactions[index],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
