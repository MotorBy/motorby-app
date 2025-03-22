import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ClaimScreen extends StatefulWidget {
  const ClaimScreen({super.key});

  @override
  State<ClaimScreen> createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InsuranceAppBar(
        text1: 'Claim',
      ),
      backgroundColor: XColors.background(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerWidget(
            margin: const EdgeInsets.symmetric(horizontal: 18.0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
            backgroundColor: const Color(0xFFF3F3FA),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text: 'Claim',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    YMargin(8),
                    NormalText(
                      text: 'File a new claim or view claim',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                ContainerWidget(
                  onTap: () {
                    navigate(context, const ClaimScreen());
                  },
                  borderColor: XColors.primaryColor2(),
                  hasBorder: true,
                  borderThickness: 1,
                  borderRadius: BorderRadius.circular(8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: const Row(
                    children: [
                      XMargin(8),
                      NormalText(
                        text: '+ New Claim',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const YMargin(32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: NormalText(
              text: 'Existing Claims',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const YMargin(14),
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return ContainerWidget(
                margin: const EdgeInsets.only(bottom: 8),
                backgroundColor: XColors.white(),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 194,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const NormalText(
                            text: 'Accident Damage',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          const YMargin(7),
                          const NormalText(
                            text:
                                'Your claim is processing, you should be in contact with someone at motorby',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                          const YMargin(12),
                          Row(
                            children: [
                              ContainerWidget(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                backgroundColor: XColors.primaryColor2(),
                                borderRadius: BorderRadius.circular(5),
                                child: NormalText(
                                  text: 'View Details ',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  textColor: XColors.white(),
                                ),
                              ),
                              const XMargin(5),
                              ContainerWidget(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                backgroundColor: XColors.background(),
                                borderColor: XColors.highlightColor(),
                                borderThickness: 2,
                                hasBorder: true,
                                borderRadius: BorderRadius.circular(5),
                                child: NormalText(
                                  text: 'Contact Support ',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  textColor: XColors.black(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      children: [
                        GetSvgImage(image: ''),
                         XMargin(4),
                        NormalText(
                          text: 'Cancelled',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
