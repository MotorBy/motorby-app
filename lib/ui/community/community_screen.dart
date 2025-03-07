import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/community/community_viewmodel.dart';
import 'package:mobile_auto_drive/ui/community/discussions_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/shimmer_loader.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

import '../../utils/decorator.dart';
import '../../utils/margin.dart';
import '../../utils/navigator.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommunityViewModel>.reactive(
        viewModelBuilder: () => CommunityViewModel(),
        onViewModelReady: (model) async => await model.initialise(),
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: XColors.white(),
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: XColors.white(),
            surfaceTintColor: XColors.white(),
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                popView(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 21,
                  color: Colors.purpleAccent,
                ),
              ),
            ),
            title: NormalText(
              text: 'Communities',
              textColor: XColors.textColor(),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            actions: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      model.onSelectCommunity();
                      navigate(context, const DiscussionsScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NormalText(
                        text: 'Discussions',
                        textColor: XColors.textColor(),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chat_outlined,
                    size: 18,
                    color: XColors.primaryColor(),
                  ),
                  const XMargin(10)
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height - 130,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ...List.generate(
                            model.communities!.isNotEmpty ? model.communities!.length : 4,
                          (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer(
                          child: ShimmerLoading(
                            isLoading: model.isBusy,
                            child: _buildItem(
                                isLoading: model.isBusy,
                                context: context,
                                model: model,
                                index: index
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
          ),
          );
      }
    );
  }

  Widget _buildItem({
    bool? isLoading = false,
    CommunityViewModel? model,
    BuildContext? context,
    int? index
  }) {
    if (isLoading!) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context!).size.width,
          decoration: BoxDecorators.containerDecoration(
            hasOutline: true,
            outlineWidth: 0.5,
            radius: 9,
            outlineColor:
            XColors.primaryColor().withOpacity(0.1),
          ),
          child: GestureDetector(
            onTap: () {
              model!.onSelectCommunity(community: model.communities![index!]);

              navigate(
                  context,
                  DiscussionsScreen(
                    title: model.communities![index].name,
                    showPostButton: model.communities![index].userList!.contains(model.userId),
                  )
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const YMargin(5),
                  Row(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {

                            },
                            child: NormalText(
                              text: '${model!.communities![index!].discussions!.length}',
                              textColor:
                              XColors.textColor(),
                              fontSize: 11,
                            ),
                          ),
                          const XMargin(5),
                          Icon(
                            Icons.chat_outlined,
                            size: 12,
                            color: XColors.primaryColor(),
                          ),
                        ],
                      ),
                      const XMargin(15),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                            },
                            child: NormalText(
                              text: '${model.communities![index].userTotal ?? 0}',
                              textColor:
                              XColors.textColor(),
                              fontSize: 11,
                            ),
                          ),
                          const XMargin(5),
                          Icon(
                            Icons
                                .supervisor_account_outlined,
                            size: 12,
                            color: XColors.primaryColor(),
                          ),
                        ],
                      ),
                      const Expanded(child: XMargin(15)),

                      if(!model.communities![index].userList!.contains(model.userId)) ... [

                        if(model.currentIndex == index && model.busy('join') == true) ... [

                          Container(
                              width: 20,
                              height: 20,
                              child: const Loader(
                                width: 1,
                              )
                          )

                        ] else ... [

                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {

                                  if(hasUserSetup!) {

                                    model.joinCommunity(
                                        community: model.communities![index],
                                        index: index
                                    );

                                  } else {

                                    showSnackBar(
                                        context: context,
                                        message: 'Create an account or login to continue',
                                        label: 'Sign up/Login',
                                        onPressed: (){
                                          popToFirst(context);
                                          navigateReplace(context, SignInScreen());
                                        },
                                        error: true
                                    );

                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets
                                      .symmetric(
                                      vertical: 5,
                                      horizontal: 5),
                                  decoration: BoxDecorators
                                      .containerDecoration(
                                    hasOutline: true,
                                    outlineWidth: 0.5,
                                    radius: 26,
                                    outlineColor:
                                    XColors.primaryColor()
                                        .withOpacity(0.3),
                                  ),
                                  child: NormalText(
                                    text: 'Join',
                                    textColor:
                                    XColors.textColor(),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ]
                    ],
                  ),
                  const YMargin(16),
                  NormalText(
                    text: model.communities![index].name,
                    textColor: XColors.textColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  NormalText(
                    text: model.communities![index].description,
                    textColor: XColors.textColor()
                        .withOpacity(0.5),
                    fontSize: 11,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

}
