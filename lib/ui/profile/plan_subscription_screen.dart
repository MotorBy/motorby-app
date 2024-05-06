import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class PlanSubscriptionScreen extends StatelessWidget {
  const PlanSubscriptionScreen({super.key, this.profileViewModel});

  final ProfileViewModel? profileViewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => profileViewModel!,
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: XColors.white(),
            surfaceTintColor: XColors.white(),
            leading: GestureDetector(
                onTap: () {
                  popView(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 18,
                  color: XColors.black(),
                )),
          ),
          floatingActionButton: Row(
            children: [
              const XMargin(50),
              if(model.currentPlanIndex == 0) ... [

                NormalText(
                  text: "NGN ${isBusiness ?
                  model.planModel!.plans!.business!.free!.price.toString() :
                  model.planModel!.plans!.user!.free!.price.toString()}/month",
                  textColor: XColors.textColor(),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),

              ] else if (model.currentPlanIndex == 1) ... [

                NormalText(
                  text: "NGN ${isBusiness ?
                  model.planModel!.plans!.business!.pro!.price.toString() :
                  model.planModel!.plans!.user!.pro!.price.toString()}/month",
                  textColor: XColors.textColor(),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),

              ] else if(model.currentPlanIndex == 2) ... [

                NormalText(
                  text: "NGN ${isBusiness ?
                  model.planModel!.plans!.business!.ultra!.price.toString() :
                  model.planModel!.plans!.user!.ultra!.price.toString()}/month",
                  textColor: XColors.textColor(),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),

              ],
              const Expanded(child: XMargin(10)),
              XButton(
                onPressed: () {
                  model.makePayment(
                      onInitialisedError: (e){
                        print(e);
                      },
                      onShowPayModal: (initTrans) async {
                        if(initTrans != null) {

                          await PaymentService.showPaymentModal(
                            context,
                            transaction: initTrans,
                          ).then((value) async {

                            await model.verifyPayment(
                                onCallBack: (){
                                  showSnackBar(
                                      context: context,
                                      message: 'Successfully subscribed'
                                  );
                                },
                                onErrorCallBack: (){
                                  showSnackBar(
                                      error: true,
                                      context: context,
                                      message: 'Error with making your subscription'
                                  );
                                }
                            );
                          });

                        } else {

                          await model.verifyPayment(
                              freeSub: true,
                              onCallBack: (){
                                showSnackBar(
                                    context: context,
                                    message: 'Successfully subscribed'
                                );
                              },
                              onErrorCallBack: (){
                                showSnackBar(
                                    error: true,
                                    context: context,
                                    message: 'Error with making your subscription'
                                );
                              }
                          );
                        }
                      }
                  );
                },
                text: 'Subscribe',
                isLoading: model.isBusy,
                buttonColor: XColors.primaryColor(),
                width: 120,
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    NormalText(
                      text: model.currentPlan,
                      textColor: XColors.textColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    const XMargin(10),
                    NormalText(
                      text: 'plan',
                      textColor: XColors.textColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const YMargin(80),
                CarouselSlider(
                    options: CarouselOptions(
                      reverse: false,
                      autoPlay: false,
                      clipBehavior: Clip.hardEdge,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.7,
                      height: MediaQuery.of(context).size.height - 400,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (i, p) {
                        print(i);
                        model.updatePlanPickIndex(i);
                      },
                      padEnds: false,
                      scrollPhysics: const BouncingScrollPhysics(),
                    ),
                    items: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                          decoration: BoxDecorators.containerDecoration(
                              hasOutline: true,
                              outlineWidth: 2,
                              radius: 26,
                              outlineColor: XColors.primaryColor2().withOpacity(0.8)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              NormalText(
                                text: 'FREE',
                                textColor: XColors.textColor(),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              const YMargin(35),
                              ...List.generate(isBusiness ?
                              model.planModel!.plans!.business!.free!.actions!.length :
                              model.planModel!.plans!.user!.free!.actions!.length, (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: NormalText(
                                  text: isBusiness ?
                                  model.planModel!.plans!.business!.free!.actions![index] :
                                  model.planModel!.plans!.user!.free!.actions![index],
                                  textColor: XColors.textColor(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                          decoration: BoxDecorators.containerDecoration(
                              hasOutline: true,
                              outlineWidth: 2,
                              radius: 26,
                              outlineColor: XColors.primaryColor2().withOpacity(0.8)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              NormalText(
                                text: 'PRO',
                                textColor: XColors.textColor(),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              const YMargin(35),
                              ...List.generate(isBusiness ?
                              model.planModel!.plans!.business!.pro!.actions!.length :
                              model.planModel!.plans!.user!.pro!.actions!.length, (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: NormalText(
                                  text: isBusiness ?
                                  model.planModel!.plans!.business!.pro!.actions![index] :
                                  model.planModel!.plans!.user!.pro!.actions![index],
                                  textColor: XColors.textColor(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
                          decoration: BoxDecorators.containerDecoration(
                              hasOutline: true,
                              outlineWidth: 2,
                              radius: 26,
                              outlineColor: XColors.primaryColor2().withOpacity(0.8)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              NormalText(
                                text: 'ULTRA',
                                textColor: XColors.textColor(),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              const YMargin(35),
                              ...List.generate(isBusiness ?
                              model.planModel!.plans!.business!.ultra!.actions!.length :
                              model.planModel!.plans!.user!.ultra!.actions!.length, (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: NormalText(
                                  text: isBusiness ?
                                  model.planModel!.plans!.business!.ultra!.actions![index] :
                                  model.planModel!.plans!.user!.ultra!.actions![index],
                                  textColor: XColors.textColor(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            ],
                          ),
                        ),
                      )
                    ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
