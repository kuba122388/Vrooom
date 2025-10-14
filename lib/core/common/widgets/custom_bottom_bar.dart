import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/assets/app_vectors.dart';
import '../../configs/theme/app_colors.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;

  final List<String> _labels = ["Listings", "Booking", "Profile"];
  final List<String> _icons = [
    AppVectors.carFront,
    AppVectors.booking,
    AppVectors.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 1,
          color: AppColors.container.neutral800,
        ),
        BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.text.neutral400,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          backgroundColor: Colors.black,
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
            letterSpacing: -0.3,
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: List.generate(_labels.length, (index) {
            final isSelected = _currentIndex == index;
            return BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(
                  _icons[index],
                  height: isSelected ? 24 : 20,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.primary : AppColors.text.neutral400,
                    BlendMode.srcATop,
                  ),
                ),
              ),
              label: _labels[index],
            );
          }),
        ),
      ],
    );
  }
}
