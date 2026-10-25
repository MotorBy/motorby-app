import 'dart:convert' as JSON;

import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';

/// Stripe leg of the payment routing, used for the currencies Paystack cannot
/// charge (today: EUR, for Austria).
///
/// INCOMPLETE BY DESIGN. Two things are missing and neither can be written
/// from inside the app:
///
///   1. [APIKey.stripePublishableKey] is empty. It has to come from the
///      Stripe dashboard. The secret key must NEVER be put in the app.
///   2. [APIService.createStripeIntent] has to exist on the backend. A charge
///      is created server-side, because creating one from the client would
///      mean shipping the secret key.
///
/// Until both are in place [isConfigured] is false and the UI tells the user
/// that payments are not available in their region yet, instead of opening a
/// sheet that cannot complete. Finishing this also needs the `flutter_stripe`
/// package and its platform setup; see the notes on [confirmPayment].
class StripeService {

  /// False until a publishable key is set. Callers check this before offering
  /// a Stripe payment so nobody gets a dead payment sheet.
  static bool get isConfigured => APIKey.stripePublishableKey.isNotEmpty;

  /// Asks our backend to create a PaymentIntent and returns its client secret.
  ///
  /// [amountMinorUnits] is in the currency's smallest unit, the same
  /// convention Paystack uses here (EUR 12.50 -> 1250).
  Future<String> createPaymentIntent({
    required int amountMinorUnits,
    required String currencyCode,
    required String email,
    required String reference,
  }) async {

    if (!isConfigured) {
      throw Exception('Card payments are not available in your region yet');
    }

    final response = await http.post(
      Uri.parse(APIService.createStripeIntent),
      headers: APIHelper().requestHeadersWithToken(),
      body: JSON.json.encode({
        'amount': amountMinorUnits,
        'currency': currencyCode.toLowerCase(),
        'email': email,
        'reference': reference,
      }),
    );

    final json = JSON.jsonDecode(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(json['message'] ?? 'Could not start this payment');
    }

    final clientSecret = json['payload']?['client_secret'] ?? json['client_secret'];
    if (clientSecret == null) {
      throw Exception('Payment could not be started. Please try again.');
    }

    return clientSecret as String;
  }

  /// Presents Stripe's payment sheet and confirms the charge.
  ///
  /// NOT IMPLEMENTED. This needs the `flutter_stripe` package, which is not a
  /// dependency yet, plus its platform setup (Android: minSdk 21 and a
  /// FlutterFragmentActivity host; iOS: deployment target 13+). Once added it
  /// is roughly:
  ///
  ///   await Stripe.instance.initPaymentSheet(
  ///     paymentSheetParameters: SetupPaymentSheetParameters(
  ///       paymentIntentClientSecret: clientSecret,
  ///       merchantDisplayName: 'Motorby',
  ///     ),
  ///   );
  ///   await Stripe.instance.presentPaymentSheet();
  ///
  /// Left unwritten rather than stubbed out as a fake success, so nothing can
  /// mistake an unfinished integration for a completed payment.
  Future<void> confirmPayment({required String clientSecret}) async {
    throw UnimplementedError(
      'Stripe payment sheet is not wired up yet. Add the flutter_stripe '
      'package and complete StripeService.confirmPayment.',
    );
  }
}
