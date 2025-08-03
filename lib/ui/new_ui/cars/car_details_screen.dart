import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/cars/update_car_image_view.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_tile_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/budget_tiles_view.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class CarDetailsScreen extends StatefulWidget {
  final CarId carData;
  final Budget? budget;
  final int? currentBudgetIndex;
  
  const CarDetailsScreen({Key? key, required this.carData, this.budget, this.currentBudgetIndex}) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this
    );

    _controller.forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      disposeViewModel: false,
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: XColors.background(),
          appBar: appBarHeader(
            appBarTitle: '${widget.carData.carMake} ${widget.carData.carModel} ${widget.carData.carYear}',
            hasOnBack: true,
            context: context,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarImageSlider(context: context),
                const YMargin(20),
                _buildCarSpecifications(
                    context,
                    viewModel: viewModel
                ),
                const YMargin(20),
                _buildCarDocuments(context, viewModel),
                const YMargin(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,),
                  child: ContainerWidget(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    elevation: 0.2,
                    borderRadius: BorderRadius.circular(16),
                    backgroundColor: XColors.white(),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            NormalText(
                              text: 'Car Spending',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              textColor: XColors.textColor(),
                            ),
                          ],
                        ),
                        BudgetTilesView(
                            budgetCurrentIndex: widget.currentBudgetIndex
                        ),
                      ],
                    ),
                  ),
                ),
                const YMargin(20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCarImageSlider({BuildContext? context}) {
    return widget.carData.images != null && widget.carData.images!.isNotEmpty
        ? CarouselSlider(
            options: CarouselOptions(
              height: 220,
              viewportFraction: 0.8,
              enableInfiniteScroll: widget.carData.images!.length > 1,
              autoPlay: widget.carData.images!.length > 1,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
            ),
            items: widget.carData.images!.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: XColors.black(),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.car_crash_outlined,
                              size: 60,
                              color: XColors.primaryColor(),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: XColors.primaryColor(),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Container(
              width: double.infinity,
              height: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EFFB).withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const GetSvgImage(image: 'assets/images/file_uploadfile.svg'),
                  const YMargin(10),
                  GestureDetector(
                    onTap: () {

                      modalBottomSheetMenu(
                        color: Colors.white,
                        context: context!,
                        height: 680,
                        child: UpdateCarImage(
                          setImages: const [],
                          onCompleteImageUpload: (v) async {
                            if(v) {
                              popView(context);
                            }
                          },
                        ),
                      );

                    },
                    child: const NormalText(
                      text: 'Click to update car images',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const NormalText(
                    text: 'PNG, JPG (max. 800×400px)',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCarSpecifications(BuildContext context, {required HomeViewModel viewModel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ContainerWidget(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        elevation: 0.2,
        borderRadius: BorderRadius.circular(16),
        backgroundColor: XColors.white(),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: 'Car Specifications',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  textColor: XColors.textColor(),
                ),
                Row(
                  children: [
                    NormalText(
                      text: viewModel.openCarSpecsView == true ? 'More' : 'Less',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: XColors.primaryColor(),
                    ),
                    const XMargin(10),
                    GestureDetector(
                      onTap: () {
                        viewModel.setCarSpecsView();
                        if (viewModel.openCarSpecsView!) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                      },
                      child: Container(
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 0.5).animate(_animation),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: XColors.primaryColor(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const YMargin(12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSpecificationRow(
                    context,
                    'assets/images/icons/airbag.png',
                    'Airbags',
                    widget.carData.details?.airBag ?? 'N/A',
                  ),
                  const XMargin(34),
                  _buildSpecificationRow(
                    context,
                    'assets/images/icons/aircondition.png',
                    'AC Status',
                    widget.carData.details?.airConditioner ?? 'N/A',
                  ),
                  const XMargin(34),
                  _buildSpecificationRow(
                    context,
                    'assets/images/icons/seat.png',
                    'Seats',
                    widget.carData.details?.seats?.toString() ?? 'N/A',
                  ),
                  const XMargin(34),
                  _buildSpecificationRow(
                    context,
                    'assets/images/icons/speaker.png',
                    'Speakers',
                    widget.carData.details?.speakers?.toString() ?? 'N/A',
                  ),
                ],
              ),
            ),

            ////sub specification details
            SizeTransition(
              sizeFactor: _animation,
              child: Column(children: [
                const YMargin(30),
                Column(children: [

                  Row(
                    children: [
                      Expanded(
                        child: MileageTileView(
                          totalMileage: widget.carData.details?.mileage!.toString() ?? "N/A",
                        ),
                      ),
                      const XMargin(20),
                      Expanded(
                        child: ChecklistTileView(
                          checkedItems: viewModel!.checkListStatus(index: widget.currentBudgetIndex).split('/')[0] == '0' ? 0 :
                                int.parse(viewModel.checkListStatus(index: widget.currentBudgetIndex).split('/')[0]),
                          totalItems: viewModel.checkListStatus(index: widget.currentBudgetIndex).split('/')[1] == '0' ? 0 :
                                int.parse(viewModel.checkListStatus(index: widget.currentBudgetIndex).split('/')[1]),
                          onCheckListScreen: () {
                            navigate(
                              context,
                              ChecklistScreen(
                                carId: widget.carData.sId!,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const YMargin(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NormalText(
                        text: 'Fuel efficiency',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      NormalText(
                        text: '${viewModel.getFuelMileageDate(index: widget.currentBudgetIndex ?? 0).fuelEfficiency}km/L',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                  const YMargin(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NormalText(
                        text: 'Transmission',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      NormalText(
                        text: widget.carData.details?.gear?.toString() ?? "N/A",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                  const YMargin(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NormalText(
                        text: 'Last distance traveled',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      NormalText(
                        text: '${viewModel.getFuelMileageDate(index: widget.currentBudgetIndex ?? 0).lastTraveled}km',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                  const YMargin(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NormalText(
                        text: 'Last fuel price',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      Row(
                        children: [
                          Text(
                            '\u20A6',
                            style: TextStyle(
                                fontSize: 14,
                                color: XColors.black(),
                                fontWeight: FontWeight.w600),
                          ),
                          NormalText(
                            text: '${viewModel.getFuelMileageDate(index: widget.currentBudgetIndex ?? 0).lastRefuelAmount}',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      )
                    ],
                  ),
                ],),
              ],),
            ),
            const YMargin(6),
          ],
        ),
    ));
  }

  Widget _buildSpecificationRow(BuildContext context, String iconPath, String label, String value) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: XColors.primaryColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(iconPath),
        ),
        const XMargin(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              text: label,
              fontSize: 14,
              textColor: XColors.textColor().withOpacity(0.7),
            ),
            NormalText(
              text: value,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              textColor: XColors.textColor(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarDocuments(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ContainerWidget(
        padding: const EdgeInsets.symmetric(horizontal: 16,),
        elevation: 0.2,
        borderRadius: BorderRadius.circular(16),
        backgroundColor: XColors.white(),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const YMargin(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: 'Car Documents (${widget.carData.carDocuments!.length})',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  textColor: XColors.textColor(),
                ),
                GestureDetector(
                  onTap: () {
                    navigate(
                      context,
                      CarDocumentsScreen(
                          carId: widget.carData.sId!,
                          showCarSelection: true
                      ),
                    );
                  },
                  child: NormalText(
                    text: 'View All',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    textColor: XColors.primaryColor(),
                  ),
                ),
              ],
            ),
            const YMargin(16),
            if (widget.carData.carDocuments != null && widget.carData.carDocuments!.isNotEmpty)
              ...widget.carData.carDocuments!.take(2).map((document) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: XColors.primaryColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: XColors.primaryColor(),
                        ),
                      ),
                      const XMargin(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: document.documentName ?? document.documentType ?? 'Document',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              textColor: XColors.textColor(),
                            ),
                            if (document.documentExpiryDate != null) ...[
                              NormalText(
                                text: 'Expires: ${document.documentExpiryDate}',
                                fontSize: 11,
                                textColor: XColors.textColor().withOpacity(0.7),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: NormalText(
                    text: 'No documents available',
                    fontSize: 14,
                    textColor: XColors.textColor().withOpacity(0.7),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}