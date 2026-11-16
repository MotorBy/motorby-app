import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_viewmodel.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
import 'package:mobile_auto_drive/utils/currency.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:stacked/stacked.dart';

/// A car's spending as a list: fuel, servicing, repairs and what is left of
/// the budget. Tapping a row opens the sheet that logs or updates it.
class BudgetTilesView extends StatelessWidget {
  const BudgetTilesView({super.key, this.budgetCurrentIndex, this.onUpdated});

  /// The car's place in the budget list.
  final int? budgetCurrentIndex;

  /// Called after an entry or the budget was saved.
  final VoidCallback? onUpdated;

  int get _index => budgetCurrentIndex ?? 0;

  void _open(BuildContext context, ReportViewModel model, InfoType type) {
    if (model.budgetingModel?.budget?.isEmpty ?? true) {
      FloatingSnackBar.show(context, 'Add a new car to continue with budget activities', isError: true);
      return;
    }
    modalBottomSheetMenu(
      color: Colors.white,
      context: context,
      child: InfoDetailsView(
        infoType: type,
        currentIndex: _index,
        onBudgetAction: () {
          model.setBudgetData(currentIndex: _index);
          onUpdated?.call();
          FloatingSnackBar.show(context, 'Successfully updated', isError: false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportViewModel>.reactive(
      viewModelBuilder: () => ReportViewModel(),
      disposeViewModel: false,
      onViewModelReady: (model) => model.setBudgetData(currentIndex: _index),
      builder: (context, model, child) {
        final totals = model.totalCostingAndValue ?? const <int>[];
        int total(int i) => i < totals.length ? totals[i] : 0;
        final left = (model.currentSetBudget ?? 0) - (model.currentTotalSpent ?? 0);

        final items = [
          _SpendItem('Fuel', 'Log a fill-up', Icons.local_gas_station_rounded, Brand.purple, total(0),
              InfoType.fueling),
          _SpendItem('Servicing', 'Log a service', Icons.build_rounded, Brand.success, total(1),
              InfoType.servicing),
          _SpendItem('Repairs', 'Log a repair', Icons.handyman_rounded, Brand.warning, total(2),
              InfoType.repairing),
          _SpendItem(left < 0 ? 'Over budget' : 'Budget left', 'Update budget', Icons.account_balance_wallet_rounded,
              left < 0 ? Brand.danger : Brand.info, left.abs(), InfoType.budgeting),
        ];

        return Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) Divider(height: 0.5, indent: 64, color: Brand.lilac.withValues(alpha: 0.3)),
              _SpendRow(item: items[i], onTap: () => _open(context, model, items[i].type)),
            ],
          ],
        );
      },
    );
  }
}

class _SpendItem {
  const _SpendItem(this.label, this.action, this.icon, this.color, this.amount, this.type);

  final String label;
  final String action;
  final IconData icon;
  final Color color;
  final int amount;
  final InfoType type;
}

class _SpendRow extends StatelessWidget {
  const _SpendRow({required this.item, required this.onTap});

  final _SpendItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: Brand.text(size: 15, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(item.action, style: Brand.text(size: 12, color: Brand.muted)),
                ],
              ),
            ),
            Text(money(item.amount),
                style: Brand.text(
                  size: 15,
                  weight: FontWeight.w700,
                  color: item.type == InfoType.budgeting ? item.color : Brand.ink,
                )),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: Brand.muted, size: 20),
          ],
        ),
      ),
    );
  }
}
