import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/email_clain_view.dart';
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
              return const InsuranceClaimsBox(
                  status: 'Settled',
                  title: 'Accident Damage',
                  subTitle:
                      'Your claim is processing, you should be in contact with someone at motorby');
            }),
          )
        ],
      ),
    );
  }
}

class InsuranceClaimsBox extends StatelessWidget {
  const InsuranceClaimsBox({
    super.key,
    required this.status,
    required this.title,
    required this.subTitle,
  });
  final String status;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      margin: const EdgeInsets.only(bottom: 8),
      backgroundColor: XColors.white(),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 194,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: XColors.primaryColor2(),
                ),
                const YMargin(7),
                NormalText(
                  text: subTitle,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                const YMargin(12),
                Row(
                  children: [
                    ContainerWidget(
                      onTap: (){
                        navigate(context,  EmailClaimView(status: status,));
                      },
                      padding: const EdgeInsets.symmetric(
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
                          vertical: 3, horizontal: 4),
                      backgroundColor: XColors.background(),
                      borderColor: XColors.highlightColor(),
                      borderThickness: 1,
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
          status == 'Processing'
              ? const Row(
                  children: [
                    GetSvgImage(image: 'assets/images/processing-icon.svg'),
                    XMargin(4),
                    NormalText(
                      text: 'Processing',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: Colors.red,
                    )
                  ],
                )
              : status == 'Cancelled'
                  ? const Row(
                      children: [
                        GetSvgImage(image: 'assets/images/canceel-icon.svg'),
                        XMargin(4),
                        NormalText(
                          text: 'Cancelled',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.red,
                        )
                      ],
                    )
                  : const Row(
                      children: [
                        GetSvgImage(image: 'assets/images/settle-icon.svg'),
                        XMargin(4),
                        NormalText(
                          text: 'Settled',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.green,
                        )
                      ],
                    ),
        ],
      ),
    );
  }
}
