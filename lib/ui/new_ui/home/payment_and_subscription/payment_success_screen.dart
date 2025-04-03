import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String>  paymantDetails =['Transaction ID ','Date','Plan Name','Duration','Renewal Date '];
    final List<String> paymentDetails2 =['#12345678','November 29, 2024 | 10:15AM','Pro Plan','1 Month Plan','Next billing on Dec 29n2024',];
    return Scaffold(
      backgroundColor: XColors.background(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetSvgImage(image: 'assets/images/auto/claim_sucess.svg'),
                    YMargin(50),
                    NormalText(
                      text: 'Payment Successful!',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    YMargin(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NormalText(
                          text: 'You subscribed for Pro-plan  ',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        NormalText(
                          text: '\u20A6',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        NormalText(
                          text: '5,000',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                ),
                const YMargin(50),
                ContainerWidget(
                  backgroundColor: XColors.white(),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 280,
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                                      
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                                title: NormalText(
                                  text: paymantDetails[index],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  textColor: XColors.black(),
                                ),
                                trailing: NormalText(
                                  text: paymentDetails2[index],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                   textColor: XColors.black(),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const DividerWidget(),
                            itemCount: paymentDetails2.length),
                      )
                    ],
                  ),
                ),
                const YMargin(50),
                XButton(
                  onPressed: () {
                    navigate(context, const DashBoardScreen());
                  },
                  height: 55,
                  buttonColor: XColors.primaryColor2(),
                  radius: 8,
                  text: 'Home',
                  textColor: XColors.white(),
                  fontWeight: FontWeight.w600,
                  textSize: 16,
                ),
                const YMargin(30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
