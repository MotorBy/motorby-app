import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/payment_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/payment_and_subscription/subscription_view.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/divider_widget.dart';
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
  String _formatDateFriendly(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  int _getDaysUntilNextPayment(DateTime startDate) {
    final now = DateTime.now();
    final nextPaymentDate = startDate.add(const Duration(days: 30));
    final daysRemaining = nextPaymentDate.difference(now).inDays;
    return daysRemaining > 0 ? daysRemaining : 0;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ViewModelBuilder<PaymentViewModel>.reactive(
      viewModelBuilder: () => PaymentViewModel(),
      onViewModelReady: (model) => {model.getCurrentUserPlan()},
      builder: (context, model, child) {
        return Scaffold(
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Payment and Subscriptions',
          ),
          backgroundColor: XColors.background(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: model.isBusy
                ? const Center(child: Loader())
                : SingleChildScrollView(
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

                              if(false) ... [ /////will revisit this later for better improvements
                                // Subscription Status and Dates
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        // Status Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: model.currentSubscription
                                                ?.isActive ==
                                                true
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.orange.withOpacity(0.1),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                model.currentSubscription
                                                    ?.isActive ==
                                                    true
                                                    ? Icons.check_circle
                                                    : Icons.info,
                                                size: 14,
                                                color: model.currentSubscription
                                                    ?.isActive ==
                                                    true
                                                    ? Colors.green
                                                    : Colors.orange,
                                              ),
                                              const XMargin(4),
                                              NormalText(
                                                text: model.currentSubscription
                                                    ?.isActive ==
                                                    true
                                                    ? 'Active'
                                                    : 'Inactive',
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                textColor: model
                                                    .currentSubscription
                                                    ?.isActive ==
                                                    true
                                                    ? Colors.green
                                                    : Colors.orange,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (model
                                            .currentSubscription?.startDate !=
                                            null) ...[
                                          const XMargin(8),
                                          // Start Date
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color:
                                              Colors.black.withOpacity(0.05),
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  size: 14,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                                const XMargin(4),
                                                NormalText(
                                                  text:
                                                  'Started ${_formatDateFriendly(model.currentSubscription!.startDate!)}',
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  textColor: Colors.black
                                                      .withOpacity(0.7),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ]),
                                      if (model.currentSubscription?.isActive ==
                                          true &&
                                          model.currentSubscription?.startDate !=
                                              null) ...[
                                        const YMargin(8),
                                        // Payment Reminder
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: _getDaysUntilNextPayment(model
                                                .currentSubscription!
                                                .startDate!) <=
                                                7
                                                ? Colors.amber.withOpacity(0.1)
                                                : Colors.blue.withOpacity(0.1),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                _getDaysUntilNextPayment(model
                                                    .currentSubscription!
                                                    .startDate!) <=
                                                    7
                                                    ? Icons.notification_important
                                                    : Icons.schedule,
                                                size: 16,
                                                color: _getDaysUntilNextPayment(model
                                                    .currentSubscription!
                                                    .startDate!) <=
                                                    7
                                                    ? Colors.amber
                                                    : Colors.blue,
                                              ),
                                              const XMargin(8),
                                              Expanded(
                                                child: NormalText(
                                                  text: _getDaysUntilNextPayment(model
                                                      .currentSubscription!
                                                      .startDate!) <=
                                                      7
                                                      ? 'Your subscription will renew in ${_getDaysUntilNextPayment(model.currentSubscription!.startDate!)} days'
                                                      : 'Next payment due in ${_getDaysUntilNextPayment(model.currentSubscription!.startDate!)} days',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  textColor: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else if (model
                                          .currentSubscription?.tier ==
                                          'Free') ...[
                                        const YMargin(8),
                                        // Upgrade Promotion
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: XColors.primaryColor2()
                                                .withOpacity(0.1),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 16,
                                                color: XColors.primaryColor2(),
                                              ),
                                              const XMargin(8),
                                              Expanded(
                                                child: NormalText(
                                                  text:
                                                  'Upgrade to unlock premium features and enhance your experience!',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  textColor: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ]),
                              ],

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
                                          context, const SubscriptionView(),
                                          onCallBack: (value) {
                                        if (value != null) {
                                          model.getCurrentUserPlan();
                                        }
                                      });
                                    },
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
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
