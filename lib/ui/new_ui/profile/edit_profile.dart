import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance.dart';
import 'package:mobile_auto_drive/ui/profile/profile_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
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
              onCloseAction: (){
              },
              appBarTitle: 'Edit profile',
            ),
            backgroundColor: XColors.background(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                  const YMargin(24),
                  buildField(
                    context,
                    model,
                    'Email address',
                    'Email address',
                    TextEditingController(text: model.user?.email ?? ''),
                    () {},
                    false,
                    const SizedBox.shrink(),
                  ),
                  const YMargin(16),
                  buildField(
                    context,
                    model,
                    'First Name',
                    'First Name',
                    TextEditingController(text: model.user?.firstname ?? ''),
                    () {},
                    false,
                    const SizedBox.shrink(),
                  ),
                  const YMargin(16),
                  buildField(
                    context,
                    model,
                    'Middle Name',
                    'Middle Name',
                    TextEditingController(text: model.user?.firstname ?? ''),
                    () {},
                    false,
                    const SizedBox.shrink(),
                  ),
                  const YMargin(16),
                  buildField(
                    context,
                    model,
                    'Last Name',
                    'Last Name',
                    TextEditingController(text: model.user?.lastname ?? ''),
                    () {},
                    false,
                    const SizedBox.shrink(),
                  ),
                  const YMargin(16),
                  buildField(
                    context,
                    model,
                    'Date of Birth',
                    'Date of Birth',
                    TextEditingController(text: model.user?.firstname ?? ''),
                    () {},
                    false,
                    const GetSvgImage(
                        image: 'assets/images/calander_picker.svg',boxFit: BoxFit.scaleDown,),
                  ),
                  const NormalText(
                    text:
                        'You can only change your date off birth once. Make sure to use the right date',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  const YMargin(24),
                  ContainerWidget(
                    onTap: () {},
                    backgroundColor: XColors.primaryColor2(),
                    borderRadius: BorderRadius.circular(8),
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
        });
  }
}

Widget buildField(
    BuildContext context,
    ProfileViewModel model,
    String title,
    String label,
    TextEditingController controller,
    Function() function,
    bool isReadOnly,
    Widget? suffixIcon,
    [int? maxLine,
    Color? background]) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      NormalText(
        text: title,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      const SizedBox(height: 8),
      TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD0D5DD)),
          ),
          hintText: label,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: Color(0xFFD0D5DD),
            ),
          ),
          filled: true,
          fillColor: background ?? XColors.white(),
        ),
        maxLines: maxLine,
        readOnly: isReadOnly,
        controller: controller,
        onTap: function,
      ),
    ],
  );
}
