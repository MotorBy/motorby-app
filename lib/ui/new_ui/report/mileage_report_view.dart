import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class MileageReportView extends StatelessWidget {
  final ReportViewModel model;

  const MileageReportView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather Section
            // NormalText(
            //   text: "Today's weather (Lagos)",
            //   fontSize: 20,
            //   fontWeight: FontWeight.w600,
            //   textColor: XColors.black(),
            // ),
            // const SizedBox(height: 16),
            // ContainerWidget(
            //   padding: const EdgeInsets.symmetric(horizontal: 24),
            //   backgroundColor: XColors.containerColor(),
            //   borderRadius: BorderRadius.circular(20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       NormalText(
            //         text: model.temperature,
            //         fontSize: 28,
            //         fontWeight: FontWeight.w600,
            //         textColor: XColors.black(),
            //       ),
            //       Container(
            //         height: 60,
            //         width: 2,
            //         color: const Color(0xFFF0E8F8).withOpacity(0.9),
            //       ),
            //       const GetSvgImage(
            //           image: 'assets/images/meteocons_sun-hot.svg'),
            //       Container(
            //         height: 60,
            //         width: 2,
            //         color: const Color(0xFFF0E8F8).withOpacity(0.9),
            //       ),
            //       const GetSvgImage(image: 'assets/images/bi_cloud-sun.svg'),
            //       Container(
            //         height: 60,
            //         width: 2,
            //         color: const Color(0xFFF0E8F8).withOpacity(0.9),
            //       ),
            //       NormalText(
            //         text: model.weatherCondition,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         textColor: XColors.black().withOpacity(0.8),
            //       ),
            //       Container(
            //         height: 60,
            //         width: 2,
            //         color: const Color(0xFFF0E8F8).withOpacity(0.9),
            //       ),
            //       NormalText(
            //         text: model.humidity,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         textColor: XColors.black().withOpacity(0.8),
            //       ),
            //     ],
            //   ),
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: const NormalText(
                    text: 'Update your mileage when you get to any destination to get better reports',
                    fontSize: 13,
                    maxLines: 3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.mode_edit_outline_rounded,
                    color: XColors.primaryColor(),
                  ),
                  onPressed: () {

                    modalBottomSheetMenu(
                      color: Colors.white,
                      context: context,
                      child: InfoDetailsView(
                        infoType: InfoType.mileage,
                        currentIndex: 0,
                        onBudgetAction: () {
                          model.setBudgetData();
                          FloatingSnackBar.show(
                              context,
                              'Successfully updated',
                              isError: false
                          );

                        },
                      ),
                    );

                  },
                ),
              ],
            ),

            const SizedBox(height: 44),

            // Last Mileage Log
            const NormalText(
              text: 'Last Mileage Log',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            ContainerWidget(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Padding(
                      padding:
                      const EdgeInsets.only( top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const NormalText(
                                text: 'Date of trip: ',
                                fontSize: 13,
                              ),
                              NormalText(
                                text: model.lastTripDate,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: XColors.black(),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const NormalText(
                                text: 'Distance traveled: ',
                                fontSize: 14,
                              ),
                              NormalText(
                                text: '${model.lastTripDistance}km',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                textColor: XColors.black(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                      child: GetPngImage(
                        image: 'assets/images/car_millage.png',
                        height: 70,
                      ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 34),
            NormalText(
              text: "View summary",
              fontSize: 13,
              textColor: XColors.primaryColor(),
              fontWeight: FontWeight.w600,
            ),
            const YMargin(14),
            // Mileage Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Mileage',
                    '${model.totalMileage}km',
                    'assets/images/total-milage.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Fuel Efficiency',
                    '${model.fuelEfficiency} km/L',
                    'assets/images/fuel_guage.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Last refuel on',
                    model.lastRefuelDate,
                    'assets/images/total-milage.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Last refuel amount',
                    '\u20A6 ${model.lastRefuelAmount}',
                    'assets/images/fuel_guage.png',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Add Mileage Log Button
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: XColors.containerColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GetPngImage(image: icon),
          const SizedBox(height: 8),
          NormalText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: XColors.black().withOpacity(0.7),
          ),
          const SizedBox(height: 4),
          NormalText(
            text: value,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textColor: XColors.black(),
          ),
        ],
      ),
    );
  }
}
