import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/add/add_car_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_list_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_selector_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_tile_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_widgets.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/budget_summary_view.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
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
      onViewModelReady: (model) => model.init(
        onErrorLogout: _signInAgain,
        onPermissionCallBack: () => _askForLocation(model),
      ),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(gradient: Brand.backdrop()),
            child: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: Brand.purple,
                onRefresh: () => _refresh(model),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
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
          ),
        );
      },
    );
  }

  List<Widget> _content(BuildContext context, HomeViewModel model) {
    final partlyFailed = model.failedSections
        .intersection({HomeSection.cars, HomeSection.reminders})
        .isNotEmpty;

    return [
      if (partlyFailed)
        const HomeNotice(message: "Some of your details didn't load. Pull down to refresh."),
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

      const HomeSectionHeader(title: 'Spending'),
      HomeCard(
        padding: const EdgeInsets.all(4),
        // Keyed so the summary reloads when another car is picked.
        child: BudgetSummaryView(
          key: ValueKey(model.currentBudgetViewIndex),
          currentBudgetIndex: model.currentBudgetViewIndex,
        ),
      ),
      const SizedBox(height: 12),
      RecentSpendCard(spend: model.recentSpend),

      HomeSectionHeader(
        title: 'Reminders',
        actionLabel: 'New',
        onAction: () => navigate(
          context,
          const InfoDetailsView(infoType: InfoType.reminder, isFromQuickActions: true),
        ),
      ),
      HomeCard(
        padding: const EdgeInsets.all(4),
        child: ReminderListView(
          reminders: model.recentReminders,
          onOpen: (reminder) => navigateWithCallBack(
            context,
            ReminderDetailsScreen(reminder: reminder),
            onCallBack: (_) => _refresh(model),
          ),
        ),
      ),
    ];
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
