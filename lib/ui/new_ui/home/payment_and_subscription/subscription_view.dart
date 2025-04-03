import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/payment_and_subscription/payment_method.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/payment_and_subscription/payment_sub_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/payment_and_subscription/payment_sub_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
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
        builder: (context, model, child) {
          return Scaffold(
            appBar: InsuranceAppBar(text1: 'Subscription'),
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
                    height: 630,
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, ind) {
                          return ContainerWidget(
                            onTap: () {
                              model.updateSelectedPlan(ind);
                              navigate(context,  PaymentMethodView(amount:['0.0','5,000','12,000'][ind] ,name: ['Basic Features','Pro Features','Ultra Features'][ind],));
                              model.updateSelectedPlanDetails(['0.0','5,000','12,000'][ind], ['Basic Features','Pro Features','Ultra Features'][ind]);
                            },
                            width: 250,
                            backgroundColor: model.selectedPlan != ind
                                ? const Color(0xFFF3F3FA)
                                : XColors.primaryColor2(),
                            borderRadius: BorderRadius.circular(16),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PlanType(
                                  theme: theme,
                                  amount: ['0.0','5,000','12,000'][ind],
                                  title:  ['Free Plan','Pro Plan','Ultra Plan'][ind],
                                  color: model.selectedPlan == ind
                                      ? XColors.white()
                                      : XColors.black(),
                                ),
                                const DividerWidget(
                                  margin: EdgeInsets.symmetric(vertical: 30),
                                ),
                                NormalText(
                                  text:
                                  ['Basic Features','Pro Features','Ultra Features'][ind]
                                  ,
                                  textColor:model.selectedPlan == ind
                                      ? XColors.white()
                                      : XColors.black() ,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                const YMargin(20),
                                ...List.generate(
                                model.selectedPlan == 1
                                      ? model.proFeatures.length
                                      : model.selectedPlan != 2 ||
                                              model.selectedPlan != 1
                                          ? model.basicFeatures.length
                                          :model.ultraFeatures.length,
                                  (index) => ListTile(
                                    title: NormalText(
                                      text: model.basicFeatures[index],
                                      fontSize: 12,
                                      textColor: model.selectedPlan ==ind?XColors.white():XColors.black() ,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    leading:  Icon(
                                      Icons.check,
                                      size: 16,
                                      color: model.selectedPlan ==ind?XColors.white():XColors.black(),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                        horizontal: -4, vertical: -4),
                                  ),
                                ),
                                const YMargin(80),
                                XButton(
                                  onPressed: () {},
                                  fontWeight: FontWeight.w600,
                                  text: 'Go Ultra',
                                  buttonColor: 
                                  model.selectedPlan == ind
                                      ? XColors.white()
                                     :
                                  XColors.primaryColor2(),
                                  height: 44,
                                  radius: 8,
                                  textColor: model.selectedPlan == ind
                                      ? XColors.primaryColor2()
                                     :
                                  XColors.white(),
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
        });
  }
}
