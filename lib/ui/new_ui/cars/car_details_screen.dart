import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/documents/car_documents_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_tile_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/budget_tiles_view.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class CarDetailsScreen extends StatelessWidget {
  final CarId carData;
  
  const CarDetailsScreen({Key? key, required this.carData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      disposeViewModel: false,
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: XColors.background(),
          appBar: appBarHeader(
            appBarTitle: '${carData.carMake} ${carData.carModel} ${carData.carYear}',
            hasOnBack: true,
            context: context,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarImageSlider(),
                const YMargin(20),
                _buildCarSpecifications(context),
                const YMargin(20),
                _buildCarDocuments(context, viewModel),
                const YMargin(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,),
                  child: ContainerWidget(
                    padding: const EdgeInsets.all(8),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              textColor: XColors.textColor(),
                            ),
                          ],
                        ),
                        const BudgetTilesView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCarImageSlider() {
    return carData.images != null && carData.images!.isNotEmpty
        ? CarouselSlider(
            options: CarouselOptions(
              height: 220,
              viewportFraction: 0.8,
              enableInfiniteScroll: carData.images!.length > 1,
              autoPlay: carData.images!.length > 1,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
            ),
            items: carData.images!.map((imageUrl) {
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
        : Container(
            height: 220,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: XColors.primaryColor().withOpacity(0.2),
            ),
            child: Center(
              child: Icon(
                Icons.directions_car,
                size: 80,
                color: XColors.primaryColor(),
              ),
            ),
          );
  }

  Widget _buildCarSpecifications(BuildContext context) {
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
            NormalText(
              text: 'Car Specifications (4)',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textColor: XColors.textColor(),
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
                    carData.details?.airBag ?? 'N/A',
                  ),
                  const XMargin(34),
                  _buildSpecificationRow(
                    context,
                    'assets/images/icons/aircondition.png',
                    'AC Status',
                    carData.details?.airConditioner ?? 'N/A',
                  ),
                  const XMargin(34),
                  _buildSpecificationRow(
                    context,
                    'assets/images/icons/seat.png',
                    'Seats',
                    carData.details?.seats?.toString() ?? 'N/A',
                  ),
                  const XMargin(34),
                  _buildSpecificationRow(
                    context,
                    'assets/images/icons/speaker.png',
                    'Speakers',
                    carData.details?.speakers?.toString() ?? 'N/A',
                  ),
                ],
              ),
            ),

            ////sub specification details
            const YMargin(30),
            Column(children: [

              Row(
                children: [
                  const Expanded(
                    child: MileageTileView(
                      totalMileage: "346576",
                    ),
                  ),
                  const XMargin(20),
                  Expanded(
                    child: ChecklistTileView(
                        checkedItems: 2,
                        totalItems: 5,
                        onCheckListScreen: () {
                          navigate(
                              context,
                              ChecklistScreen(
                                carId: carData.sId!,
                              ),
                          );
                        },
                    ),
                  ),
                ],
              ),
              const YMargin(20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: 'Fuel efficiency',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  NormalText(
                    text: '5.0km/L',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
              const YMargin(20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: 'Transmission',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  NormalText(
                    text: 'Automatic',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
              const YMargin(20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: 'Last distance traveled',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  NormalText(
                    text: '20km',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )
                ],
              )
          ],),
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
                  text: 'Car Documents (${carData.carDocuments!.length})',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textColor: XColors.textColor(),
                ),
                GestureDetector(
                  onTap: () {
                    navigate(
                      context,
                      CarDocumentsScreen(carId: carData.sId!),
                    );
                  },
                  child: NormalText(
                    text: 'View All',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: XColors.primaryColor(),
                  ),
                ),
              ],
            ),
            const YMargin(16),
            if (carData.carDocuments != null && carData.carDocuments!.isNotEmpty)
              ...carData.carDocuments!.take(2).map((document) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              textColor: XColors.textColor(),
                            ),
                            if (document.documentExpiryDate != null) ...[  
                              NormalText(
                                text: 'Expires: ${document.documentExpiryDate}',
                                fontSize: 12,
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