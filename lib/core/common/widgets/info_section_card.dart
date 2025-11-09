import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_container.dart';
import 'package:vrooom/core/common/widgets/title_widget.dart';

class InfoSectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const InfoSectionCard({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                TitleWidget(title: title as String),
              ],
              child
            ],
          ),
        ),
      ],
    );
  }
}
