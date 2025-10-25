import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/discount_code_entry.dart';

class DiscountCodesPage extends StatefulWidget {
  const DiscountCodesPage({super.key});

  @override
  State<DiscountCodesPage> createState() => _DiscountCodesPageState();
}

class _DiscountCodesPageState extends State<DiscountCodesPage> {
  bool _activeCode = true;

  @override
  Widget build(BuildContext context) {
    List<DiscountCodeEntry> activeCodes = [
      DiscountCodeEntry(
        code: 'SUMMER2023',
        discount: 15,
        type: 'Percentage',
        startDate: DateTime(2023, 6, 1),
        endDate: DateTime(2023, 8, 31),
        codeStatus: CodeStatus.active,
      ),
      DiscountCodeEntry(
        code: 'WINTERSALE20',
        discount: 20,
        type: 'Flat',
        startDate: DateTime(2023, 12, 1),
        endDate: DateTime(2023, 12, 31),
        codeStatus: CodeStatus.active,
      ),
      DiscountCodeEntry(
        code: 'BLACKFRIDAY50',
        discount: 50,
        type: 'Percentage',
        startDate: DateTime(2023, 11, 23),
        endDate: DateTime(2023, 11, 24),
        codeStatus: CodeStatus.inactive,
      ),
      DiscountCodeEntry(
        code: 'NEWYEAR2024',
        discount: 25,
        type: 'Flat',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 15),
        codeStatus: CodeStatus.active,
      ),
      DiscountCodeEntry(
        code: 'SPRINGSALE10',
        discount: 10,
        type: 'Percentage',
        startDate: DateTime(2024, 3, 1),
        endDate: DateTime(2024, 3, 31),
        codeStatus: CodeStatus.active,
      ),
      DiscountCodeEntry(
        code: 'AUTUMN25',
        discount: 25,
        type: 'Flat',
        startDate: DateTime(2023, 9, 1),
        endDate: DateTime(2023, 9, 30),
        codeStatus: CodeStatus.inactive,
      ),
      DiscountCodeEntry(
        code: 'VALENTINE2024',
        discount: 30,
        type: 'Percentage',
        startDate: DateTime(2024, 2, 1),
        endDate: DateTime(2024, 2, 14),
        codeStatus: CodeStatus.active,
      )
    ];

    List<DiscountCodeEntry> expiredCodes = [
      DiscountCodeEntry(
        code: 'BLACKFRIDAY80',
        discount: 80,
        type: 'Percentage',
        startDate: DateTime(2023, 11, 25),
        endDate: DateTime(2023, 11, 26),
        codeStatus: CodeStatus.active,
      ),
      DiscountCodeEntry(
        code: 'WINTER2023SALE',
        discount: 40,
        type: 'Flat',
        startDate: DateTime(2023, 12, 1),
        endDate: DateTime(2023, 12, 20),
        codeStatus: CodeStatus.active,
      ),
      DiscountCodeEntry(
        code: 'CYBERMONDAY10',
        discount: 10,
        type: 'Percentage',
        startDate: DateTime(2023, 11, 27),
        endDate: DateTime(2023, 11, 28),
        codeStatus: CodeStatus.inactive,
      )
    ];

    return Scaffold(
      appBar: const AdminAppBar(title: "Discount Codes"),
      drawer: const AdminDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 220,
        child: FloatingActionButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                "Add New Promo Code",
                style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _activeCode = true;
                      });
                    },
                    style: _activeCode
                        ? ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0))
                        : ElevatedButton.styleFrom(
                            foregroundColor: AppColors.text.neutral400,
                            backgroundColor: AppColors.container.neutral900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
                    child: const Text(
                      "Active Codes",
                      style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _activeCode = false;
                      });
                    },
                    style: !_activeCode
                        ? ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0))
                        : ElevatedButton.styleFrom(
                            foregroundColor: AppColors.text.neutral400,
                            backgroundColor: AppColors.container.neutral900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
                    child: const Text(
                      "Expired Codes",
                      style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_activeCode) ...[
              Expanded(
                child: ListView.builder(
                    itemCount: activeCodes.length * 2 - 1,
                    itemBuilder: (context, index) {
                      if (index.isOdd) {
                        return const SizedBox(height: AppSpacing.sm);
                      }

                      final entry = activeCodes[index ~/ 2];

                      return DiscountCodeEntry(
                        code: entry.code,
                        discount: entry.discount,
                        type: entry.type,
                        startDate: entry.startDate,
                        endDate: entry.endDate,
                        codeStatus: entry.codeStatus,
                      );
                    }),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: expiredCodes.length * 2 - 1,
                  itemBuilder: (context, index) {
                    if (index.isOdd) {
                      return const SizedBox(height: AppSpacing.sm);
                    }

                    final entry = expiredCodes[index ~/ 2];

                    return DiscountCodeEntry(
                      code: entry.code,
                      discount: entry.discount,
                      type: entry.type,
                      startDate: entry.startDate,
                      endDate: entry.endDate,
                      codeStatus: entry.codeStatus,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
