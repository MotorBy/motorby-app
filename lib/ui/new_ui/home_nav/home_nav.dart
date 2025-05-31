import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav_vmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/quick_actions/quick_actions_bottom_sheet.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/report_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:stacked/stacked.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {}
      },
      child: ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: XColors.background(),
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                model.changeTabIndex(index);
              },
              children: const [
                NewHomeScreen(),
                ReportScreen(),
                ReminderScreen(),
                MapScreen(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                modalBottomSheetMenu(
                  context: context,
                  radius: 24,
                  child: const QuickActionsBottomSheet(),
                );
              },
              backgroundColor: XColors.primaryColor(),
              child: const GetSvgImage(image: 'assets/images/primary_button.svg'),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
            bottomNavigationBar: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      height: 3,
                      margin: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width / 5) * model.currentIndex + 20,
                        right: (MediaQuery.of(context).size.width / 5) * (4 - model.currentIndex) + 20,
                      ),
                      decoration: BoxDecoration(
                        color: XColors.primaryColor(),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  BottomNavbar(
                    onTap: (index) {
                      _pageController.animateToPage(
                        index == 3 ? 2 : index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      );
                      model.changeTabIndex(index);
                    },
                    model: model,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BottomNavbar extends StatelessWidget {
  final Function(int) onTap;
  final DashboardViewModel model;

  const BottomNavbar({super.key, required this.onTap, required this.model});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: "Home",
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(model.currentIndex == 0 ? 0 : 2),
            child: const GetSvgImage(image: 'assets/images/home.svg', height: 30, width: 30,),
          ),
          backgroundColor: XColors.background(),
        ),
        BottomNavigationBarItem(
          label: "Report",
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(model.currentIndex == 1 ? 0 : 2),
            child: const GetSvgImage(image: 'assets/images/report.svg', height: 30, width: 30,),
          ),
          backgroundColor: XColors.background(),
        ),
        const BottomNavigationBarItem(
          label: "",
          icon: SizedBox(width: 50),
        ),
        BottomNavigationBarItem(
          label: "Reminder",
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(model.currentIndex == 3 ? 0 : 2),
            child: const GetSvgImage(image: 'assets/images/reminder.svg', height: 30, width: 30,),
          ),
          backgroundColor: XColors.background(),
        ),
        BottomNavigationBarItem(
          label: "Map",
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(model.currentIndex == 4 ? 0 : 2),
            child: const GetSvgImage(image: 'assets/images/map.svg', height: 30, width: 30,),
          ),
          backgroundColor: XColors.background(),
        ),
      ],
      currentIndex: model.currentIndex,
      selectedItemColor: XColors.primaryColor(),
      selectedFontSize: 12.0,
      unselectedFontSize: 11.0,
      backgroundColor: Colors.transparent,
      unselectedItemColor: XColors.textColor(),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 0,
      onTap: onTap,
    );
  }
}
