import 'package:mobile_auto_drive/utils/supported_countries.dart';

/// Which processor can take money in a given currency.
///
/// Paystack covers the African markets and USD. It has no EUR support at all,
/// so euro charges have to go somewhere else.
enum PaymentGateway { paystack, stripe }

/// Currencies Paystack can charge, taken from PaystackCurrency in the vendored
/// flutter_paystack_max package. Keep the two in step.
const Set<String> kPaystackCurrencies = {'NGN', 'GHS', 'USD', 'ZAR', 'KES'};

/// Currencies routed to Stripe. Everything Paystack cannot take and that we
/// have decided to support lands here.
const Set<String> kStripeCurrencies = {'EUR'};

/// Picks the processor for a currency, or null when nothing can charge it.
///
/// Null is a real answer, not a failure: it means this market cannot be billed
/// yet and the UI should say so rather than opening a payment sheet that will
/// be rejected.
PaymentGateway? gatewayForCurrency(String? currencyCode) {
  final code = (currencyCode ?? '').toUpperCase();
  if (code.isEmpty) return null;
  if (kPaystackCurrencies.contains(code)) return PaymentGateway.paystack;
  if (kStripeCurrencies.contains(code)) return PaymentGateway.stripe;
  return null;
}

PaymentGateway? gatewayForCountry(SupportedCountry country) =>
    gatewayForCurrency(country.currencyCode);

/// Whether this market can be charged at all right now.
bool canTakePaymentIn(SupportedCountry country) =>
    gatewayForCountry(country) != null;
