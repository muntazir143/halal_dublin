import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halal_dublin/core/theme/app_colors.dart';
import 'package:halal_dublin/features/home/presentation/screens/nearby_screen.dart';
import 'package:halal_dublin/features/home/presentation/screens/suggest_screen.dart';
import 'package:halal_dublin/features/restaurants/presentation/screens/restaurant_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    RestaurantListScreen(),
    NearbyScreen(),
    SuggestScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant, size: 20),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, size: 20),
            label: 'Nearby',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 20),
            label: 'Suggest',
          ),
        ],
      ),
    );
  }
}
