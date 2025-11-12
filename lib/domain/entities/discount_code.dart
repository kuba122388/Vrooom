class DiscountCode {
  final int? id;
  final String? code;
  final double? value;
  final bool? percentage;
  final bool? active;

  DiscountCode({
    required this.id,
    required this.code,
    required this.value,
    required this.percentage,
    required this.active,
  });
}