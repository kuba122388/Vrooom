import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  final List<String> items;
  final String label;
  final void Function(String)? onSelected;
  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;



  const CustomDropdownMenu({
    super.key,
    required this.items,
    required this.label,
    this.onSelected,
    this.initialValue,
    this.controller,
    this.hintText
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
    return DropdownMenu<String>(
      hintText: widget.hintText,
      controller: widget.controller,
      label: Text(widget.label),
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
    );
  }
}
