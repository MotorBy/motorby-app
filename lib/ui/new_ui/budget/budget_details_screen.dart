import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_details_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_snapshot.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_widgets.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_widgets.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/budget_tiles_view.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
import 'package:mobile_auto_drive/utils/currency.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:stacked/stacked.dart';

/// Opens the full budget view for the car at [budgetIndex]; resolves when the
/// user leaves it.
Future<void> openBudgetDetails(BuildContext context, {required int budgetIndex}) {
  return Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => BudgetDetailsScreen(budgetIndex: budgetIndex)),
  );
}

class BudgetDetailsScreen extends StatelessWidget {
  const BudgetDetailsScreen({super.key, required this.budgetIndex});

  final int budgetIndex;

  void _openUpdateSheet(BuildContext context, BudgetDetailsViewModel viewModel) {
    if (viewModel.budget == null) {
      FloatingSnackBar.show(context, 'Add a car to continue with budget activities', isError: true);
      return;
    }
    modalBottomSheetMenu(
      color: Colors.white,
      context: context,
      child: InfoDetailsView(
        infoType: InfoType.budgeting,
        currentIndex: budgetIndex,
        onBudgetAction: () {
          viewModel.load();
          FloatingSnackBar.show(context, 'Car budget successfully updated', isError: false);
        },
      ),
    );
  }

  /// The car's spending list, so fuel, servicing and repairs can be logged
  /// without leaving the budget.
  void _openSpending(BuildContext context, BudgetDetailsViewModel viewModel) {
    if (viewModel.budget == null) {
      FloatingSnackBar.show(context, 'Add a car to continue with budget activities', isError: true);
      return;
    }
    modalBottomSheetMenu(
      color: Colors.white,
      context: context,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Log spending', style: Brand.text(size: 18, weight: FontWeight.w700)),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(viewModel.carName, style: Brand.text(size: 13, color: Brand.muted)),
              ),
              const SizedBox(height: 8),
              BudgetTilesView(budgetCurrentIndex: budgetIndex, onUpdated: viewModel.load),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BudgetDetailsViewModel>.reactive(
      viewModelBuilder: () => BudgetDetailsViewModel(budgetIndex: budgetIndex),
      onViewModelReady: (model) => model.load(),
      builder: (context, viewModel, child) {
        final snapshot = viewModel.snapshot;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Budget',
          ),
          body: RefreshIndicator(
            color: Brand.purple,
            onRefresh: viewModel.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _OverviewCard(carName: viewModel.carName, snapshot: snapshot),
                if (viewModel.refreshError != null) ...[
                  const SizedBox(height: 12),
                  HomeNotice(message: viewModel.refreshError!),
                ],
                const HomeSectionHeader(title: 'Where your money went'),
                _BreakdownCard(snapshot: snapshot),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _openSpending(context, viewModel),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Brand.purple,
                        side: const BorderSide(color: Brand.lilac),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: Text('Log spending',
                          style: Brand.text(size: 12, weight: FontWeight.w600, color: Brand.purple)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () => _openUpdateSheet(context, viewModel),
                      style: FilledButton.styleFrom(
                        backgroundColor: Brand.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      label: Text(
                        snapshot.hasLimit ? 'Update budget' : 'Set a budget',
                        style: Brand.text(size: 12, weight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.carName, required this.snapshot});

  final String carName;
  final BudgetSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final status = snapshot.status;
    final color = budgetStatusColor(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: Brand.backdrop(),
        borderRadius: BorderRadius.circular(24),
        border: Brand.hairline,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(carName, style: Brand.text(size: 14, weight: FontWeight.w600, color: Brand.muted)),
          const SizedBox(height: 14),
          Text('Spent so far', style: Brand.text(size: 13, color: Brand.muted)),
          const SizedBox(height: 4),
          Text(
            money(snapshot.spent),
            style: Brand.text(size: 32, weight: FontWeight.w800, letterSpacing: -0.8),
          ),
          if (snapshot.hasLimit) ...[
            const SizedBox(height: 2),
            Text('of your ${money(snapshot.limit)} budget',
                style: Brand.text(size: 14, color: Brand.muted)),
          ],
          const SizedBox(height: 16),
          BudgetProgressBar(value: snapshot.progress, color: color, height: 12),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(budgetStatusIcon(status), size: 18, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    budgetStatusMessage(snapshot),
                    style: Brand.text(size: 13, weight: FontWeight.w500, color: Brand.ink),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: 'Budget',
                  value: snapshot.hasLimit ? money(snapshot.limit) : 'Not set',
                ),
              ),
              Expanded(
                child: _Stat(
                  label: snapshot.status == BudgetStatus.over ? 'Over by' : 'Left',
                  value: snapshot.hasLimit ? money(snapshot.remaining.abs()) : '--',
                  color: snapshot.status == BudgetStatus.over ? Brand.danger : null,
                ),
              ),
              Expanded(
                child: _Stat(
                  label: 'Used',
                  value: snapshot.hasLimit ? '${snapshot.percentUsed}%' : '--',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Brand.text(size: 12, color: Brand.muted)),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Brand.text(size: 15, weight: FontWeight.w700, color: color ?? Brand.ink),
        ),
      ],
    );
  }
}

class _Category {
  const _Category(this.name, this.icon, this.color, this.amount, this.entries);

  final String name;
  final IconData icon;
  final Color color;
  final int amount;
  final int entries;
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.snapshot});

  final BudgetSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final categories = [
      _Category('Fuel', Icons.local_gas_station_rounded, Brand.purple, snapshot.fuel, snapshot.fuelCount),
      _Category('Servicing', Icons.build_rounded, Brand.success, snapshot.servicing, snapshot.servicingCount),
      _Category('Repairs', Icons.handyman_rounded, Brand.warning, snapshot.repairs, snapshot.repairCount),
    ];
    final total = snapshot.categorised;

    if (total == 0) {
      return HomeCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Brand.lavender,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.receipt_long_rounded, color: Brand.purple),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nothing logged yet', style: Brand.text(size: 15, weight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Log fuel, servicing or repairs to see where your money goes.',
                      style: Brand.text(size: 13, color: Brand.muted, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // One bar split by category, so the biggest cost stands out.
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  for (final c in categories)
                    if (c.amount > 0)
                      Expanded(
                        flex: (c.amount * 1000 / total).round().clamp(1, 1000),
                        child: Container(color: c.color),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final c in categories) _CategoryRow(category: c, total: total),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.total});

  final _Category category;
  final int total;

  @override
  Widget build(BuildContext context) {
    final share = total == 0 ? 0 : (category.amount * 100 / total).round();
    final entries = category.entries;

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(category.icon, color: category.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: Brand.text(size: 15, weight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  entries == 0 ? 'No entries yet' : '$entries ${entries == 1 ? 'entry' : 'entries'}',
                  style: Brand.text(size: 12, color: Brand.muted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(money(category.amount), style: Brand.text(size: 15, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('$share%', style: Brand.text(size: 12, color: Brand.muted)),
            ],
          ),
        ],
      ),
    );
  }
}
