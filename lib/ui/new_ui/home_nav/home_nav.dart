import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home_revamp.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav_vmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/more/more_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:stacked/stacked.dart';

/// One bottom-nav tab. Its position in [dashboardTabs] is also its page index.
class DashboardTab {
  const DashboardTab({required this.label, required this.icon});

  final String label;
  final String icon;
}

const dashboardTabs = <DashboardTab>[
  DashboardTab(label: 'Home', icon: 'assets/images/nav_icons/home.svg'),
  DashboardTab(label: 'Reminders', icon: 'assets/images/nav_icons/reminder.svg'),
  DashboardTab(label: 'Map', icon: 'assets/images/nav_icons/map.svg'),
  DashboardTab(label: 'More', icon: 'assets/images/nav_icons/more.svg'),
];

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
      child: ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: XColors.background(),
            body: PageView(
              controller: _pageController,
              onPageChanged: model.changeTabIndex,
              physics: const PageScrollPhysics(),
              children: const [
                NewHomeRevampScreen(),
                ReminderScreen(),
                MapScreen(),
                MoreScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavbar(
              currentIndex: model.currentIndex,
              onTap: (index) {
                model.changeTabIndex(index);
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// The four-tab bar with a sliding indicator over the selected tab.
class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final tabCount = dashboardTabs.length;
    final selected = currentIndex.clamp(0, tabCount - 1);

    return Container(
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
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                // Maps the tab index onto -1 (far left) .. 1 (far right).
                alignment: Alignment(tabCount == 1 ? 0 : -1 + 2 * selected / (tabCount - 1), -1),
                child: FractionallySizedBox(
                  widthFactor: 1 / tabCount,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: XColors.primaryColor(),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(3)),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < tabCount; i++)
                    Expanded(
                      child: _NavItem(
                        tab: dashboardTabs[i],
                        selected: i == selected,
                        onTap: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.tab, required this.selected, required this.onTap});

  final DashboardTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? XColors.primaryColor() : XColors.textColor();

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: selected ? 1.1 : 1,
              child: GetSvgImage(
                image: tab.icon,
                height: 22,
                width: 22,
                color: selected ? XColors.primaryColor() : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: selected ? 12 : 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
