import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';

/// Route payload shared by the Phone, Tablet and Web auth compositions.
///
/// This is navigation data, not a presentation widget contract. Keeping it in
/// [app/router/contracts] prevents one surface from importing another surface
/// merely to decode an OTP route.
final class OtpPageRouteArgs {
  const OtpPageRouteArgs({this.contact, this.contactType, this.purpose});

  final String? contact;
  final AuthContactType? contactType;
  final AuthOtpPurpose? purpose;
}
