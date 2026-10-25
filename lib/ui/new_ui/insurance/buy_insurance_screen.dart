import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/add/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/insurance/insurance_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/kyc/kyc_verification_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_html/flutter_html.dart';

class BuyInsuranceScreen extends StatefulWidget {
  const BuyInsuranceScreen({super.key, this.insuranceViewModel});

  final InsuranceViewModel? insuranceViewModel;

  @override
  State<BuyInsuranceScreen> createState() => _BuyInsuranceScreenState();
}

class _BuyInsuranceScreenState extends State<BuyInsuranceScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => widget.insuranceViewModel ?? InsuranceViewModel(),
        disposeViewModel: false,
        onViewModelReady:(model) async {
          await model.getInsuranceProductDetails();
          model.getCurrentCar();
        },
        builder: (context, model, child) {

          if(model.isBusy) {
            return Scaffold(
                appBar: appBarHeader(
                  hasOnBack: true,
                  context: context,
                  appBarTitle: 'Buy Insurance',
                ),
                body: const Center(child: Loader())
            );
          }

          if(model.insuranceProductDetails == null) {
            return Scaffold(
              appBar: appBarHeader(
                hasOnBack: true,
                context: context,
                appBarTitle: 'Buy Insurance',
              ),
              backgroundColor: XColors.background(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NormalText(
                      text: 'Insurance product is currently unavailable',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: XColors.black(),
                    ),
                    const YMargin(16),
                    ContainerWidget(
                      onTap: () => model.getInsuranceProductDetails(),
                      backgroundColor: XColors.primaryColor2(),
                      borderRadius: BorderRadius.circular(8),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: NormalText(
                        text: 'Retry',
                        textColor: XColors.white(),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Buy Insurance',
            actions: [
              // ContainerWidget(
              //   onTap: () {
              //
              //     showModalBottomSheet(
              //       context: context,
              //       isScrollControlled: true,
              //       shape: const RoundedRectangleBorder(
              //         borderRadius: BorderRadius.vertical(
              //             top: Radius.circular(20)),
              //       ),
              //       builder: (context) =>
              //       const InsuranceQuoteBottomSheet(),
              //     );
              //
              //   },
              //   borderColor: XColors.primaryColor2(),
              //   hasBorder: true,
              //   borderThickness: 2,
              //   borderRadius: BorderRadius.circular(21),
              //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              //   child: const NormalText(
              //     text: 'Request quote',
              //     fontSize: 14,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              const XMargin(10)
            ]
          ),
          backgroundColor: XColors.background(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            width: MediaQuery.of(context).size.width - 70,
            child: XButton(
            onPressed: () {
              if (model.getCurrentCar() == null) {
                FloatingSnackBar.show(
                    context,
                    'Please select a vehicle to proceed with insurance purchase',
                    isError: true
                );
                return;
              }

              if (model.getCurrentCar()?.vinNumber == null || model.getCurrentCar()?.engineNumber == null) {
                FloatingSnackBar.show(
                    context,
                    'Please update your vehicle details to proceed with insurance purchase',
                    isError: true
                );
                return;
              }

              if(model.hasKycVerification == false) {
                FloatingSnackBar.show(
                    context,
                    'Make sure to complete your KYC first to easily purchase an auto insurance',
                    isError: true
                );
              } else {
                model.makePayment(
                    onInitialisedError: (e) {
                      FloatingSnackBar.show(
                          context,
                          e.toString(),
                          isError: true
                      );
                    },
                    onShowPayModal: (initTrans) async {
                      await PaymentService.showPaymentModal(
                        context,
                        transaction: initTrans!,
                      ).then((value) async {
                        await model.verifyPayment(
                            onCallBack: (){
                              FloatingSnackBar.show(
                                  context,
                                  'Successfully bought an insurance',
                                  isError: false
                              );
                              Navigator.pop(context, true);
                            },
                            onErrorCallBack: (e) {
                              FloatingSnackBar.show(
                                  context,
                                  e!,
                                  isError: true
                              );
                            }
                        );
                      });
                    }
                );
              }
            },
            text: 'Buy now',
            isLoading: model.isBusy,
            buttonColor: model.hasKycVerification && model.getCurrentCar() != null && model.getCurrentCar()?.vinNumber != null && model.getCurrentCar()?.engineNumber != null
                ? XColors.primaryColor()
                : XColors.borderColor(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const YMargin(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      NormalText(
                        text: model.insuranceProductDetails?.payload?.name ?? 'Insurance Product',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        textColor: XColors.black(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 70,
                        child: NormalText(
                          text: "by ${model.insuranceProductDetails?.payload?.provider!.companyName}" ?? 'MyCover',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          textColor: XColors.black(),
                        ),
                      ),
                    ],
                  ),
                  const YMargin(10),
                  NormalText(
                    text: model.insuranceProductDetails?.payload?.description ?? 'Insurance product description',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  const YMargin(32),
                  const NormalText(
                    text: 'Key Benefits',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  if (model.insuranceProductDetails?.payload?.keyBenefits != null)
                    Html(
                      data: model.insuranceProductDetails!.payload!.keyBenefits!,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14),
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  const YMargin(32),
                  const NormalText(
                    text: 'How It Works',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  if (model.insuranceProductDetails?.payload?.howItWorks != null)
                    Html(
                      data: model.insuranceProductDetails!.payload!.howItWorks!,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14),
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  const YMargin(32),
                  const NormalText(
                    text: 'Monthly Premium',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  const YMargin(10),
                  ////insurance product amount display section
                  if(model.insuranceProductDetails?.payload?.variant == 1) ... [

                    NormalText(
                      text: '₦${model.insuranceProductDetails?.payload?.price ?? '0.0'} of vehicle value',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),

                  ] else ...  [

                    NormalText(
                      text: '${model.insuranceProductDetails?.payload?.price ?? '0.0'}% of vehicle value',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),

                  ],
                  const NormalText(
                    text: '+ ₦${800} processing fee',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  const YMargin(30),
                  const YMargin(32),
                  const NormalText(
                    text: 'Vehicle Details',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  const YMargin(10),
                  ContainerWidget(
                    backgroundColor: XColors.white(),
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (model.getCurrentCar() != null) ... [
                          NormalText(
                            text: '${model.getCurrentCar()?.carMake ?? ''} ${model.getCurrentCar()?.carModel ?? ''} ${model.getCurrentCar()?.carYear ?? ''}',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const YMargin(8),
                          if (model.getCurrentCar()?.vinNumber == null || model.getCurrentCar()?.engineNumber == null) ... [
                            ContainerWidget(
                              backgroundColor: const Color(0xFFFEF3F2),
                              borderRadius: BorderRadius.circular(8),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded, color: XColors.red()),
                                      const XMargin(8),
                                      NormalText(
                                        text: 'Missing Vehicle Details',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        textColor: XColors.red(),
                                      ),
                                    ],
                                  ),
                                  const YMargin(8),
                                  const NormalText(
                                    text: 'Please complete your vehicle details to proceed with insurance purchase.',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const YMargin(16),
                                  ContainerWidget(
                                    onTap: () {

                                      navigate(
                                          context,
                                          AddCarsScreen(
                                            action: 'edit',
                                            currentCar: model.getCurrentCar(),
                                          ),
                                          onCallback: (){
                                            //model.init();
                                          },
                                      );

                                    },
                                    backgroundColor: XColors.primaryColor2(),
                                    borderRadius: BorderRadius.circular(8),
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                    child: NormalText(
                                      text: 'Update Vehicle Details',
                                      textColor: XColors.white(),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ... [
                            Row(
                              children: [
                                const NormalText(
                                  text: 'VIN: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                NormalText(
                                  text: model.getCurrentCar()!.vinNumber ?? '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            const YMargin(4),
                            Row(
                              children: [
                                const NormalText(
                                  text: 'Engine Number: ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                NormalText(
                                  text: model.getCurrentCar()!.engineNumber ?? '',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ] else ... [
                          const Center(
                            child: NormalText(
                              text: 'No vehicle selected',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const YMargin(30),
                  if (model.hasKycVerification == false) ... [
                    ContainerWidget(
                      backgroundColor: const Color(0xFFFEF3F2),
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: XColors.red()),
                              const XMargin(8),
                              NormalText(
                                text: 'KYC Verification Required',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                textColor: XColors.red(),
                              ),
                            ],
                          ),
                          const YMargin(8),
                          const NormalText(
                            text: 'Complete your KYC verification to proceed with insurance purchase.',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const YMargin(16),
                          ContainerWidget(
                            onTap: () {
                              navigate(context, const KYCVerificationScreen());
                            },
                            backgroundColor: XColors.primaryColor2(),
                            borderRadius: BorderRadius.circular(8),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            child: NormalText(
                              text: 'Complete KYC',
                              textColor: XColors.white(),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const YMargin(30),
                  ],
                  const YMargin(80),
                ],
              ),
            ),
          ),
        );
      }
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
                  color: const Color(0xFFD0D5DD),
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