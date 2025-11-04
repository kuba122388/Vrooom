import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final dynamic futureResultObj;
  final String emptyResultMsg;
  final Widget Function() futureBuilder;

  const LoadingWidget(
      {super.key,
      required this.isLoading,
      required this.errorMessage,
      this.futureResultObj,
      required this.emptyResultMsg,
      required this.futureBuilder});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (futureResultObj == null || futureResultObj is List && futureResultObj.isEmpty) {
      return Center(child: Text(emptyResultMsg));
    }

    return futureBuilder();
  }
}
