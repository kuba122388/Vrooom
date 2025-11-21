import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../configs/theme/app_spacing.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() refreshFunction;
  final dynamic futureResultObj;
  final String emptyResultMsg;
  final Widget Function() futureBuilder;
  final Widget Function()? staticBuilder;
  final bool shouldHavePadding;

  const LoadingWidget({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    this.futureResultObj,
    required this.emptyResultMsg,
    required this.futureBuilder,
    required this.refreshFunction,
    this.staticBuilder,
    this.shouldHavePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: shouldHavePadding
            ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0)
            : EdgeInsetsGeometry.zero,
        child: Column(
          children: [
            if (staticBuilder != null) staticBuilder!(),
            if (isLoading) ...[
              SizedBox(
                height: staticBuilder == null ? MediaQuery.of(context).size.height * 0.75 : null,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              )
            ] else if (errorMessage != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                    PrimaryButton(
                      text: "Reload",
                      onPressed: () => refreshFunction(),
                    ),
                  ],
                ),
              )
            else if (futureResultObj == null || futureResultObj is List && futureResultObj.isEmpty)
              Center(
                child: Text(
                  emptyResultMsg,
                  style: const TextStyle(fontSize: 16.0),
                ),
              )
            else
              SingleChildScrollView(
                child: Column(
                  children: [
                    futureBuilder(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
