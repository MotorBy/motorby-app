import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/payment_and_subscription/payment_sub_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/payment_and_subscription/payment_success_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

import 'payment_sub_screen.dart';

class PaymentMethodView extends StatefulWidget {
  const PaymentMethodView(
      {super.key, required this.amount, required this.name});

  final String name;
  final dynamic amount;
  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ViewModelBuilder<PaymentViewModel>.reactive(
        viewModelBuilder: () => PaymentViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: InsuranceAppBar(text1: 'Payment Method'),
            backgroundColor: XColors.background(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YMargin(16),
                    ContainerWidget(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      backgroundColor: XColors.buttonColor(),
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PlanType(
                            theme: theme,
                            amount: '${widget.amount}',
                            title: widget.name,
                            color: XColors.white(),
                          ),
                          ContainerWidget(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            backgroundColor: Colors.transparent,
                            hasBorder: true,
                            borderColor: XColors.white(),
                            borderRadius: BorderRadius.circular(8),
                            borderThickness: 1,
                            child: NormalText(
                              text: 'Change plan',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: XColors.white(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const YMargin(30),
                    const Row(
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model.paymentMethod2.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              model.updateSelectedPaymentMethod(index);
                            },
                            trailing: ContainerWidget(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: XColors.white(),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: model.selectedPaymentMethod == index
                                        ? 0
                                        : 1,
                                    color: const Color(0xFFD0D5DD)),
                              ),
                              child: model.selectedPaymentMethod == index
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                            ),
                            leading: GetSvgImage(
                                image: model.paymentMethod2[index].img),
                            title: NormalText(
                                text: model.paymentMethod2[index].details),
                          );
                        },
                      ),
                    ),
                    const YMargin(30),
                    ContainerWidget(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => UpgradeCard(
                            viewModel: model,
                          ),
                        );
                      },
                      borderColor: Colors.grey,
                      borderRadius: BorderRadius.circular(7),
                      hasBorder: true,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NormalText(
                            text: 'Update new card',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            textColor: XColors.black().withOpacity(0.5),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 17,
                            color: XColors.black().withOpacity(0.5),
                          )
                        ],
                      ),
                    ),
                    const YMargin(21),
                    XButton(
                      onPressed: () {
                        navigate(context, const PaymentSuccessView());
                      },
                      height: 55,
                      buttonColor: XColors.primaryColor2(),
                      radius: 8,
                      text: 'Pay Now',
                      textColor: XColors.white(),
                      fontWeight: FontWeight.w600,
                      textSize: 16,
                    ),
                    const YMargin(30),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class UpgradeCard extends StatelessWidget {
  const UpgradeCard({Key? key, required this.viewModel}) : super(key: key);

  final PaymentViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentViewModel>.reactive(
        viewModelBuilder: () => viewModel,
        disposeViewModel: false,
        builder: (context, model, child) {
          return Container(
            height: 580,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: XColors.background(),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Update new card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const YMargin(30),
                  buildField(
                    context,
                    viewModel,
                    'Card Number',
                    'Type here',
                    viewModel.cardNumberController,
                    () {},
                    false,
                    const SizedBox.shrink(),
                  ),
                  const YMargin(15),
                  buildField(
                    context,
                    viewModel,
                    'Card Holder Name',
                    'Type here',
                    viewModel.cardHolderController,
                    () {},
                    false,
                    const SizedBox.shrink(),
                  ),
                  const YMargin(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: buildField(
                          context,
                          viewModel,
                          'Expiry Date',
                          '07/27',
                          viewModel.cardHolderController,
                          () {},
                          false,
                          const SizedBox.shrink(),
                        ),
                      ),
                      const XMargin(22),
                      Expanded(
                        child: buildField(
                          context,
                          viewModel,
                          'CVV',
                          '293',
                          viewModel.cardHolderController,
                          () {},
                          false,
                          const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                  const YMargin(16),
                  GestureDetector(
                    onTap: (){
                      viewModel.saveCard();
                    },
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          Icon(
                            viewModel.isCardSaved
                                ? Icons.circle_outlined
                                : Icons.check_circle,
                            color: viewModel.isCardSaved
                                ? Colors.grey.shade200
                                : Colors.green,
                                size: 30,
                          ),
                          const XMargin(6),
                          NormalText(
                            text: 'Save Card Information, its confidential ',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: XColors.black(),
                          ),
                        ],
                      ),
                    ),
                  ),
                 const YMargin(35),
                 XButton(onPressed: (){},
                 radius: 8,
                 text: 'Save',
                 fontWeight: FontWeight.w600,
                 textSize: 16,
                 height: 55,
                 textColor: XColors.white(),
                 buttonColor: XColors.primaryColor2(),
                 ),
                ],
              ),
            ),
          );
        });
  }
}

Widget buildField(
    BuildContext context,
    PaymentViewModel model,
    String title,
    String label,
    TextEditingController controller,
    Function() function,
    bool isReadOnly,
    Widget? suffixIcon,
    [int? maxLine,
    Color? background]) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      NormalText(
        text: title,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      const SizedBox(height: 8),
      TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
          ),
          hintText: label,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: Color(0xFFD0D5DD),
            ),
          ),
          filled: true,
          fillColor: background ?? XColors.white(),
        ),
        maxLines: maxLine,
        readOnly: isReadOnly,
        controller: controller,
        onTap: function,
      ),
    ],
  );
}
