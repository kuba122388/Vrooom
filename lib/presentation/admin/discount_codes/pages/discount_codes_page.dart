import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/configs/di/service_locator.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/entities/discount_code.dart';
import 'package:vrooom/domain/usecases/discount_codes/get_all_discount_codes_usecase.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/discount_code_entry.dart';

class DiscountCodesPage extends StatefulWidget {
  const DiscountCodesPage({super.key});

  @override
  State<DiscountCodesPage> createState() => _DiscountCodesPageState();
}

class _DiscountCodesPageState extends State<DiscountCodesPage> {
  final GetAllDiscountCodesUseCase _getAllDiscountCodesUsecase = sl();

  bool _isLoading = true;
  String? _errorMessage;
  bool _activeCode = true;

  List<DiscountCode> _allCodesList = [];
  List<DiscountCode> _displayedCodesList = [];

  @override
  void initState() {
    super.initState();
    _loadDiscountCodes();
  }

  Future<void> _loadDiscountCodes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getAllDiscountCodesUsecase();

    result.fold(
          (error) {
        print("=== ERROR OCCURED === $error");
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
      },
          (codesList) {
            ("=== DISCOUNT CODES LOADED ===");
        setState(() {
          _allCodesList = codesList;
          _filterCodes();
          _isLoading = false;
        });
      },
    );
  }

  void _filterCodes() {
    setState(() {
      if (_activeCode) {
        _displayedCodesList = _allCodesList
            .where((code) => code.active == true)
            .toList();
      } else {
        _displayedCodesList = _allCodesList
            .where((code) => code.active != true)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      _filterCodes();
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
                      _filterCodes();
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
            Expanded(
              child: LoadingWidget(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                futureResultObj: _displayedCodesList,
                emptyResultMsg: _activeCode
                    ? "No active codes found."
                    : "No expired codes found.",
                futureBuilder: _buildCodesList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodesList() {
    return ListView.separated(
      itemCount: _displayedCodesList.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final codeEntity = _displayedCodesList[index];

        return DiscountCodeEntry(
          code: codeEntity.code ?? "",
          discount: codeEntity.value ?? 0.0,
          type: (codeEntity.percentage ?? false) ? "Percentage" : "Fixed",
          codeStatus: (codeEntity.active ?? false) ? CodeStatus.active : CodeStatus.inactive,
        );
      },
    );
  }
}