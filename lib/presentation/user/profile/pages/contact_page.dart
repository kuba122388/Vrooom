import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_text_styles.dart';
import 'package:vrooom/presentation/user/profile/widgets/contact_row.dart';
import 'package:vrooom/presentation/user/profile/widgets/map_widget.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  VoidCallback? _centerMapCallback;

  @override
  Widget build(BuildContext context) {
    List<Widget> infoSection = [
      const ContactRow(svgAsset: AppVectors.mapPin, label: "Ul. Przykładowa 12, 00-123 Łódź"),
      const ContactRow(svgAsset: AppVectors.phone, label: "+48 123 456 789"),
      const ContactRow(svgAsset: AppVectors.mail, label: "carrentlodz@gmail.com"),
      const ContactRow(svgAsset: AppVectors.clock, label: "Mon-Fri, 9:00 AM – 5:00 PM"),
    ];

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Contact Information",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
          child: Column(
            children: [
              InfoSectionCard(
                title: "Main rental office!",
                child: Column(
                  children: infoSection
                      .expand(
                        (widget) => [
                          widget,
                          const SizedBox(height: AppSpacing.xs),
                        ],
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                title: "Find Us!",
                child: Column(
                  children: [
                    SizedBox(
                      height: 250.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: MapWidget(
                          onMapReady: (centerToOffice) {
                            setState(() {
                              _centerMapCallback = centerToOffice;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      textStyle: AppTextStyles.smallButton,
                      text: "Go to main rental location",
                      onPressed: () {
                        _centerMapCallback?.call();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
