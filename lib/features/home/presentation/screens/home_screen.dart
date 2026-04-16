// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:halal_dublin/core/widgets/responsive_layout.dart';
import 'package:halal_dublin/features/restaurants/presentation/screens/restaurant_list_screen.dart';
import 'nearby_screen.dart';
import 'suggest_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    RestaurantListScreen(),
    NearbyScreen(),
    SuggestScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Nearby',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'Suggest',
            ),
          ],
        ),
      ),
      desktop: Scaffold(
        body: Row(
          children: [
            // Simple sidebar
            Container(
              width: 200,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Halal Dublin',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _buildNavItem(0, Icons.restaurant, 'Discover'),
                  _buildNavItem(1, Icons.location_on, 'Nearby'),
                  _buildNavItem(2, Icons.add_circle, 'Suggest'),
                ],
              ),
            ),
            // Main content
            Expanded(child: _screens[_selectedIndex]),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _selectedIndex == index,
      onTap: () => setState(() => _selectedIndex = index),
    );
  }
}
