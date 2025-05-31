import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance_history_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav_vmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class SuccessClaim extends StatelessWidget {
  const SuccessClaim({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: XColors.background(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetSvgImage(
                            image: 'assets/images/auto/claim_sucess.svg'),
                        YMargin(50),
                        NormalText(
                          text: 'Claim Submitted Successful!',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        YMargin(25),
                        NormalText(
                          text:
                              'Your claim with (ID: CLM12345) has been submitted and is now under review. Our team will contact you within 48 hours for the next steps.',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ContainerWidget(
                          onTap: () {
                            navigate(context, const InsuranceHistoryScreen());
                          },
                          backgroundColor: XColors.white(),
                          borderColor: XColors.highlightColor(),
                          hasBorder: true,
                          borderRadius: BorderRadius.circular(8),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          child: Center(
                              child: NormalText(
                            text: 'Track my Claim',
                            textColor: XColors.primaryColor2(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                        ),
                        const YMargin(8),
                        ContainerWidget(
                          onTap: () {
                            navigate(context, const DashBoardScreen());
                            viewModel.changeTabIndex(0);
                          },
                          backgroundColor: XColors.primaryColor2(),
                          borderRadius: BorderRadius.circular(8),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          child: Center(
                              child: NormalText(
                            text: 'Home',
                            textColor: XColors.white(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                        ),
                        const YMargin(20)
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
