import 'package:flutter/material.dart';
import 'package:vrooom/presentation/bookings/widgets/booking_car_tile.dart';

import '../../../core/configs/theme/app_spacing.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _penalties = ["1"];
    List<String> _active = ["1"];
    List<String> _upcoming = ["1"];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            if (_penalties.isNotEmpty) ...[
              BookingCarTile(
                title: "Penalty Section",
                penalty: "\$200 Penalty",
              ),
              SizedBox(
                height: AppSpacing.md,
              ),
            ],
            if (_active.isNotEmpty) ...[
              BookingCarTile(
                title: "Active Rentals",
              ),
              SizedBox(
                height: AppSpacing.md,
              ),
            ],
            if (_upcoming.isNotEmpty) ...[
              BookingCarTile(
                title: "Upcoming Rentals",
              ),
              SizedBox(
                height: AppSpacing.md,
              ),
            ],
            Opacity(
              opacity: 0.5,
              child: BookingCarTile(
                title: "Rental History",
              ),
            ),
            SizedBox(
              height: AppSpacing.md,
            ),
          ],
        ),
      ),
    );
  }
}
