import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

import '../../utils/decorator.dart';
import '../../utils/margin.dart';
import '../../utils/navigator.dart';

class DiscussionsScreen extends StatelessWidget {
  DiscussionsScreen({super.key});

  final List<Map<String, dynamic>>? communityList = [
    {
      "des": "all about bmw and events all "
          "about bmw and events all about bmw and events",
      "clicks": 4534,
      "talks": 40,
    },
    {
      "des": "Talks about how to use and fix toyotas "
          "Talks about how to use and fix toyotas Talks about how to use and fix toyotas",
      "clicks": 14534,
      "talks": 0,
    },
    {
      "des": "Find nearest mechanic shops Find nearest "
          "mechanic shops Find nearest mechanic shops",
      "clicks": 4534,
      "talks": 1 ,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XColors.white(),
      appBar: AppBar(
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
          text: 'Discussions',
          textColor: XColors.textColor(),
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  //navigate(context, const MarketPlace());
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              communityList!.length,
                  (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecorators.containerDecoration(
                    hasOutline: true,
                    outlineWidth: 0.5,
                    radius: 9,
                    outlineColor:
                    XColors.primaryColor().withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const YMargin(16),
                        NormalText(
                          text: communityList![index]['des'],
                          textColor: XColors.textColor().withOpacity(0.5),
                          maxLines: 14,
                          fontSize: 11,
                        ),
                        const YMargin(20),
                        Row(children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {

                                },
                                child: NormalText(
                                  text: '2.1k',
                                  textColor: XColors.textColor(),
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
                          const XMargin(25),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //navigate(context, const MarketPlace());
                                },
                                child: NormalText(
                                  text: '1k',
                                  textColor: XColors.textColor(),
                                  fontSize: 11,
                                ),
                              ),
                              const XMargin(5),
                              Icon(
                                Icons.thumb_up_off_alt,
                                size: 12,
                                color: XColors.primaryColor(),
                              ),
                            ],
                          ),
                        ],),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
