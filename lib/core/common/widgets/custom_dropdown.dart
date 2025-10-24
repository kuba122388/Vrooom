import 'package:flutter/material.dart';

import '../../configs/theme/app_spacing.dart';
import '../../configs/theme/app_text_styles.dart';
import 'app_svg.dart';

class CustomDropdownMenu extends StatefulWidget {
  final List<String> items;
  final String label;
  final void Function(String)? onSelected;
  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final AppSvg? leadingIcon;




  const CustomDropdownMenu({
    super.key,
    required this.items,
    required this.label,
    this.onSelected,
    this.initialValue,
    this.controller,
    this.hintText,
    this.leadingIcon
  });

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label,
          ),
          const SizedBox(height: AppSpacing.xs)
        ],
        DropdownMenu<String>(
          width: double.infinity,
          leadingIcon: Padding(
            padding: widget.leadingIcon == null ? EdgeInsets.zero : const EdgeInsets.all(12.0),
            child: widget.leadingIcon,
          ),
          hintText: widget.hintText,
          controller: widget.controller,
          label: Text(widget.label),
          menuStyle: MenuStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)
              )
            )
          ),
          initialSelection: selectedValue,
          onSelected: (value) {
            setState(() {
              selectedValue = value;
            });
            if (widget.onSelected != null && value != null) {
              widget.onSelected!(value);
            }
          },
          dropdownMenuEntries: widget.items.map((item) => DropdownMenuEntry<String>(
            value: item,
            label: item,
          ))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
