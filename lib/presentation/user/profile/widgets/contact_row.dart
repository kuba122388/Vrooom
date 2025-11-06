import 'package:flutter/cupertino.dart';
import '../../../../core/common/widgets/app_svg.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class ContactRow extends StatelessWidget {
  final String svgAsset;
  final String label;

  const ContactRow({
    super.key,
    required this.svgAsset,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSvg(asset: svgAsset),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: const TextStyle(fontSize: 14.0)),
      ],
    );
  }
}