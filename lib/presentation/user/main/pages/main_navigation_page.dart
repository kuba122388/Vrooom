import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_bottom_bar.dart';
import 'package:vrooom/presentation/user/bookings/pages/booking_page.dart';
import 'package:vrooom/presentation/user/listings/pages/listings_page.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../profile/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ListingsPage(),
    const BookingsPage(),
    const ProfilePage(),
  ];

  final List<TabItem> _tabs = [
    const TabItem(
      page: ListingsPage(),
      title: "Stationary Car Rentals",
    ),
    const TabItem(
      page: BookingsPage(),
      title: "Your Bookings",
    ),
    const TabItem(
      page: ProfilePage(),
      title: "Profile",
    ),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _tabs[_currentIndex].title,
        showBackButton: false,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}

class TabItem {
  final Widget page;
  final String title;

  const TabItem({
    required this.page,
    required this.title,
  });
}
