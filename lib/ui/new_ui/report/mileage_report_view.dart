import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
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
            const NormalText(
              text: "Today's weather (Lagos)",
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 16),
            ContainerWidget(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              backgroundColor: XColors.containerColor(),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: model.temperature,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  Container(
                    height: 60,
                    width: 2,
                    color: Color(0xFFF0E8F8).withOpacity(0.9),
                  ),
                  const GetSvgImage(
                      image: 'assets/images/meteocons_sun-hot.svg'),
                  Container(
                    height: 60,
                    width: 2,
                    color: Color(0xFFF0E8F8).withOpacity(0.9),
                  ),
                  const GetSvgImage(image: 'assets/images/bi_cloud-sun.svg'),
                  Container(
                    height: 60,
                    width: 2,
                    color: Color(0xFFF0E8F8).withOpacity(0.9),
                  ),
                  NormalText(
                    text: model.weatherCondition,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  Container(
                    height: 60,
                    width: 2,
                    color: Color(0xFFF0E8F8).withOpacity(0.9),
                  ),
                  NormalText(
                    text: model.humidity,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
                    '${model.fuelEfficiency} km/l',
                    'assets/images/fuel_guage.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Last Mileage Log
            const NormalText(text:
              'Last Mileage Log',
             
                fontSize: 18,
                fontWeight: FontWeight.w700,
           
            ),
            const SizedBox(height: 16),
            ContainerWidget(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,top: 10,bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                             const  NormalText(text: 'Date of trip: ',fontSize: 14,),
                              NormalText(text: model.lastTripDate,fontSize: 14,fontWeight: FontWeight.w400,textColor: XColors.black().withOpacity(0.7),)
                            ],
                          ),
                          const SizedBox(height: 4),
                             Row(
                            children: [
                             const  NormalText(text: 'Distance traveled: ',fontSize: 14,),
                              NormalText(text: '${model.lastTripDistance}km',fontSize: 14,fontWeight: FontWeight.w400,textColor: XColors.black().withOpacity(0.7),)
                            ],
                          ),
                          const SizedBox(height: 4),
                               Row(
                            children: [
                             const  NormalText(text: 'Fuel consumed: ',fontSize: 14,),
                              NormalText(text: '${model.lastTripFuelConsumed} liters',fontSize: 14,fontWeight: FontWeight.w400,textColor: XColors.black().withOpacity(0.7),)
                            ],
                          ),
                         
                          const SizedBox(height: 4),
                              Row(
                            children: [
                             const  NormalText(text: 'Efficiency: ',fontSize: 14,),
                              NormalText(text: '${model.lastTripEfficiency}km/l',fontSize: 14,fontWeight: FontWeight.w400,textColor: XColors.black().withOpacity(0.7),)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
             const  Expanded(child: GetPngImage(image: 'assets/images/car_millage.png',))
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Last Refuel and Current Mileage
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                   const GetPngImage(image: 'assets/images/last_refuel.png'),
                        const SizedBox(height: 12),
                        const NormalText(
                          text: 
                          'Last Refuel',
                         fontSize: 12,
                            fontWeight: FontWeight.w400,
                        
                        ),
                                                const SizedBox(height: 12),

                        NormalText(text:
                          model.lastRefuelDate,
                         fontSize: 12,
                            fontWeight: FontWeight.w500,
                        
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child:
                       ContainerWidget(
                elevation: 0.2,
                padding: const EdgeInsets.only(top: 16),
                borderRadius: BorderRadius.circular(16),
                backgroundColor: const Color(0xFFF3F3FA),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const NormalText(
                      text: 'Mileage',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    const YMargin(12),
                    const NormalText(
                      text: '10,030,409',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    const YMargin(21),
                    ContainerWidget(
                      elevation: 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                      backgroundColor: XColors.highlightColor(),
                      width: double.infinity,
                      child: const Center(
                        child: const NormalText(
                          text: 'Update',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Add Mileage Log Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: model.addMileageLog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add mileage log',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
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
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 4),
          NormalText(
            text: value,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
