import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/presentation/user/profile/widgets/privacy_policy_model.dart';

import '../../../../core/configs/theme/app_spacing.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PrivacyPolicyModel> privacyPolicy = [
      PrivacyPolicyModel(title: "1. General Information", text: "This Privacy Policy defines the rules for the processing and protection of personal data of users of the website operated by Vrooom, headquartered at Stefana Żeromskiego 116, 90-924 Łódź."),
      PrivacyPolicyModel(title: "2. Data Controller", text: "The data controller is Vrooom (hereinafter referred to as the 'Controller'), which processes data in accordance with Regulation (EU) 2016/679 of the European Parliament and of the Council (GDPR)."),
      PrivacyPolicyModel(title: "3. Scope of Processed Data", text: "While using the website, we may process the following personal data:\n\n• first and last name\n• email address\n• phone number\n• residential address"),
      PrivacyPolicyModel(title: "4. Purposes of Data Processing", text: "Personal data are processed for the following purposes:\n\n• vehicle reservation processing\n• contact with the client regarding reservations or service usage\n• issuing invoices and maintaining accounting records\n• managing the user's account on the website"),
      PrivacyPolicyModel(title: "5. Legal Basis for Processing", text: "Data are processed in accordance with Article 6(1)(b), (c), and (f) of the GDPR – i.e., for the performance of a contract, compliance with legal obligations, and based on the legitimate interests of the controller (e.g., user account management, customer communication)."),
      PrivacyPolicyModel(title: "6. Login and User Accounts", text: "Users can create an account on the website using:\n\n• registration via email\n• login via external accounts: Google or Facebook"),
      PrivacyPolicyModel(title: "7. Cookies", text: "The website uses cookies for the following purposes:\n\n• maintaining the session of a logged-in user\n• ensuring proper website functionality"),
      PrivacyPolicyModel(title: "8. Data Recipients", text: "Personal data are not shared with third parties, except as required by law (e.g., tax authorities). We do not transfer data outside the European Economic Area (EEA)."),
      PrivacyPolicyModel(title: "9. Data Retention Period", text: "Personal data are retained:\n\n• for the duration of the user account – until it is deleted\n• until a request for data deletion is submitted\n• in accordance with tax law requirements (e.g., invoice-related data – for 5 years)"),
      PrivacyPolicyModel(title: "10. User Rights", text: "Users have the following rights:\n\n• right to access their data\n• right to rectify, delete ('right to be forgotten') or restrict processing\n• right to data portability\n• right to object to processing\n• right to lodge a complaint with the Data Protection Authority"),
      PrivacyPolicyModel(title: "11. Account Deletion", text: "User accounts can be deleted in person by visiting the company’s headquarters: Stefana Żeromskiego 116, 90-924 Łódź."),
      PrivacyPolicyModel(title: "12. Changes to the Privacy Policy", text: "The Controller reserves the right to make changes to this Privacy Policy. Changes will be published on the website and take effect upon publication.")
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: "Privacy Policy"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              ...privacyPolicy
                  .map((policy) {
                return Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    InfoSectionCard(title: policy.title, child: Text(policy.text)),
                  ],
                );
              }),
              const SizedBox(height: AppSpacing.md)
            ]
          ),
        ),
      ),
    );
  }
}