import 'package:vrooom/domain/entities/stripe_session.dart';

class StripeSessionModel extends StripeSession {
  StripeSessionModel({
    required super.url,
    required super.sessionId,
  });

  factory StripeSessionModel.fromJson(Map<String, dynamic> json) {
    return StripeSessionModel(
      url: json["url"] as String? ?? "",
      sessionId: json["sessionId"] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "sessionId": sessionId,
    };
  }

  factory StripeSessionModel.fromEntity(StripeSession entity) {
    return StripeSessionModel(
      url: entity.url,
      sessionId: entity.sessionId,
    );
  }

  StripeSession toEntity() {
    return StripeSession(
      url: url,
      sessionId: sessionId,
    );
  }
}
