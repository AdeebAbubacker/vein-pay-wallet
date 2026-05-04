import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vein_pay_wallet/viewmodels/transaction_viewmodel.dart';
import 'package:vein_pay_wallet/viewmodels/wallet_viewmodel.dart';
import 'package:vein_pay_wallet/views/home/add_money_screen.dart';
import 'package:vein_pay_wallet/views/widgets/transaction_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletViewModel>().loadWallet();
      context.read<TransactionViewModel>().loadTransactions();
    });
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<WalletViewModel>().loadWallet(forceRefresh: true),
      context.read<TransactionViewModel>().loadTransactions(forceRefresh: true),
    ]);
  }

  Future<void> _openAddMoney() async {
    final addedMoney = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<WalletViewModel>(),
          child: const AddMoneyScreen(),
        ),
      ),
    );

    if (!mounted || addedMoney != true) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Wallet updated successfully.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vein-PAY')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BlocBuilder<WalletViewModel, WalletState>(
              builder: (context, state) {
                return _BalanceCard(state: state);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _openAddMoney,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Money'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<TransactionViewModel, TransactionState>(
              builder: (context, state) {
                if (state.status == TransactionStatus.loading &&
                    state.transactions.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.status == TransactionStatus.error &&
                    state.transactions.isEmpty) {
                  return _SectionMessage(
                    message:
                        state.errorMessage ?? 'Unable to load transactions.',
                    actionLabel: 'Retry',
                    onPressed: () {
                      context.read<TransactionViewModel>().loadTransactions(
                        forceRefresh: true,
                      );
                    },
                  );
                }

                if (state.transactions.isEmpty) {
                  return const _SectionMessage(
                    message: 'No transactions found yet.',
                  );
                }

                final recentTransactions = state.transactions.take(5).toList();

                return Column(
                  children: recentTransactions
                      .map(
                        (transaction) =>
                            TransactionTile(transaction: transaction),
                      )
                      .toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.state});

  final WalletState state;

  @override
  Widget build(BuildContext context) {
    if (state.walletStatus == WalletRequestStatus.loading &&
        state.wallet == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (state.walletStatus == WalletRequestStatus.error &&
        state.wallet == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Unable to load wallet balance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(state.errorMessage ?? 'Please try again.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<WalletViewModel>().loadWallet(
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

    final wallet = state.wallet;
    final updatedAt = wallet?.updatedAt;
    final updatedText = updatedAt == null
        ? 'Balance available'
        : 'Updated ${_formatDate(updatedAt)}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Balance', style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 8),
            Text(
              '₹ ${(wallet?.balance ?? 0).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(updatedText, style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime dateTime) {
    final indiaTime = _toIndiaTime(dateTime);
    final hour = indiaTime.hour % 12 == 0 ? 12 : indiaTime.hour % 12;
    final minute = indiaTime.minute.toString().padLeft(2, '0');
    final suffix = indiaTime.hour >= 12 ? 'PM' : 'AM';
    final month = _monthNames[indiaTime.month - 1];
    return '$hour:$minute $suffix, $month ${indiaTime.day}';
  }

  static DateTime _toIndiaTime(DateTime dateTime) {
    return dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
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

class _SectionMessage extends StatelessWidget {
  const _SectionMessage({
    required this.message,
    this.actionLabel,
    this.onPressed,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null && onPressed != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onPressed, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
