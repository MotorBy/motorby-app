import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class BuyInsuranceScreen extends StatefulWidget {
  const BuyInsuranceScreen({super.key});

  @override
  State<BuyInsuranceScreen> createState() => _BuyInsuranceScreenState();
}

class _BuyInsuranceScreenState extends State<BuyInsuranceScreen> {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: 'Comprehensive Party Insurance',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                textColor: XColors.black(),
              ),
              const SizedBox(
                height: 8,
              ),
              const NormalText(
                text:
                    'Comprehensive coverage for your vehicle, offering protection against accidents, theft, and natural disasters',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const YMargin(32),
              const NormalText(
                text: 'Coverage Includes',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              const YMargin(10),
              const CoverageBox(
                title:
                    'Damage to your car from accidents, fire, or natural disasters.  ',
              ),
              const YMargin(2),
              const CoverageBox(
                title: 'Theft or Vandalism.  ',
              ),
              const YMargin(2),
              const CoverageBox(
                title:
                    'Third party liability for property damage or injury.   ',
              ),
              const YMargin(2),
              const CoverageBox(
                title: 'Personal accident cover for drivers and passengers.',
              ),
              const YMargin(32),
              const NormalText(
                text: 'Benefits',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              const YMargin(10),
              const CoverageBox(
                title: 'Full peace of mind with wide ranging coverage.',
              ),
              const YMargin(2),
              const CoverageBox(
                title: 'Access to a networking or repair garage. ',
              ),
              const YMargin(2),
              const CoverageBox(
                title: 'Optional roadside assistance  ',
              ),
              const YMargin(32),
              const NormalText(
                text: 'Base Price',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              const YMargin(10),
              const NormalText(
                text:
                    'N15,000 - N25,000 Per month (Depending on car type, age, value   ',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const YMargin(10),
              const CoverageBox(
                title: 'Zero deprecation covers N15,000 monthly ',
              ),
              const YMargin(2),
              const CoverageBox(
                title: 'Engine protection covers N15,000 monthly ',
              ),
              const YMargin(2),
              const CoverageBox(
                title: 'Return to invoice covers N15,000 monthly ',
              ),
              const YMargin(60),
              ContainerWidget(
                backgroundColor: XColors.primaryColor2(),
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: Center(child: NormalText(text: 'Buy Now',textColor: XColors.white(),fontSize: 16,fontWeight: FontWeight.w600,)),
              ),
                            const YMargin(30),

            ],
          ),
        ),
      ),
    );
  }
}

class CoverageBox extends StatelessWidget {
  const CoverageBox({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CircleAvatar(
            radius: 2,
            backgroundColor: XColors.black(),
          ),
        ),
        const XMargin(16),
        Expanded(
            child: NormalText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ))
      ],
    );
  }
}
