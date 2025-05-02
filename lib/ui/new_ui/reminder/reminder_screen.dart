import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: XColors.highlightColor().withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: const NormalText(
          text: 'Reminder',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        actions: [

          GestureDetector(
            onTap: () {

              modalBottomSheetMenu(
                color: Colors.white,
                isDismissible: false,
                context: context,
                height: 650,
                child: const InfoDetailsView(
                  infoType: InfoType.reminder,
                ),
              );

            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecorators.containerDecoration(
                hasOutline: true,
                outlineWidth: 1.5,
                radius: 26,
                outlineColor:
                XColors.primaryColor(),
              ),
              child: NormalText(
                text: 'Create Reminder',
                textColor: XColors.textColor(),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          const XMargin(10),

        ],
      ),
      backgroundColor: XColors.background(),
      body: Expanded(
        child: ContainerWidget(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          elevation: 0.2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          borderRadius: BorderRadius.circular(16),
          backgroundColor: XColors.white(),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      leading: const GetSvgImage(
                          image: 'assets/images/water-drop.svg'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(horizontal: -4),
                      title: NormalText(
                        text: 'Oil change',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: XColors.black(),
                      ),
                      trailing: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          NormalText(
                            text: '3:00PM',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          NormalText(
                            text: '23/04/2024',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const DividerWidget(),
                  itemCount: 4)
            ],
          ),
        ),
      ),
    );
  }
}
