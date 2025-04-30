import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/payment_sub_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/payment_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionView> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ViewModelBuilder<PaymentViewModel>.reactive(
        viewModelBuilder: () => PaymentViewModel(),
        onViewModelReady: (model) => {
          model.getCurrentUserPlan()
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: appBarHeader(
              hasOnBack: true,
              context: context,
              appBarTitle: 'Subscription',
            ),
            backgroundColor: XColors.background(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const YMargin(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: NormalText(
                      text: 'Choose flexible option to suit your needs',
                      textColor: XColors.black(),
                    ),
                  ),
                  const YMargin(24),
                  SizedBox(
                    height: 730,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, ind) {
                          return ContainerWidget(
                            onTap: () {
                              model.updateSelectedPlan(ind);
                              model.updateSelectedPlanDetails(
                                  model.plansModel!.payload!.subscriptionOptions!.getAmountByTier(ind),
                                  model.plansModel!.payload!.subscriptionOptions!.getTierName(ind).replaceAll(' Plan', ''));
                            },
                            width: 300,
                            backgroundColor: model.selectedPlan != ind
                                ? const Color(0xFFF3F3FA)
                                : XColors.primaryColor2(),
                            borderRadius: BorderRadius.circular(16),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PlanType(
                                  theme: theme,
                                  amount: model.plansModel!.payload!.subscriptionOptions!.getAmountByTier(ind),
                                  title:  model.plansModel!.payload!.subscriptionOptions!.getTierName(ind),
                                  color: model.selectedPlan == ind
                                      ? XColors.white()
                                      : XColors.black(),
                                ),
                                const DividerWidget(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                ),
                                NormalText(
                                  text: "${model.plansModel!.payload!.subscriptionOptions!.getTierName(ind)} Features",
                                  textColor:model.selectedPlan == ind ? XColors.white() : XColors.black() ,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                const YMargin(10),
                                ...List.generate(model.plansModel!.payload!.subscriptionOptions!.getFeaturesByTier(ind)!.length,
                                  (index) => ListTile(
                                    title: NormalText(
                                      text: model.plansModel?.payload?.subscriptionOptions?.getFeaturesByTier(ind)?.elementAt(index).simpleDescription ?? '',
                                      fontSize: 12,
                                      textColor: model.selectedPlan == ind ? XColors.white() : XColors.black(),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    leading: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: model.selectedPlan == ind ? XColors.white() : XColors.black(),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                        horizontal: -4, vertical: -4),
                                  ),
                                ),
                                const YMargin(80),
                                XButton(
                                  onPressed: () {

                                    final amount = model.plansModel?.payload?.subscriptionOptions?.getAmountByTier(ind) ?? '0.0';
                                    final name = model.plansModel?.payload?.subscriptionOptions?.getTierName(ind) ?? 'Basic';

                                    if(model.selectedPlan == ind) {

                                      model.makePayment(
                                          onInitialisedError: (e) {

                                            FloatingSnackBar.show(
                                                context,
                                                e.toString(),
                                                isError: true
                                            );

                                          },
                                          onShowPayModal: (initTrans) async {
                                            if(initTrans != null) {

                                              await PaymentService.showPaymentModal(
                                                context,
                                                transaction: initTrans,
                                              ).then((value) async {

                                                await model.verifyPayment(
                                                    onCallBack: (){

                                                      FloatingSnackBar.show(
                                                          context,
                                                          'Successfully subscribed',
                                                          isError: false
                                                      );

                                                      Navigator.pop(context, true);

                                                    },
                                                    onErrorCallBack: (){
                                                      FloatingSnackBar.show(
                                                          context,
                                                          'Error with making your subscription',
                                                          isError: true
                                                      );
                                                    }
                                                );
                                              });

                                            } else {

                                              await model.verifyPayment(
                                                  freeSub: true,
                                                  onCallBack: (){

                                                    FloatingSnackBar.show(
                                                        context,
                                                        'Successfully subscribed',
                                                        isError: false
                                                    );

                                                    Navigator.pop(context, true);

                                                  },
                                                  onErrorCallBack: (){

                                                    FloatingSnackBar.show(
                                                        context,
                                                        'Error with making your subscription',
                                                        isError: true
                                                    );

                                                  }
                                              );
                                            }
                                          }
                                      );

                                      //navigate(context, PaymentMethodView(amount: amount, name: name));

                                    } else {

                                      FloatingSnackBar.show(
                                          context,
                                          "Select a plan to continue",
                                          isError: true
                                      );

                                    }

                                  },
                                  fontWeight: FontWeight.w600,
                                  text: 'Subscribe Now',
                                  isLoading: model.isBusy,
                                  buttonColor: model.selectedPlan == ind
                                      ? XColors.white()
                                      : XColors.primaryColor2(),
                                  height: 44,
                                  radius: 8,
                                  textColor: model.selectedPlan == ind
                                      ? XColors.primaryColor2()
                                      : XColors.white(),
                                )
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        },
    );
  }
}
