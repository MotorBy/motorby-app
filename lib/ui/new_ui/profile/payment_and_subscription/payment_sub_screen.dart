import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/payment_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/subscription_view.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class PaymentAndSubscriptionScreen extends StatefulWidget {
  const PaymentAndSubscriptionScreen({super.key});

  @override
  State<PaymentAndSubscriptionScreen> createState() =>
      _PaymentAndSubscriptionScreenState();
}

class _PaymentAndSubscriptionScreenState
    extends State<PaymentAndSubscriptionScreen> {
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
            appBar: InsuranceAppBar(text1: 'Payment and Subscriptions'),
            backgroundColor: XColors.background(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: model.isBusy ? const Center(child: Loader()) : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YMargin(24),
                    const NormalText(
                      text: 'Current Plan',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    const YMargin(12),
                    ContainerWidget(
                      backgroundColor: const Color(0xFFF3F3FA),
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PlanType(
                                theme: theme,
                                amount: model.currentSubscription?.tier == null ? '0.00' : model.currentTierAmount,
                                title: model.currentSubscription?.tier == null ? 'Free Plan' : '${model.currentSubscription!.tier!} Plan',
                                color: model.currentSubscription?.isActive == true ? XColors.primaryColor2() : null,
                              ),
                              ContainerWidget(
                                onTap: () {

                                  navigateWithCallBack(
                                      context,
                                      const SubscriptionView(),
                                      onCallBack: (value) {
                                        if (value != null) {
                                          model.getCurrentUserPlan();
                                        }
                                      }
                                  );

                                },
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                borderColor: XColors.highlightColor(),
                                borderThickness: 1,
                                hasBorder: true,
                                borderRadius: BorderRadius.circular(8),
                                child: Center(
                                    child: NormalText(
                                  text: 'Subscriptions',
                                  textColor: XColors.primaryColor2(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                )),
                              ),
                            ],
                          ),
                          const DividerWidget(
                            margin: EdgeInsets.symmetric(vertical: 30),
                          ),
                          const NormalText(
                            text: 'All Features',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const YMargin(20),
                          Wrap(
                            spacing: 3.0,
                            runSpacing: 2.0,
                            children: List.generate(
                              model.currentSubscription?.features?.length ?? 0,
                              (index) => ListTile(
                                title: NormalText(
                                  text: model.currentSubscription?.features?[index].simpleDescription ?? '',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                leading: const Icon(
                                  Icons.check,
                                  size: 16,
                                ),
                                contentPadding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const YMargin(32),
                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     NormalText(
                    //       text: 'My Cards',
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 18,
                    //       textColor: Color(0xFF98A2B3),
                    //     ),
                    //     NormalText(
                    //       text: 'Update New Card',
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ],
                    // ),
                    // const YMargin(32),
                    // SizedBox(
                    //   height: 230,
                    //   child: ListView.builder(
                    //     itemCount: model.paymentMethod.length,
                    //     itemBuilder: (context, index) {
                    //       return ListTile(
                    //         onTap: () {
                    //           model.updateSelectedPaymentMethod(index);
                    //         },
                    //         visualDensity: const VisualDensity(
                    //           horizontal: -4,
                    //         ),
                    //         leading: GetSvgImage(
                    //             image: model.paymentMethod[index].img),
                    //         title: NormalText(
                    //             text: model.paymentMethod[index].details),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}

class PlanType extends StatelessWidget {
  const PlanType({
    super.key,
    required this.theme,
    this.color,
    required this.title,
    required this.amount,
  });

  final ThemeData theme;
  final Color? color;
  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: title,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          textColor: color ?? XColors.black(),
        ),
        const YMargin(24),
        RichText(
          text: TextSpan(
            text: '\u20A6',
            style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold, color: color ?? XColors.black()),
            children: <TextSpan>[
              TextSpan(
                text: amount,
                style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color ?? XColors.black()),
              ),
              TextSpan(
                text: ' /month',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: color ?? XColors.black(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
