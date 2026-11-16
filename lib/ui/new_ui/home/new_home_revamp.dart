import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_snapshot.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_widgets.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/add/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_list_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/services/drive_session_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/drive/drive_mode_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/drive/drive_mode_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_tile_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_widgets.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/quick_actions/quick_actions_bottom_sheet.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/session.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:stacked/stacked.dart';

class NewHomeRevampScreen extends StatefulWidget {
  const NewHomeRevampScreen({Key? key, this.viewModel}) : super(key: key);

  /// Lets tests hand in a prepared view model. The app builds its own.
  final HomeViewModel? viewModel;

  @override
  State<NewHomeRevampScreen> createState() => _NewHomeRevampScreenState();
}

class _NewHomeRevampScreenState extends State<NewHomeRevampScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _signInAgain() {
    if (mounted) showSignIn(Navigator.of(context, rootNavigator: true));
  }

  Future<void> _refresh(HomeViewModel model) => model.init(onErrorLogout: _signInAgain);

  void _askForLocation(HomeViewModel model) {
    if (!mounted) return;
    modalBottomSheetMenu(
      color: Colors.white,
      isDismissible: false,
      context: context,
      height: 470,
      child: InfoDetailsView(
        infoType: InfoType.locationSetup,
        onPermissionAction: model.getLocationUpdate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => widget.viewModel ?? HomeViewModel(),
      disposeViewModel: false,
      onViewModelReady: (model) {
        // Picks up a drive the app was closed during.
        serviceLocator<DriveSessionService>().restore();
        model.init(
          onErrorLogout: _signInAgain,
          onPermissionCallBack: () => _askForLocation(model),
        );
      },
      builder: (context, model, child) {
        final showQuickActions = _canUseQuickActions(model);
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: showQuickActions
              ? FloatingActionButton.extended(
                  heroTag: 'home-quick-actions',
                  onPressed: () => _openQuickActions(context, model),
                  backgroundColor: Brand.purple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
                  icon: const Icon(Icons.bolt_rounded),
                  label: Text(
                    'Quick actions',
                    style: Brand.text(size: 14, weight: FontWeight.w600, color: Colors.white),
                  ),
                )
              : null,
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: Brand.purple,
              onRefresh: () => _refresh(model),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                // Extra room at the bottom so the quick actions button never
                // covers the last card.
                padding: EdgeInsets.fromLTRB(20, 8, 20, showQuickActions ? 96 : 32),
                children: [
                  HomeHeader(
                    greeting: model.greeting(),
                    name: model.firstName,
                    initial: model.initial,
                    onProfile: () => navigate(context, const NewProfileScreen()),
                  ),
                  if (model.isFirstLoad)
                    const HomeSkeleton()
                  else if (model.showLoadError)
                    HomeErrorView(message: model.loadError, onRetry: () => _refresh(model))
                  else
                    ..._content(context, model),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Quick actions log against the picked car, so they only show once home
  /// has loaded and a car is selected.
  bool _canUseQuickActions(HomeViewModel model) =>
      !model.isFirstLoad && !model.showLoadError && model.currentBudget != null;

  /// Opens quick actions for the picked car, then refreshes home so anything
  /// logged there (fuel, servicing, budget) shows straight away.
  Future<void> _openQuickActions(BuildContext context, HomeViewModel model) async {
    await modalBottomSheetMenu(
      context: context,
      radius: 24,
      child: const QuickActionsBottomSheet(),
    );
    if (mounted) model.onBudgetViewUpdated(model.currentBudgetViewIndex);
  }

  List<Widget> _content(BuildContext context, HomeViewModel model) {
    final partlyFailed = model.failedSections
        .intersection({HomeSection.cars, HomeSection.reminders})
        .isNotEmpty;

    return [
      if (partlyFailed)
        const HomeNotice(message: "Some of your details didn't load. Pull down to refresh."),
      const _DrivingBanner(),
      const SizedBox(height: 16),
      WeatherCard(
        temperature: model.currentWeatherValue,
        description: model.currentWeatherDescription,
        locationDeclined: model.locationDeclined == true,
        onEnableLocation: model.getLocationUpdate,
        onDriveGuide: () => modalBottomSheetMenu(
          color: Colors.white,
          context: context,
          height: 550,
          child: const InfoDetailsView(infoType: InfoType.weatherView),
        ),
      ),

      HomeSectionHeader(
        title: 'Your garage',
        actionLabel: model.currentCar != null ? 'View details' : null,
        onAction: () => _openCarDetails(context, model),
      ),
      _GarageCard(model: model),

      HomeSectionHeader(
        title: 'Spending',
        actionLabel: model.currentBudget != null ? 'See details' : null,
        onAction: () => _openBudgetDetails(context, model),
      ),
      BudgetSummaryCard(
        snapshot: BudgetSnapshot.fromBudget(model.currentBudget),
        hasCar: model.currentBudget != null,
        onTap: () => _openBudgetDetails(context, model),
      ),
      const SizedBox(height: 12),
      RecentSpendCard(spend: model.recentSpend),
    ];
  }

  /// Opens the full budget for the picked car, then refreshes home in case
  /// the budget was updated there.
  Future<void> _openBudgetDetails(BuildContext context, HomeViewModel model) async {
    if (model.currentBudget == null) return;
    await openBudgetDetails(context, budgetIndex: model.currentBudgetViewIndex ?? 0);
    model.onBudgetViewUpdated(model.currentBudgetViewIndex);
  }

  void _openCarDetails(BuildContext context, HomeViewModel model) {
    final budget = model.currentBudget;
    final car = model.currentCar;
    if (budget == null || car == null) return;
    navigate(
      context,
      CarDetailsScreen(
        carData: car,
        budget: budget,
        currentBudgetIndex: model.currentBudgetViewIndex ?? 0,
      ),
    );
  }
}

class _GarageCard extends StatelessWidget {
  const _GarageCard({required this.model});

  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
    if (!model.hasAddedCar) {
      return HomeCard(
        padding: EdgeInsets.zero,
        child: NoCarsView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          onAddCar: () => navigate(context, const AddCarsScreen()),
        ),
      );
    }

    final images = model.currentCar?.images ?? const <String>[];
    final checklist = model.checklistProgress;

    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarSelectorView(
            cars: model.budgets,
            currentCar: model.currentCarTitle,
            allowStyling: false,
            onCarSelected: ({Budget? budget, int? index}) => model.selectCar(index ?? 0),
          ),
          const SizedBox(height: 8),
          if (images.isNotEmpty)
            CarListThumbnail(images: images)
          else
            _AddPhotos(
              onTap: () => navigate(
                context,
                AddCarsScreen(action: 'edit', currentCar: model.currentCar),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MileageTileView(
                  totalMileage: model.totalMileage,
                  onMileageUpdate: () async {
                    await openMileageDetails(context, budgetIndex: model.currentBudgetViewIndex ?? 0);
                    model.onBudgetViewUpdated(model.currentBudgetViewIndex);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChecklistTileView(
                  checkedItems: checklist.checked,
                  totalItems: checklist.total,
                  onCheckListScreen: () {
                    final carId = model.currentCar?.sId;
                    if (carId == null) return;
                    navigate(context, ChecklistScreen(carId: carId));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddPhotos extends StatelessWidget {
  const _AddPhotos({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Brand.lavender,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 140,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Brand.hairline,
                ),
                child: const Icon(Icons.add_a_photo_rounded, color: Brand.purple, size: 22),
              ),
              const SizedBox(height: 10),
              Text('Add car photos', style: Brand.text(size: 14, weight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('Show off your ride', style: Brand.text(size: 12, color: Brand.muted)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown at the top of home while a car is in drive mode; taps back into the
/// live drive view.
class _DrivingBanner extends StatelessWidget {
  const _DrivingBanner();

  @override
  Widget build(BuildContext context) {
    final drive = serviceLocator<DriveSessionService>();
    return ListenableBuilder(
      listenable: drive,
      builder: (context, _) {
        if (!drive.isDriving) return const SizedBox.shrink();
        final stats = drive.stats;
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => openDriveMode(context),
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [Color(0xFF0E9F6E), Brand.success]),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.navigation_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Driving ${DriveModeViewModel.carNameFor(drive.drivingCar)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Brand.text(size: 15, weight: FontWeight.w700, color: Colors.white)),
                          Text('${stats.distanceKm.toStringAsFixed(1)} km so far · tap to view',
                              style: Brand.text(size: 12, color: Colors.white.withOpacity(0.85))),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
