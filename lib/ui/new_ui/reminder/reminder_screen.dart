import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
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
      appBar: appBarHeader(
        hasOnBack: false,
        context: context,
        appBarTitle: 'Reminder',
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
