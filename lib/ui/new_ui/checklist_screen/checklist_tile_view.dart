import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ChecklistTileView extends StatelessWidget {
  const ChecklistTileView({super.key, this.checkedItems = 0, this.totalItems = 0, this.onCheckListScreen});

  final int? totalItems;
  final int? checkedItems;
  final Function? onCheckListScreen;

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      onTap: () {
        onCheckListScreen?.call();
      },
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: XColors.secondaryColor().withOpacity(0.3),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NormalText(
                text: 'Checklist',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              const YMargin(6),
              NormalText(
                text: '$checkedItems/$totalItems',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          CircularProgressIndicator(
            value: checkedItems != 0 ? (checkedItems!/totalItems!) : 0.8,
            color: Colors.deepPurple,
            strokeWidth: 8,
            backgroundColor: Colors.black12,
          ),
        ],
      ),
    );
  }
}

class MileageTileView extends StatelessWidget {
  const MileageTileView({
    super.key, this.totalMileage = "0", this.onMileageUpdate
  });

  final String? totalMileage;
  final Function? onMileageUpdate;

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      onTap: () {
        onMileageUpdate?.call();
      },
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: XColors.secondaryColor().withOpacity(0.3),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NormalText(
                text: 'Mileage',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              const YMargin(6),
              NormalText(
                text: "${totalMileage} km",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}