import 'package:flutter/material.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Vehicle',
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
          ListTile(
            leading: Image.asset('assets/images/toyota_logo.png', height: 24),
            title: const Text('Toyota Camry'),
            subtitle: const Text('2020 • ABC 123'),
            selected: true,
            selectedTileColor: Colors.deepPurple.withOpacity(0.1),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Image.asset('assets/images/toyota_logo.png', height: 24),
            title: const Text('Toyota Corolla'),
            subtitle: const Text('2019 • XYZ 789'),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add New Vehicle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement add new vehicle functionality
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class NewHomeScreen extends ViewModelWidget<HomeViewModel> {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile and notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Hey Matthew',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Vehicle Selection Card
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Row(
                      children: [
                        Image.asset('assets/images/toyota_logo.png', height: 24),
                        const SizedBox(width: 8),
                        const Text('Toyota'),
                      ],
                    ),
                    trailing: const Icon(Icons.expand_more),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => const VehicleSelectionBottomSheet(),
                      );
                    },
                  ),
                ),

                // Fuel Price Card
                Card(
                  color: Colors.pink.shade50,
                  child: ListTile(
                    title: const Text('Average fuel price in your location:'),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₦ 1,150',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),

                // Insurance Card
                Card(
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Car Insurance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Row(
                                children: [
                                  Text(
                                    'Request quote',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(Icons.chevron_right, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/car_insurance.png',
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),

                // Info Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    // Weather Card
                    Card(
                      color: Colors.purple.shade50,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weather'),
                            Text(
                              '34°C',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Checklist Card
                    Card(
                      color: Colors.grey.shade100,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Checklist'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '8/10',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CircularProgressIndicator(
                                  value: 0.8,
                                  color: Colors.deepPurple,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Map Card
                Card(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16/9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('Map View'),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View map'),
                      ),
                    ],
                  ),
                ),

                // Mileage Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mileage'),
                        const Text(
                          '10,030,409',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expenditures Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Expenditures'),
                        const Text(
                          '₦ 100,030,409.50',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('View report'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Reminders Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Reminders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Reminder Card
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.water_drop, color: Colors.orange),
                    title: Text('Oil change'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('3:00PM'),
                        Text('23/04/2024'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
