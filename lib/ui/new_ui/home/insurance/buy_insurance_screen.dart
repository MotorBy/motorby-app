import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class BuyInsuranceScreen extends StatefulWidget {
  const BuyInsuranceScreen({super.key});

  @override
  State<BuyInsuranceScreen> createState() => _BuyInsuranceScreenState();
}

class _BuyInsuranceScreenState extends State<BuyInsuranceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InsuranceAppBar(
      text1: 'Car Insurance',
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
                onTap: (){
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) =>
                              const PaymentMethod(),
                        );
                },
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

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => InsuranceViewModel(),
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  height: 4,
                  width: 40,
                  color: Color(0xFFD0D5DD),
                )),
               const YMargin(30),
            const    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     NormalText(
                      text: 'Choose payment method',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                   
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                    height: 230,
                    child: ListView.builder(
                      itemCount: model.paymentMethod.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            model.updateSelectedPaymentMethod(
                             index);
                          },
                          trailing: ContainerWidget(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: XColors.white(),
                              shape: BoxShape.circle,
                              border: Border.all(
                                width:  model.selectedPaymentMethod == index
                                    ?0:1,
                                color:const Color(0xFFD0D5DD)
                              ),
                            ),
                            child: 
                                  model.selectedPaymentMethod == index
                                      ? const Icon(Icons.check_circle,color: Colors.green,):const SizedBox.shrink(
                            ),
                          ),
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                          ),
                          leading:GetSvgImage(image:  model.paymentMethod[index].img) ,
                          title: NormalText(text: model.paymentMethod[index].details),
                        );
                      },
                    
                    ),
                    ),
                   const YMargin(20),
                        ContainerWidget(
                onTap: (){
                 
                },
                backgroundColor: XColors.primaryColor2(),
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: Center(child: NormalText(text: 'Buy Now',textColor: XColors.white(),fontSize: 16,fontWeight: FontWeight.w600,)),
              ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
  }
}