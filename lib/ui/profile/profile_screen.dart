import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/marketplace_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XColors.white(),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            popView(context);
          },
          child: const Icon(Icons.arrow_back_ios_rounded, size: 21, color: Colors.purpleAccent,),
        ),
        actions: [Row(
          children: [
            GestureDetector(
              onTap: (){
                navigate(context, const MarketPlace());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NormalText(
                  text:'Marketplace',
                  textColor: XColors.textColor(),
                  fontSize: 13,
                ),
              ),
            ),
            Icon(Icons.shopping_basket, size: 18, color: XColors.primaryColor(),),
            const XMargin(10)
          ],
        ),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  navigate(context, const MarketPlace());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NormalText(
                    text:'Events',
                    textColor: XColors.textColor(),
                    fontSize: 13,
                  ),
                ),
              ),
              Icon(Icons.event_note_rounded, size: 18, color: XColors.primaryColor(),),
              const XMargin(10)
            ],
          )],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.account_circle_outlined, size: 38, color: Colors.purpleAccent,),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecorators.containerDecoration(
                          hasOutline: true,
                          outlineWidth: 2,
                          radius: 26,
                          outlineColor: Colors.purpleAccent.withOpacity(0.2)
                      ),
                      child: NormalText(
                        text: 'As User',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const XMargin(10),
                    GestureDetector(
                      onTap: (){
                        modalBottomSheetMenu(
                            color: Colors.white,
                            context: context,
                            child: const MoreProfileActionPicks(),
                        );

                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 2,
                            radius: 26,
                            outlineColor: Colors.purpleAccent.withOpacity(0.2)
                        ),
                        child: const Icon(Icons.more_vert_rounded, size: 15,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalText(
                  text:'Full name',
                  textColor: XColors.textColor(),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                Row(
                  children: [
                    NormalText(
                      text:'Emmanuel',
                      textColor: XColors.textColor(),
                      fontSize: 12,
                    ),
                    const XMargin(10),
                    NormalText(
                      text:'Emmanuel',
                      textColor: XColors.textColor(),
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalText(
                  text:'Email',
                  textColor: XColors.textColor(),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                Row(
                  children: [
                    NormalText(
                      text:'emmanuel.a.oluwatobi@gmail.com',
                      textColor: XColors.textColor(),
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    NormalText(
                      text:'Cars',
                      textColor: XColors.textColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    Row(
                      children: [
                        NormalText(
                          text:'0',
                          textColor: XColors.textColor(),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    NormalText(
                      text:'Sales',
                      textColor: XColors.textColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    Row(
                      children: [
                        NormalText(
                          text:'0',
                          textColor: XColors.textColor(),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    NormalText(
                      text:'Sold',
                      textColor: XColors.textColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    Row(
                      children: [
                        NormalText(
                          text:'0',
                          textColor: XColors.textColor(),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    NormalText(
                      text:'Shops',
                      textColor: XColors.textColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    Row(
                      children: [
                        NormalText(
                          text:'0',
                          textColor: XColors.textColor(),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecorators.containerDecoration(
                      hasOutline: true,
                      outlineWidth: 2,
                      radius: 16,
                      outlineColor: Colors.purpleAccent.withOpacity(0.1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          NormalText(
                            text: 'Total set budget',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          const XMargin(30),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecorators.containerDecoration(
                                hasOutline: true,
                                outlineWidth: 2,
                                radius: 26,
                                outlineColor: Colors.purpleAccent.withOpacity(0.2)
                            ),
                            child: const Icon(Icons.edit, color: Colors.purpleAccent, size: 12,),
                          ),
                        ],
                      ),
                      const YMargin(10),
                      NormalText(
                        text: 'N 0,0',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                      ),
                    ],
                  ),
                ),
                const YMargin(15),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecorators.containerDecoration(
                      hasOutline: true,
                      outlineWidth: 2,
                      radius: 16,
                      outlineColor: Colors.purpleAccent.withOpacity(0.1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          NormalText(
                            text: 'Current tier',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          const XMargin(30),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecorators.containerDecoration(
                                hasOutline: true,
                                outlineWidth: 2,
                                radius: 26,
                                outlineColor: Colors.purpleAccent.withOpacity(0.2)
                            ),
                            child: NormalText(
                              text: 'Buy',
                              textColor: XColors.textColor(),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const YMargin(10),
                      NormalText(
                        text: 'Tier Zero',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
                const YMargin(15),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecorators.containerDecoration(
                      hasOutline: true,
                      outlineWidth: 2,
                      radius: 16,
                      outlineColor: Colors.purpleAccent.withOpacity(0.1)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          NormalText(
                            text: 'Payment method',
                            textColor: XColors.textColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          const XMargin(30),
                          GestureDetector(
                            onTap: (){
                              listHelperPicker(
                                height: 200,
                                context: context,
                                title: 'Payment option',
                                listString: [
                                  "Credit card",
                                  "Bank Transfer",
                                  "Current tier",],
                                selected: (s) {

                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecorators.containerDecoration(
                                  hasOutline: true,
                                  outlineWidth: 2,
                                  radius: 26,
                                  outlineColor: Colors.purpleAccent.withOpacity(0.2)
                              ),
                              child: NormalText(
                                text: 'Change',
                                textColor: XColors.textColor(),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const YMargin(10),
                      NormalText(
                        text: 'Bank Transfer',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CarBudgetAmountInput extends StatelessWidget {
  const CarBudgetAmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

        ],
      ),
    );
  }
}

class MoreProfileActionPicks extends StatelessWidget {
  const MoreProfileActionPicks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const YMargin(25),
              NormalText(
                text:'Switch to Business',
                textColor: XColors.textColor(),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const YMargin(25),
              NormalText(
                text:'Reset Budget',
                textColor: XColors.textColor(),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const YMargin(25),
              GestureDetector(
                onTap: (){
                  navigate(context, const SignInScreen());
                },
                child: NormalText(
                  text:'Logout',
                  textColor: XColors.textColor(),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const YMargin(25),
              NormalText(
                text: 'Delete account',
                textColor: XColors.textColor(),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const YMargin(25),
            ],
          ),
        ),
      ],
    );
  }
}
