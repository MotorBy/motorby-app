import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/insurance/insurance_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class ViewClaimDetails extends StatefulWidget {
  const ViewClaimDetails({super.key, required this.status});
  final String status;
  @override
  State<ViewClaimDetails> createState() => _ViewClaimDetailsState();
}

class _ViewClaimDetailsState extends State<ViewClaimDetails> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => InsuranceViewModel(),
        builder: (context, model, child) {
        return Scaffold(
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'View details',
          ),
          backgroundColor: XColors.background(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const YMargin(16),
                  ContainerWidget(
                    backgroundColor: XColors.white(),
                    borderRadius: BorderRadius.circular(16),
                    padding:
                        const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
                    child: SizedBox(
                      height: 310,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == 5) {
                              return ListTile(
                                leading: const NormalText(
                                  text: 'Status',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                trailing: NormalText(
                                  text: widget.status,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textColor: widget.status == 'Settled'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            }
                            return const ListTile(
                              leading: NormalText(
                                text: 'Claim file',
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              trailing: NormalText(
                                text: 'Accident Damage',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const DividerWidget(),
                          itemCount: 6),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: NormalText(
                      text: 'Description of Incident',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  ContainerWidget(
                    backgroundColor: XColors.white(),
                    borderRadius: BorderRadius.circular(16),
                    height: 136,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: NormalText(
                      text: 'Image Incident',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  ContainerWidget(
                    backgroundColor: XColors.white(),
                    borderRadius: BorderRadius.circular(16),
                    height: 136,
                  ),
                  const YMargin(30),
                  const NormalText(
                    text: 'Pending Task',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const YMargin(12),
                  const NormalText(
                    text: 'Please submit police report',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  const YMargin(12),
                  const NormalText(
                    text: 'Upload image ',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const YMargin(10),
                  ContainerWidget(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    decoration: DottedDecoration(
                      shape: Shape.box,
                      strokeWidth: 2.0,
                      color: Color(0xffD0D5DD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      const  GetSvgImage(image: 'assets/images/file_upload.svg'),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: 'Upload your document',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            Row(
                              children: [
                                NormalText(
                                  text: 'PDF format',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textColor: Color(0xFF98A2B3),
                                ),
                                                            XMargin(4),
        
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Color(0xFF98A2B3),
                                ),
                                XMargin(4),
                                NormalText(
                                  text: 'Max. 5MB',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textColor: Color(0xFF98A2B3),
                                ),
                              ],
                            )
                          ],
                        ),
                        ContainerWidget(
                          backgroundColor: XColors.primaryColor2(),
                          borderRadius: BorderRadius.circular(8),
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                          child: NormalText(
                            text: 'Uploaad',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: XColors.white(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const YMargin(10),
                  const NormalText(
                    text: 'Upload image of the incident ',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                                const YMargin(30),
        
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
