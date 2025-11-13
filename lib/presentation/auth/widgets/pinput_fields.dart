import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class PinputFields extends StatefulWidget {
  const PinputFields({Key? key}) : super(key: key);

  @override
  State<PinputFields> createState() => _PinputFieldsState();
}

class _PinputFieldsState extends State<PinputFields> {
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: AppColors.text.neutral400,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                enableInteractiveSelection: true,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 8),
                validator: (value) {
                  return value == '2222' ? null : 'Pin is incorrect';
                },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                  if (pin == '2222') {
                    Navigator.pushNamed(context, AppRoutes.verifyEmailSuccess);
                  }
                  if (pin == '1111') {
                    Navigator.pushNamed(context, AppRoutes.changePassword);
                  }
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                },
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: "Didn't get a code?  "),
                  TextSpan(
                    text: 'Resend: 59 s',
                    style: TextStyle(color: AppColors.primary.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              onPressed: () {
                focusNode.unfocus();
                formKey.currentState!.validate();
                if (pinController.text == '2222') {
                  Navigator.pushNamed(context, AppRoutes.verifyEmailSuccess);
                }
              },
              text: 'Submit',
            ),
          ],
        ),
      ),
    );
  }
}
