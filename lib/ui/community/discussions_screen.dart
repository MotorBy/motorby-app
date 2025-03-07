import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_auto_drive/models/community_model.dart';
import 'package:mobile_auto_drive/models/discussion_model.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/community/community_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

import '../../utils/decorator.dart';
import '../../utils/margin.dart';
import '../../utils/navigator.dart';
import '../../widgets/inputfield.dart';
import '../../widgets/show_bottomsheet.dart';

class DiscussionsScreen extends StatelessWidget {
  const DiscussionsScreen({super.key, this.title, this.showPostButton = true});

  final String? title;
  final bool? showPostButton;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommunityViewModel>.reactive(
        viewModelBuilder: () => CommunityViewModel(),
        disposeViewModel: false,
        onViewModelReady: (model) async => await model.getDiscussions(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: XColors.white(),
            floatingActionButton: showPostButton! ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    modalBottomSheetMenu(
                        context: context,
                        isDismissible: false,
                        child: MakeContentView(
                          communityViewModel: model,
                          ctx: context,
                        ),
                    );
                  },
                  child: Container(
                    height: 56,
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecorators.containerDecoration(
                      hasOutline: false,
                      color: XColors.primaryColor(),
                      outlineWidth: 2,
                      radius: 32,
                    ),
                    child: NormalText(
                      text: 'Post',
                      textColor: XColors.white(),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ) : null,
            appBar: AppBar(
              backgroundColor: XColors.white(),
              surfaceTintColor: XColors.white(),
              automaticallyImplyLeading: false,
              titleSpacing: 4,
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
                text: title ?? 'Discussions',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height - 130,
                child: !model.isBusy
                    ? model.discussions.isNotEmpty
                        ? SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(
                                  model.discussions.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              NormalText(
                                                text: model.discussions[index].user != null ? '${model.discussions[index].user!.fullname}' : 'user',
                                                textColor: XColors.textColor().withOpacity(0.6),
                                                maxLines: 2,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                              const YMargin(10),
                                              NormalText(
                                                text: model
                                                    .discussions[index].content,
                                                textColor: XColors.textColor(),
                                                maxLines: 14,
                                                fontSize: 13,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 15,),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: (){
                                                        model.setCurrentDiscussion(currentIndex: index);
                                                        modalBottomSheetMenu(
                                                            context: context,
                                                            child: CommentsView(
                                                              model: model,
                                                              discussion: model.discussions[index],
                                                            ),
                                                            color: XColors.background()
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          NormalText(
                                                            text: '${model.discussions[index].comments!.length}',
                                                            textColor:
                                                                XColors.textColor(),
                                                            fontSize: 13,
                                                          ),
                                                          const XMargin(5),
                                                          Icon(
                                                            Icons.chat_outlined,
                                                            size: 13,
                                                            color: XColors.primaryColor(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const XMargin(25),
                                                    // Row(
                                                    //   children: [
                                                    //     GestureDetector(
                                                    //       onTap: () {
                                                    //         //navigate(context, const MarketPlace());
                                                    //       },
                                                    //       child: NormalText(
                                                    //         text: '1k',
                                                    //         textColor:
                                                    //             XColors.textColor(),
                                                    //         fontSize: 11,
                                                    //       ),
                                                    //     ),
                                                    //     const XMargin(5),
                                                    //     Icon(
                                                    //       Icons.thumb_up_off_alt,
                                                    //       size: 12,
                                                    //       color:
                                                    //           XColors.primaryColor(),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 0.7,
                                          color: XColors.primaryColor().withOpacity(0.1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        )
                        : Column(
                            children: [
                              const YMargin(56),
                              NormalText(
                                text:
                                    'No discussions here yet',
                                textColor: XColors.textColor(),
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ],
                          )
                    : Container(
                      width: MediaQuery.of(context).size.width,
                      child: const Loader(width: 5,)
                ),
            ),
          );
        },
    );
  }
}

class CommentsView extends StatelessWidget {
  CommentsView({super.key, this.discussion, this.model});

  final CommunityViewModel? model;
  final Discussion? discussion;

  TextEditingController commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommunityViewModel>.reactive(
        viewModelBuilder: () => model!,
        disposeViewModel: false,
        builder: (context, model, child) {
        return Container(
          height: 580,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const YMargin(25),
              NormalText(
                text: 'Comments',
                textColor: XColors.primaryColor2(),
                maxLines: 2,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              const YMargin(25),
              Container(
                height: 350,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ...List.generate(
                        model.currentDiscussion!.comments!.reversed.toList().length,
                        (index) => Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(
                                    text: model.currentDiscussion!.comments!.reversed.toList()[index].user != null ? model.currentDiscussion!.comments!.reversed.toList()[index].user!.fullname : 'user',
                                    textColor: XColors.textColor().withOpacity(0.6),
                                    maxLines: 2,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  const YMargin(10),
                                  NormalText(
                                    text: model.currentDiscussion!.comments!.reversed.toList()[index].comment,
                                    textColor: XColors.textColor(),
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 0.7,
                              color: XColors.primaryColor().withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const YMargin(40),

              if(hasUserSetup!) ... [
                Row(
                  children: [
                    Expanded(
                      child: MainInputField(
                        label: "drop comment",
                        isEnabled: true,
                        controller: commentTextController,
                        onChanged: (s){
                          model.onContentUpdate(s: s, isComment: true);
                        },
                      ),
                    ),
                    const XMargin(10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  model.busy('comment') == true ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Loader(
                          strokeWidth: 5,
                        ),
                      ) : GestureDetector(
                          onTap: () async {
                            if(model.commentText!.isNotEmpty || model.busy('comment') != true) {
                              await model.addComments(
                                  discussionId: discussion!.id,
                                  onCallBack: (){
                                    commentTextController.text = '';
                                  },
                                  onErrorCallBack: (e){
                                    showSnackBar(
                                        context: context,
                                        error: true,
                                        message: e
                                    );
                                  }
                              );
                            }
                          },
                          child: RotationTransition(
                              turns: const AlwaysStoppedAnimation(-35/ 360),
                              child: Icon(Icons.send_rounded, color: XColors.primaryColor(),)
                          )
                      ),
                    )
                  ],
                ),
              ],

              const YMargin(40),
            ],
          ),
        );
      }
    );
  }
}

class MakeContentView extends StatelessWidget {
  const MakeContentView({super.key, this.communityViewModel, this.ctx});

  final CommunityViewModel? communityViewModel;
  final BuildContext? ctx;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommunityViewModel>.reactive(
        viewModelBuilder: () => communityViewModel!,
        disposeViewModel: false,
        builder: (context, model, child) {
        return Container(
          color: XColors.white(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const YMargin(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        popView(context);
                      },
                      child: NormalText(
                        text: 'Close',
                        textColor: XColors.textColor().withOpacity(0.3),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const XMargin(5),
                    const Icon(Icons.close_rounded, size: 31,),
                  ],
                ),
                const YMargin(20),
                NormalText(
                  text:
                  'You can freely drop your discussion here \nand let others comment on it.',
                  textColor: XColors.black(),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                const YMargin(30),
                MainInputField(
                  label: "",
                  hint: "Type here",
                  isEnabled: true,
                  onChanged: (s) {
                    model.onContentUpdate(s: s);
                  },
                  maxLines: 5,
                ),
                const YMargin(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    XButton(
                      onPressed: () {
                        if(hasUserSetup!) {

                          model.addDiscussions(onCallBack: (){
                            popView(context);
                          });

                        } else {
                          popView(ctx!);
                          showSnackBar(
                              context: ctx!,
                              message: 'Create an account or login to continue',
                              label: 'Sign up/Login',
                              onPressed: (){
                                popToFirst(ctx!);
                                navigateReplace(ctx!, SignInScreen());
                              },
                              error: true
                          );

                        }
                      },
                      text: 'Drop',
                      isLoading: model.busy('discussion'),
                      buttonColor: model.contentText!.isNotEmpty ? XColors.primaryColor() : XColors.primaryColor().withOpacity(0.3),
                      width: 120,
                    ),
                  ],
                ),
                const YMargin(30),
              ],
            ),
          ),
        );
      }
    );
  }

}
