import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const GetSvgImage(
              image: 'assets/images/arrow_back.svg',
              boxFit: BoxFit.scaleDown,
            )),
        centerTitle: false,
        backgroundColor: XColors.highlightColor().withOpacity(0.1),
        title: const NormalText(
          text: 'Car Insurance',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: XColors.background(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const YMargin(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NormalText(
                text: 'Protect your car with comprehensive coverage',
                fontSize: 18,
                fontWeight: FontWeight.w400,
                textColor: XColors.black(),
              ),
            ),
            const YMargin(36),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              leading: const Icon(Icons.directions_car),
              dense: true,
              visualDensity: const VisualDensity(horizontal: -4),
              title: Row(
                children: [
                  Image.asset('assets/images/toyota-logo.png', height: 24),
                  const SizedBox(width: 2),
                  const NormalText(
                    text: 'Toyota',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  const XMargin(10),
                  Icon(
                    Icons.expand_less_rounded,
                    color: XColors.black(),
                    size: 30,
                  )
                ],
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => const VehicleSelectionBottomSheet(),
                );
              },
              trailing: ContainerWidget(
                borderColor: XColors.primaryColor2(),
                hasBorder: true,
                borderThickness: 1,
                borderRadius: BorderRadius.circular(8),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: const NormalText(
                  text: 'Claim',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const YMargin(16),
            ContainerWidget(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              backgroundColor: XColors.white(),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NormalText(
                        text: 'Toyota Camery',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      const YMargin(8),
                      const NormalText(
                        text: 'DS9376GJ',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      const YMargin(20),
                      Row(
                        children: [
                          NormalText(
                            text: 'DS9376GJ',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: XColors.primaryColor2(),
                          ),
                          const XMargin(6),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: XColors.primaryColor2(),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const GetPngImage(image: 'assets/images/auto/camery_car.png')
                ],
              ),
            ),
            const YMargin(32),
            ContainerWidget(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              backgroundColor: Color(0xFFF3F3FA),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NormalText(
                        text: 'Current Purchased ',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      const YMargin(18),
                      const NormalText(
                        text: 'Comprehensive Party Insurance',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const YMargin(7),
                      Row(
                        children: [
                          NormalText(
                            text: 'By ',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: XColors.black(),
                          ),
                          NormalText(
                            text: 'Leadway Insurance Ltd.',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: XColors.black(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  NormalText(
                    text: 'View Details ',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    textColor: XColors.primaryColor2(),
                  ),
                ],
              ),
            ),
            const YMargin(32),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: NormalText(
                text: 'Available Insurance ',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const YMargin(20),
            SizedBox(
              height: 120,
              child: ListView.builder(
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ContainerWidget(
                      width: 310,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      borderRadius: BorderRadius.circular(16),
                      backgroundColor: XColors.secondaryColor(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const NormalText(
                            text: 'Comprehensive Party Insurance',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          const YMargin(10),
                          const NormalText(
                            text: 'Third Party Insurance ',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          const YMargin(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    '₦',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  NormalText(
                                      text: '15,000',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ],
                              ),
                              ContainerWidget(
                                backgroundColor: XColors.white(),
                                borderRadius: BorderRadius.circular(8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: NormalText(
                                  text: 'Buy Now',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  textColor: XColors.primaryColor2(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            const YMargin(32),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: NormalText(
                text: 'Your Certification Of Insurance',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: NormalText(
                  text:
                      'Here’s what you need to prove that you have a policy with comprehensive party insurance'),
            ),
            const YMargin(16),
           const  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              GetSvgImage(image: 'assets/images/material-symbols_download.svg'),
              NormalText(text: 'Download certificate',fontSize: 10,fontWeight: FontWeight.w600,textColor: Colors.green,)
            ],),
          const  YMargin(50),
          ],
        ),
      ),
    );
  }
}
