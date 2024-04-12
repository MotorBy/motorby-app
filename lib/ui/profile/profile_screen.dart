import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/marketplace_screen.dart';
import 'package:mobile_auto_drive/ui/profile/plan_subscription_screen.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        onViewModelReady: (model) async => await model.init(),
        disposeViewModel: false,
        builder: (context, model, child) {
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
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: (){
              //         navigate(context, const MarketPlace());
              //       },
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: NormalText(
              //           text:'Events',
              //           textColor: XColors.textColor(),
              //           fontSize: 13,
              //         ),
              //       ),
              //     ),
              //     Icon(Icons.event_note_rounded, size: 18, color: XColors.primaryColor(),),
              //     const XMargin(10)
              //   ],
              // )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
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
                            child: !model.busy('user_type_loading') ? NormalText(
                              text: 'as ${model.user!.userType!.toLowerCase()}',
                              textColor: XColors.textColor(),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ) : const Loader(
                              height: 20,
                              width: 20,
                            ),
                          ),
                          const XMargin(10),
                          GestureDetector(
                            onTap: (){
                              modalBottomSheetMenu(
                                  color: Colors.white,
                                  context: context,
                                  child: MoreProfileActionPicks(
                                    profileViewModel: model,
                                  ),
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
                      NormalText(
                        text: model.user != null ? model.user!.fullname : "",
                        textColor: XColors.textColor(),
                        fontSize: 12,
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
                            text: model.user != null ? model.user!.email : '',
                            textColor: XColors.textColor(),
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const YMargin(70),
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
                                text: '${model.user!.statsDetails!.addCars ?? 0}',
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
                                text:'${model.user!.statsDetails!.sales ?? 0}',
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
                                text:'${model.user!.statsDetails!.sold ?? 0}',
                                textColor: XColors.textColor(),
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if(model.user!.businessDetails != null) ... [
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
                                  text:'${model.user!.statsDetails!.shops ?? 0}',
                                  textColor: XColors.textColor(),
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const YMargin(30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.all(8),
                      //   decoration: BoxDecorators.containerDecoration(
                      //       hasOutline: true,
                      //       outlineWidth: 1,
                      //       radius: 16,
                      //       outlineColor: Colors.purpleAccent.withOpacity(0.1)
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           NormalText(
                      //             text: 'Total set budget',
                      //             textColor: XColors.textColor().withOpacity(0.5),
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 12,
                      //           ),
                      //           const XMargin(30),
                      //           Container(
                      //             padding: const EdgeInsets.all(3),
                      //             decoration: BoxDecorators.containerDecoration(
                      //                 hasOutline: true,
                      //                 outlineWidth: 2,
                      //                 radius: 26,
                      //                 outlineColor: Colors.purpleAccent.withOpacity(0.2)
                      //             ),
                      //             child: const Icon(Icons.edit, color: Colors.purpleAccent, size: 12,),
                      //           ),
                      //         ],
                      //       ),
                      //       const YMargin(10),
                      //       NormalText(
                      //         text: 'N 0,0',
                      //         textColor: XColors.textColor(),
                      //         fontWeight: FontWeight.w700,
                      //         fontSize: 21,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const YMargin(15),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 1,
                            radius: 16,
                            outlineColor: Colors.purpleAccent.withOpacity(0.1)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                NormalText(
                                  text: 'Current plan',
                                  textColor: XColors.textColor().withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                const XMargin(30),
                                GestureDetector(
                                  onTap: (){
                                    if(model.planModel != null) {
                                      navigate(context, PlanSubscriptionScreen(profileViewModel: model,));
                                    }
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const YMargin(10),
                            NormalText(
                              text: model.userPlan!.toUpperCase(),
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
                            outlineWidth: 1,
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
                                  textColor: XColors.textColor().withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
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
                                        "Current plan",],
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
                                      fontWeight: FontWeight.w500,
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
                      const YMargin(15),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecorators.containerDecoration(
                            hasOutline: true,
                            outlineWidth: 1,
                            radius: 16,
                            outlineColor: Colors.purpleAccent.withOpacity(0.1)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                NormalText(
                                  text: 'Referral code',
                                  textColor: XColors.textColor().withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            const YMargin(10),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                child: NormalText(
                                  text: model.userModel!.payload!.referralProfile!.referralCode ?? '',
                                  textColor: XColors.textColor(),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const YMargin(7),
                            const Divider(thickness: 0.4,),
                            const YMargin(10),
                            Row(
                              children: [
                                NormalText(
                                  text: 'Earnings',
                                  textColor: XColors.textColor().withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            const YMargin(10),
                            Container(
                              padding: const EdgeInsets.all(3),
                              child: NormalText(
                                text: model.userModel!.payload!.referralProfile!.totalEarnings.toString() ?? '0',
                                textColor: XColors.textColor(),
                                fontWeight: FontWeight.w700,
                                fontSize: 19,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class CarBudgetAmountInput extends StatelessWidget {
  const CarBudgetAmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Column(
        children: [

        ],
      ),
    );
  }
}

class BusinessSetupView extends StatelessWidget {
  BusinessSetupView({super.key, this.viewModel});

  final ProfileViewModel? viewModel;

  final TextEditingController btypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => viewModel!,
        disposeViewModel: false,
        builder: (context, model, child) {
          return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        popView(context);
                      },
                        child: const Icon(Icons.close_rounded)
                    ),
                  )
              ],),
              const YMargin(15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    text: model.user!.businessDetails == null ? 'You have not yet setup your business profile' : 'You can make updates to your business profile here',
                    textColor: XColors.textColor(),
                    fontSize: 13,
                  ),
                  const YMargin(35),
                  MkInputField2(
                    label: "Business name",
                    initialValue: model.user!.businessDetails == null ? '' : model.user!.businessDetails!.businessName!,
                    isEnabled: true,
                    onChanged: (s) {
                      viewModel!.setUserTypeDetails(
                          value: s,
                          type: 'name',
                          key: 'business'
                      );
                    },
                  ),
                  const YMargin(15),
                  MkInputField2(
                    label: "Business Reg. No",
                    keyboard: TextInputType.number,
                    isEnabled: true,
                    onChanged: (s) {
                      viewModel!.setUserTypeDetails(
                          value: s,
                          type: 'reg_no',
                          key: 'business'
                      );
                    },
                  ),
                  const YMargin(15),
                  MkInputField2(
                    label: "Business contact",
                    isEnabled: true,
                    onChanged: (s) {
                      viewModel!.setUserTypeDetails(
                          value: s,
                          type: 'bcontact',
                          key: 'business'
                      );
                    },
                  ),
                  const YMargin(20),
                  MkInputField2(
                    label: "Business type",
                    isEnabled: false,
                    controller: btypeController,
                    suffixIcon: GestureDetector(
                      onTap: (){
                        listHelperPicker(
                          height: 210,
                          context: context,
                          title: 'Business type',
                          listString: [
                            "Dealership",
                            "Repair",
                            "Servicing",
                            "Detailing",
                            "Part sales",
                            "Rental",
                            "Insurance",],
                          selected: (s) {
                            btypeController.text = s!;
                            viewModel!.setUserTypeDetails(
                                value: s,
                                type: 'btype',
                                key: 'business'
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                    ),
                  ),
                  // const YMargin(15),
                  // const MkInputField2(
                  //   label: "Business bank account",
                  //   isEnabled: true,
                  // ),
                  // const YMargin(15),
                  // MkInputField2(
                  //   label: "Business bank name",
                  //   keyboard: TextInputType.number,
                  //   isEnabled: true,
                  //   onChanged: (s) {
                  //   },
                  // ),
                ],
              ),
              const YMargin(35),
              XButton(
                onPressed: !viewModel!.isBusy ? (){

                  viewModel!.updateUserTypeProfile(
                      onCallBack: (){
                        popView(context);
                        popView(context);
                      },
                      onErrorCallBack: (){

                      }
                  );

                } : (){},
                text: model.user!.businessDetails == null ? "Create" : "Update",
                height: 56,
                isLoading: model.busy('user_type_loading'),
                textColor: Colors.white,
                buttonColor: XColors.primaryColor(),
                progressColor: Colors.white,
                radius: 26,
                width: SizeConfig().sw(400) as double?,
              ),
              const YMargin(15),
            ],
          ),
        );
      }
    );
  }

}

class MoreProfileActionPicks extends StatelessWidget {
  const MoreProfileActionPicks({super.key, this.profileViewModel});

  final ProfileViewModel? profileViewModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => profileViewModel!,
        disposeViewModel: false,
        builder: (context, model, child) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const YMargin(25),
                  GestureDetector(
                    onTap: () {

                      if(profileViewModel!.user!.businessDetails == null) {

                        modalBottomSheetMenu(
                          color: Colors.white,
                          context: context,
                          child: BusinessSetupView(
                            viewModel: profileViewModel!,
                          ),
                        );

                      } else {

                        profileViewModel!.updateUserTypeProfile(
                          updateTo: profileViewModel!.user!.userType == 'USER' ? 'BUSINESS' : 'USER',
                          onCallBack: (){
                            popView(context);
                          }
                        );

                      }

                    },
                    child: NormalText(
                      text:'Switch to ${profileViewModel!.user!.userType == 'USER' ? 'Business' : 'User'}',
                      textColor: XColors.textColor(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if(model.hasBusiness!) ... [
                    const YMargin(45),
                    GestureDetector(
                      onTap: (){
                        modalBottomSheetMenu(
                          color: Colors.white,
                          context: context,
                          child: BusinessSetupView(
                            viewModel: profileViewModel!,
                          ),
                        );
                      },
                      child: NormalText(
                        text:'Update Business',
                        textColor: XColors.textColor(),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const YMargin(45),
                  NormalText(
                    text:'Reset Budget',
                    textColor: XColors.textColor(),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  const YMargin(45),
                  GestureDetector(
                    onTap: (){
                      navigate(context, SignInScreen());
                    },
                    child: NormalText(
                      text:'Logout',
                      textColor: XColors.textColor(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const YMargin(45),
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
    );
  }
}
