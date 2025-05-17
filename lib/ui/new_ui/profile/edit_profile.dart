import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: appBarHeader(
              hasOnBack: true,
              onCloseAction: () {
                Navigator.pop(context);
              },
              appBarTitle: 'Edit profile',
            ),
            backgroundColor: XColors.background(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(''),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 5,
                          child:
                              GetSvgImage(image: 'assets/images/Camera.svg')),
                    ],
                  ),
                  const YMargin(56),
                  MainInputField(
                    label: 'First Name',
                    controller: TextEditingController(text: model.user?.firstname ?? ''),
                    isEnabled: true,
                  ),
                  const YMargin(16),
                  MainInputField(
                    label: 'Middle Name',
                    controller: TextEditingController(text: model.user?.firstname ?? ''),
                    isEnabled: true,
                  ),
                  const YMargin(16),
                  MainInputField(
                    label: 'Last Name',
                    controller: TextEditingController(text: model.user?.lastname ?? ''),
                    isEnabled: true,
                  ),
                  const YMargin(16),
                  MainInputField(
                    label: 'Phone number',
                    controller: TextEditingController(text: model.user?.email ?? ''),
                    isEnabled: false,
                  ),
                  const YMargin(16),
                  ContainerWidget(
                    onTap: () {},
                    backgroundColor: XColors.primaryColor2(),
                    borderRadius: BorderRadius.circular(26),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    child: Center(
                        child: NormalText(
                      text: 'Update profile',
                      textColor: XColors.white(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                  const YMargin(30),
                ],
              ),
            ),
          );
        },
    );
  }
}
