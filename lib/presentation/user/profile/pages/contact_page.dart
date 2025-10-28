import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/presentation/user/profile/widgets/map_widget.dart';

import '../../../../core/common/widgets/app_svg.dart';
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
      _contactRow(AppVectors.mapPin, "Ul. Przykładowa 12, 00-123 Łódź"),
      _contactRow(AppVectors.phone, "+48 123 456 789  "),
      _contactRow(AppVectors.mail, "carrentlodz@gmail.com"),
      _contactRow(AppVectors.clock, "Mon-Fri, 9:00 AM – 5:00 PM"),
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
                title: "Contact Us!",
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
                      text: "Go to rental location",
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

  Row _contactRow(String svgAsset, String label) {
    return Row(
      children: [
        AppSvg(asset: svgAsset),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: const TextStyle(fontSize: 14.0)),
      ],
    );
  }
}
