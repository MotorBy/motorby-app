import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/success_claim.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class NewClaimScreen extends StatefulWidget {
  const NewClaimScreen({super.key});

  @override
  State<NewClaimScreen> createState() => _NewClaimScreenState();
}

class _NewClaimScreenState extends State<NewClaimScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => InsuranceViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: appBarHeader(
              hasOnBack: true,
              context: context,
              appBarTitle: 'New Claim',
            ),
            backgroundColor: XColors.background(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NormalText(
                      text: 'What type of claim are you filing ?',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const YMargin(14),
                    ContainerWidget(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.2),
                            builder: (context) {
                              return IncidentListDialogue(
                                viewModel: viewModel,
                              );
                            });
                      },
                      backgroundColor: XColors.white(),
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NormalText(
                            text: viewModel.incidentType,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const GetSvgImage(
                              image: 'assets/images/icon_down.svg')
                        ],
                      ),
                    ),
                    const YMargin(32),
                    const NormalText(
                      text: 'Incident Details',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    const YMargin(14),
                    buildField(
                        context,
                        viewModel,
                        'Date of Incident',
                        'Date of Incident',
                        viewModel.dateOfIncident,
                        () {},
                        false,
                        const GetSvgImage(
                          image: 'assets/images/calander_picker.svg',
                          boxFit: BoxFit.scaleDown,
                        ),
                        1,
                        XColors.background()),
                    const YMargin(15),
                    buildField(
                        context,
                        viewModel,
                        'Time of Incident',
                        'Time of Incident',
                        viewModel.timeOfIncident,
                        () {},
                        false,
                        const GetSvgImage(
                          image: 'assets/images/time_picker.svg',
                          boxFit: BoxFit.scaleDown,
                        ),
                        1,
                        XColors.background()),
                    const YMargin(15),
                    buildField(
                        context,
                        viewModel,
                        'Location of Incident',
                        'Location',
                        viewModel.locationOfIncident,
                        () {},
                        false,
                        const SizedBox.shrink(),
                        1,
                        XColors.background()),
                    const YMargin(15),
                    buildField(
                        context,
                        viewModel,
                        'Description of Incident ',
                        'Describe what happened in detail ',
                        viewModel.descriptionOfIncident,
                        () {},
                        false,
                        const SizedBox.shrink(),
                        5,
                        XColors.background()),
                    const YMargin(4),
                    const NormalText(
                      text: 'Upload image ',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    const YMargin(10),
                    ContainerWidget(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: DottedDecoration(
                        shape: Shape.box,
                        strokeWidth: 2.0,
                        color: Color(0xffD0D5DD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GetSvgImage(image: 'assets/images/success_check.svg'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NormalText(
                                text: 'Image.pdf',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              NormalText(
                                text: '13MB',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: Color(0xFF98A2B3),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              GetSvgImage(image: 'assets/images/bin.svg'),
                                       XMargin(8),
                          GetSvgImage(image: 'assets/images/download.svg'),
                            ],
                          ),
                 
                        ],
                      ),
                    ),
                    const YMargin(10),
                    const NormalText(
                      text: 'Upload image of the incident ',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    const YMargin(16),
                       ContainerWidget(
                onTap: (){
                      navigate(context, const SuccessClaim());
                },
                backgroundColor: XColors.primaryColor2(),
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: Center(child: NormalText(text: 'Submit',textColor: XColors.white(),fontSize: 16,fontWeight: FontWeight.w600,)),
              ),
                            const YMargin(30),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class IncidentListDialogue extends StatefulWidget {
  const IncidentListDialogue({Key? key, required this.viewModel})
      : super(key: key);
  final InsuranceViewModel viewModel;

  @override
  State<IncidentListDialogue> createState() => _IncidentListDialogueState();
}

class _IncidentListDialogueState extends State<IncidentListDialogue> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
              height: 420,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NormalText(
                        text: 'Checklist',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const YMargin(20),
                  SizedBox(
                    height: 320,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -2),
                            onTap: () {
                              widget.viewModel.updateIncidentChoice(
                                  widget.viewModel.incidentList[index], index);
                            },
                            leading: ContainerWidget(
                              height: 30,
                              width: 30,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: XColors.white(),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1,
                                  color: widget.viewModel
                                              .selectedIncidentTypeIndex !=
                                          index
                                      ? Color(0xFFD0D5DD)
                                      : XColors.primaryColor2(),
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 2,
                                backgroundColor: widget.viewModel
                                            .selectedIncidentTypeIndex !=
                                        index
                                    ? Color(0xFFD0D5DD)
                                    : XColors.primaryColor2(),
                              ),
                            ),
                            title: NormalText(
                              text: widget.viewModel.incidentList[index],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const DividerWidget(
                              margin: EdgeInsets.symmetric(vertical: 10),
                            ),
                        itemCount: widget.viewModel.incidentList.length),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
