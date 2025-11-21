import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrooom/core/common/widgets/custom_bottom_bar.dart';
import 'package:vrooom/presentation/user/bookings/pages/booking_page.dart';
import 'package:vrooom/presentation/user/listings/pages/listings_page.dart';

import '../../../../core/common/widgets/app_svg.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../profile/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  bool _hasActiveRentals = false;

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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _tabs[_currentIndex].title,
        showBackButton: false,
      ),
      body: _buildPage(_currentIndex),
      floatingActionButton: _currentIndex == 1 && _hasActiveRentals
          ? FloatingActionButton(
              onPressed: () async {
                await _makePhoneCall("+48 123 456 789");
              },
              backgroundColor: AppColors.container.progress200,
              child: const AppSvg(asset: AppVectors.phone),
            )
          : null,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }

  Widget _buildPage(int index) {
    if (index == 1) {
      return BookingsPage(
        onActiveRentalsLoaded: (hasActive) {
          setState(() => _hasActiveRentals = hasActive);
        },
      );
    }
    return _pages[index];
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
