import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_details_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_summary.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

/// Opens the full mileage view for the car at [budgetIndex]; resolves when the user leaves it.
Future<void> openMileageDetails(BuildContext context, {required int budgetIndex}) {
  return Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => MileageDetailsScreen(budgetIndex: budgetIndex)),
  );
}

class MileageDetailsScreen extends StatelessWidget {
  const MileageDetailsScreen({super.key, required this.budgetIndex});

  final int budgetIndex;

  void _openUpdateSheet(BuildContext context, MileageDetailsViewModel viewModel) {
    modalBottomSheetMenu(
      color: Colors.white,
      context: context,
      child: InfoDetailsView(
        infoType: InfoType.mileage,
        currentIndex: budgetIndex,
        // Already on the details screen, so "View details" only needs to close the sheet.
        onViewDetails: () => Navigator.pop(context),
        onBudgetAction: () {
          viewModel.load();
          FloatingSnackBar.show(context, 'Mileage updated', isError: false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MileageDetailsViewModel>.reactive(
      viewModelBuilder: () => MileageDetailsViewModel(budgetIndex: budgetIndex),
      onViewModelReady: (model) => model.load(),
      builder: (context, viewModel, child) {
        final summary = viewModel.summary;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Mileage',
          ),
          body: RefreshIndicator(
            onRefresh: viewModel.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _MileageOverviewCard(carName: viewModel.carName, summary: summary),
                if (viewModel.refreshError != null) ...[
                  const YMargin(12),
                  NormalText(
                    text: viewModel.refreshError,
                    fontSize: 13,
                    textColor: Colors.red,
                  ),
                ],
                const YMargin(20),
                XButton(
                  onPressed: () => _openUpdateSheet(context, viewModel),
                  text: 'Update mileage',
                  height: 52,
                  textColor: Colors.white,
                  buttonColor: XColors.primaryColor(),
                  radius: 26,
                  width: SizeConfig().sw(400) as double?,
                ),
                const YMargin(28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                      text: 'Mileage log',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: XColors.textColor(),
                    ),
                    NormalText(
                      text: '${summary.entries.length} ${summary.entries.length == 1 ? 'entry' : 'entries'}',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: XColors.primaryColor(),
                    ),
                  ],
                ),
                const YMargin(12),
                if (summary.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: XColors.highlightColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const NormalText(
                      text: 'No mileage logged yet. Update your odometer reading when you reach a destination to start tracking.',
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...summary.entries.map((entry) => _MileageLogTile(entry: entry)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MileageOverviewCard extends StatelessWidget {
  const _MileageOverviewCard({required this.carName, required this.summary});

  final String carName;
  final MileageSummary summary;

  @override
  Widget build(BuildContext context) {
    final efficiency = summary.fuelEfficiency;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: XColors.secondaryColor().withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: NormalText(
                  text: carName,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: XColors.textColor().withOpacity(0.7),
                ),
              ),
              Icon(Icons.speed, color: XColors.primaryColor()),
            ],
          ),
          const YMargin(10),
          NormalText(
            text: 'Current odometer',
            fontSize: 13,
            textColor: XColors.textColor().withOpacity(0.6),
          ),
          const YMargin(4),
          NormalText(
            text: formatKm(summary.currentReading),
            fontSize: 28,
            fontWeight: FontWeight.w800,
            textColor: XColors.textColor(),
          ),
          if (summary.latest != null) ...[
            const YMargin(4),
            NormalText(
              text: 'Last updated ${formatLogDate(summary.latest!.datum.inputDate)}',
              fontSize: 12,
              textColor: XColors.textColor().withOpacity(0.6),
            ),
          ],
          const YMargin(18),
          Row(
            children: [
              Expanded(child: _Stat(label: 'Distance tracked', value: formatKm(summary.distanceTracked))),
              Expanded(child: _Stat(label: 'Last trip', value: formatKm(summary.lastTripDistance))),
              Expanded(
                child: _Stat(
                  label: 'Fuel efficiency',
                  value: efficiency == null ? '--' : '${efficiency.toStringAsFixed(1)} km/L',
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
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: label,
          fontSize: 11,
          textColor: XColors.textColor().withOpacity(0.6),
        ),
        const YMargin(4),
        NormalText(
          text: value,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          textColor: XColors.textColor(),
        ),
      ],
    );
  }
}

class _MileageLogTile extends StatelessWidget {
  const _MileageLogTile({required this.entry});

  final MileageLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final datum = entry.datum;
    final gauge = datum.currentFuelGauge;
    final distance = entry.distanceSincePrevious;
    final address = datum.destinationAddress;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: NormalText(
                  text: formatLogDate(datum.inputDate),
                  fontSize: 12,
                  textColor: XColors.textColor().withOpacity(0.6),
                ),
              ),
              if (distance != null)
                NormalText(
                  text: '${distance >= 0 ? '+' : ''}${formatKm(distance)}',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textColor: XColors.primaryColor(),
                ),
            ],
          ),
          const YMargin(6),
          NormalText(
            text: entry.reading != null ? formatKm(entry.reading) : (datum.odometerReading ?? '--'),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            textColor: XColors.textColor(),
          ),
          if (gauge != null && gauge.isNotEmpty) ...[
            const YMargin(6),
            Row(
              children: [
                Icon(Icons.local_gas_station_outlined, size: 16, color: XColors.primaryColor()),
                const XMargin(6),
                NormalText(
                  text: 'Fuel gauge: ${gauge[0].toUpperCase()}${gauge.substring(1)}',
                  fontSize: 13,
                  textColor: XColors.textColor(),
                ),
              ],
            ),
          ],
          if (address != null && address.isNotEmpty) ...[
            const YMargin(6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: XColors.primaryColor()),
                const XMargin(6),
                Expanded(
                  child: NormalText(
                    text: address,
                    fontSize: 13,
                    textColor: XColors.textColor(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
