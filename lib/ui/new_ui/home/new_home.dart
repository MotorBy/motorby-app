import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';

class VehicleSelectionBottomSheet extends StatelessWidget {
  const VehicleSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
            height: 4,
            width: 40,
            color: Color(0xFFD0D5DD),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My cars',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(vertical: -2),
                    leading: const GetSvgImage(
                        image: 'assets/images/auto/toyota_se.svg'),
                    trailing: const Icon(Icons.circle_outlined),
                    title: const NormalText(
                      text: 'Toyota Camry',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    selected: true,
                    selectedTileColor: Colors.deepPurple.withOpacity(0.1),
                    onTap: () => Navigator.pop(context),
                  );
                },
                separatorBuilder: (context, index) => const DividerWidget(),
                itemCount: 2),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const NormalText(
                text: 'Add car',
                textColor: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: XColors.background(),
                side: const BorderSide(width: 1, color: Colors.grey),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
                navigate(context, const AddCarScreen());
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: XColors.background(),
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: GetSvgImage(image: 'assets/images/user_.svg'),
        ),
        title: const NormalText(
          text: 'Hey Matthew',
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GetSvgImage(image: 'assets/images/motorby_bell.svg'),
          )
        ],
      ),
      backgroundColor: XColors.background(),
      body: ViewModelBuilder<HomeViewModel>.reactive(
          viewModelBuilder: () => HomeViewModel(),
          builder: (context, viewModel, child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Selection Card
                      ListTile(
                        leading: const Icon(Icons.directions_car),
                        dense: true,
                        visualDensity: const VisualDensity(horizontal: -4),
                        title: Row(
                          children: [
                            Image.asset('assets/images/toyota-logo.png',
                                height: 24),
                            const SizedBox(width: 2),
                            const NormalText(
                              text: 'Toyota',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            const XMargin(10),
                            Icon(
                              Icons.expand_less_rounded,
                              color: XColors.black(),
                              size: 30,
                            )
                          ],
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) =>
                                const VehicleSelectionBottomSheet(),
                          );
                        },
                      ),

                      // Fuel Price Card
                      ContainerWidget(
                        backgroundColor: XColors.highlightColor(),
                        borderRadius: BorderRadius.circular(8),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          visualDensity: const VisualDensity(vertical: -3),
                          dense: true,
                          title: NormalText(
                            text: 'Average fuel price in your location:',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: XColors.black(),
                          ),
                          trailing: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NormalText(
                                text: '₦',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              NormalText(
                                text: ' 1,150',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              XMargin(12),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      const YMargin(14),
                      // Insurance Card
                      const Stack(
                        children: [
                          GetPngImage(image: 'assets/images/motorby_toyo.png'),
                          Positioned(
                            top: 35,
                            left: 14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Car Insurance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Request quote',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(Icons.chevron_right,
                                        color: Colors.white),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      const YMargin(16),

                      const InfoBox(),

                      const YMargin(16),

                      // Reminder Card
                      ContainerWidget(
                        elevation: 0.2,
                        height: 200,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: XColors.white(),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: 'Reminders',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textColor: XColors.black(),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              height: 1,
                              width: double.infinity,
                              color: Color(0xFFD0D5DD),
                            ),
                            Expanded(
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {},
                                      leading: const GetSvgImage(
                                          image:
                                              'assets/images/water-drop.svg'),
                                      dense: true,
                                      visualDensity:
                                          const VisualDensity(horizontal: -1),
                                      title: NormalText(
                                        text: 'Oil change',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        textColor: XColors.black(),
                                      ),
                                      trailing: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                  separatorBuilder: (context, index) =>
                                   const   DividerWidget(),
                                  itemCount: 4),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      width: double.infinity,
      color: const Color(0xFFD0D5DD),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              ContainerWidget(
                elevation: 0.2,
                padding: const EdgeInsets.symmetric(vertical: 16),
                borderRadius: BorderRadius.circular(16),
                backgroundColor: const Color(0xFFF0E8F8),
                width: double.infinity,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NormalText(
                      text: 'Weather',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    YMargin(12),
                    NormalText(
                      text: '34C',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              const YMargin(16),
              Stack(
                children: [
                  ContainerWidget(
                    elevation: 0.2,
                    onTap: () {},
                    height: 272,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: Colors.black26,
                    width: double.infinity,
                    child: Container(),
                  ),
                  Positioned(
                      bottom: 30,
                      right: 0,
                      left: 0,
                      child: Column(
                        children: [
                          const GetSvgImage(image: 'assets/images/expand.svg'),
                          const YMargin(60),
                          ContainerWidget(
                            backgroundColor: const Color(0xFF14121280),
                            borderRadius: BorderRadius.circular(40),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: NormalText(
                              text: 'View map',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              textColor: XColors.background(),
                            ),
                          ),
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
        const XMargin(16),
        Expanded(
          child: Column(
            children: [
              ContainerWidget(
                onTap: (){
                   showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.2),
                          builder: (context) {
                            return const ChecklistScreenDialogue(
                              
                             
                            );
                          });

                },
                elevation: 0.2,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                borderRadius: BorderRadius.circular(16),
                backgroundColor: const Color(0xFFF3F3FA),
                width: double.infinity,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NormalText(
                          text: 'Checklist',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        YMargin(12),
                        NormalText(
                          text: '8 / 10',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    CircularProgressIndicator(
                      value: 0.8,
                      color: Colors.deepPurple,
                      strokeWidth: 4,
                      backgroundColor: Colors.black12,
                    ),
                  ],
                ),
              ),
              const YMargin(16),
              ContainerWidget(
                elevation: 0.2,
                padding: const EdgeInsets.only(top: 16),
                borderRadius: BorderRadius.circular(16),
                backgroundColor: const Color(0xFFF3F3FA),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const NormalText(
                      text: 'Mileage',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    const YMargin(12),
                    const NormalText(
                      text: '10,030,409',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    const YMargin(21),
                    ContainerWidget(
                      elevation: 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                      backgroundColor: XColors.highlightColor(),
                      width: double.infinity,
                      child: const Center(
                        child: const NormalText(
                          text: 'Update',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const YMargin(16),
              ContainerWidget(
                elevation: 0.2,
                padding: const EdgeInsets.only(top: 16),
                borderRadius: BorderRadius.circular(16),
                backgroundColor: const Color(0xFFF3F3FA),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const NormalText(
                      text: 'Expenditures',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    const YMargin(12),
                    const NormalText(
                      text: '₦ 100,030',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    const YMargin(21),
                    ContainerWidget(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                      backgroundColor: XColors.highlightColor(),
                      width: double.infinity,
                      child: const Center(
                        child: NormalText(
                          text: 'View report',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
