import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/configs/di/service_locator.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/entities/discount_code.dart';
import 'package:vrooom/domain/usecases/discount_codes/add_discount_code_usecase.dart';
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
  final AddDiscountCodeUseCase _addDiscountCodeUseCase = sl();

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
        print("=== DISCOUNT CODES LOADED ===");
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
        _displayedCodesList = _allCodesList.where((code) => code.active == true).toList();
      } else {
        _displayedCodesList = _allCodesList.where((code) => code.active != true).toList();
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
          onPressed: _showAddCodeDialog,
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
                emptyResultMsg: _activeCode ? "No active codes found." : "No expired codes found.",
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
      padding: const EdgeInsets.only(bottom: 80.0),
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

  void _showAddCodeDialog() {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();
    final valueController = TextEditingController();

    bool isPercentage = false;
    bool isDialogLoading = false;
    String? dialogErrorMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add New Promo Code"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        label: "Code",
                        hintText: "Enter a code",
                        controller: codeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a code";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CustomTextField(
                        label: "Discount value",
                        hintText: "Enter a discount value",
                        controller: valueController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a discount value";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                      SwitchListTile(
                        title: const Text("Percentage?"),
                        value: isPercentage,
                        onChanged: (bool value) {
                          setDialogState(() {
                            isPercentage = value;
                          });
                        },
                        activeThumbColor: AppColors.background,
                        inactiveThumbColor: AppColors.container.neutral900,
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.container.neutral700,
                      ),
                      if (isDialogLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: CircularProgressIndicator(),
                        ),
                      if (dialogErrorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            dialogErrorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PrimaryButton(
                        text: "Add code",
                        onPressed: isDialogLoading
                            ? null
                            : () async {
                          if (formKey.currentState!.validate()) {
                            setDialogState(() {
                              isDialogLoading = true;
                              dialogErrorMessage = null;
                            });

                            final newCode = DiscountCode(
                              id: null,
                              code: codeController.text,
                              value: double.tryParse(valueController.text) ?? 0.0,
                              percentage: isPercentage,
                              active: true,
                            );

                            final result = await _addDiscountCodeUseCase(newCode);

                            result.fold(
                                  (error) {
                                setDialogState(() {
                                  isDialogLoading = false;
                                  dialogErrorMessage = error;
                                });
                              },
                                  (success) {
                                Navigator.pop(context);
                                _loadDiscountCodes();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Code added successfully!"), backgroundColor: Colors.green),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),

                  ],
                )

              ],
            );
          },
        );
      },
    );
  }
}
}
