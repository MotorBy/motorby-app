import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/directions_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class PastDestinationsScreen extends StatelessWidget {
  const PastDestinationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MapViewModel>.reactive(
      viewModelBuilder: () => MapViewModel(),
      onViewModelReady: (model) {
        model.init();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: XColors.background(),
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Past destinations',
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search destinations',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    // Implement search functionality
                    viewModel.searchDestinations(value);
                  },
                ),
                const YMargin(16),
                
                // Saved Addresses Section
                const NormalText(
                  text: 'Saved Addresses',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const YMargin(12),
                _buildSavedAddressesList(context, viewModel),
                const YMargin(24),
                
                // Recent Destinations Section
                const NormalText(
                  text: 'Recent Destinations',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const YMargin(12),
                _buildRecentDestinationsList(context, viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedAddressesList(BuildContext context, MapViewModel viewModel) {
    final savedAddresses = [
      if (viewModel.homeAddress != null) viewModel.homeAddress!,
      if (viewModel.workAddress != null) viewModel.workAddress!,
    ];

    if (savedAddresses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: NormalText(
            text: 'No saved addresses yet',
            fontSize: 14,
            textColor: Colors.grey,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: savedAddresses.length,
      separatorBuilder: (context, index) => const YMargin(12),
      itemBuilder: (context, index) {
        final address = savedAddresses[index];
        final isHome = address == viewModel.homeAddress;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: XColors.primaryColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isHome ? Icons.home_outlined : Icons.work_outline,
                  color: XColors.primaryColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text: isHome ? 'Home' : 'Work',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    NormalText(
                      text: address['address'],
                      fontSize: 14,
                      textColor: Colors.black87,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.directions),
                color: XColors.primaryColor(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DirectionsScreen(
                        destination: LatLng(
                          address['latitude'],
                          address['longitude'],
                        ),
                        destinationName: isHome ? 'Home' : 'Work',
                        destinationAddress: address['address'],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentDestinationsList(BuildContext context, MapViewModel viewModel) {
    // This would normally come from the viewModel
    final recentDestinations = viewModel.recentDestinations ?? [];

    if (recentDestinations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: NormalText(
            text: 'No recent destinations',
            fontSize: 14,
            textColor: Colors.grey,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        itemCount: recentDestinations.length,
        separatorBuilder: (context, index) => const YMargin(12),
        itemBuilder: (context, index) {
          final destination = recentDestinations[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: XColors.primaryColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: XColors.primaryColor(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NormalText(
                        text: destination['name'] ?? 'Unnamed Location',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),
                      NormalText(
                        text: destination['address'],
                        fontSize: 14,
                        textColor: Colors.black87,
                      ),
                      const SizedBox(height: 4),
                      NormalText(
                        text: destination['date'] != null
                            ? DateFormat('MMM d, yyyy').format(destination['date'])
                            : 'Recent',
                        fontSize: 12,
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.directions),
                      color: XColors.primaryColor(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DirectionsScreen(
                              destination: LatLng(
                                destination['latitude'],
                                destination['longitude'],
                              ),
                              destinationName: destination['name'] ?? 'Unnamed Location',
                              destinationAddress: destination['address'],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      color: XColors.primaryColor(),
                      onPressed: () {
                        // Implement save functionality
                        viewModel.saveDestination(destination);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}