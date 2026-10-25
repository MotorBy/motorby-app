/// Countries Motorby currently accepts sign-ups from.
///
/// The sign-up form no longer asks for a country: it is derived from the
/// dial code attached to the phone number. Adding a country here is all that
/// is needed to open sign-up to it.
class SupportedCountry {
  const SupportedCountry({
    required this.name,
    required this.isoCode,
    required this.dialCode,
    required this.minDigits,
    required this.maxDigits,
    required this.sampleNumber,
    required this.currencyCode,
    required this.currencySymbol,
    required this.features,
  });

  /// Value sent to the backend as `country`.
  final String name;
  final String isoCode;

  /// Includes the leading '+'.
  final String dialCode;

  /// Length bounds of the national number, i.e. after the dial code and any
  /// trunk '0' have been stripped.
  final int minDigits;
  final int maxDigits;

  /// Shown as the field hint so the expected format is obvious.
  final String sampleNumber;

  /// ISO 4217 code this market is billed in, and the symbol to print.
  final String currencyCode;
  final String currencySymbol;

  /// What Motorby actually offers here. Anything not listed is hidden rather
  /// than shown and then failing when the user taps it.
  final Set<MarketFeature> features;

  bool offers(MarketFeature feature) => features.contains(feature);

  String get label => '$name ($dialCode)';

  /// Full E.164 number, e.g. +2348031234567. Empty in, empty out, so a blank
  /// field never reaches the backend as a bare dial code.
  String e164(String nationalNumber) {
    final digits = nationalDigits(nationalNumber);
    return digits.isEmpty ? '' : '$dialCode$digits';
  }
}

/// Parts of Motorby that are only live in some markets. A country that does
/// not list a feature hides it rather than offering something that will fail.
enum MarketFeature {
  /// Insurance products are sourced per-market; only Nigeria has providers.
  insurance,

  /// The fuel price API is only populated for the African markets.
  fuelPrices,
}

const List<SupportedCountry> kSupportedCountries = [
  SupportedCountry(
    name: 'Nigeria',
    isoCode: 'NG',
    dialCode: '+234',
    minDigits: 10,
    maxDigits: 10,
    sampleNumber: '8031234567',
    currencyCode: 'NGN',
    currencySymbol: '₦',
    features: {MarketFeature.insurance, MarketFeature.fuelPrices},
  ),
  SupportedCountry(
    name: 'Austria',
    isoCode: 'AT',
    dialCode: '+43',
    minDigits: 4,
    maxDigits: 13,
    sampleNumber: '6641234567',
    currencyCode: 'EUR',
    currencySymbol: '€',
    features: {},
  ),
  SupportedCountry(
    name: 'Ghana',
    isoCode: 'GH',
    dialCode: '+233',
    minDigits: 9,
    maxDigits: 9,
    sampleNumber: '241234567',
    currencyCode: 'GHS',
    currencySymbol: 'GH₵',
    features: {MarketFeature.fuelPrices},
  ),
  SupportedCountry(
    name: 'Kenya',
    isoCode: 'KE',
    dialCode: '+254',
    minDigits: 9,
    maxDigits: 9,
    sampleNumber: '712345678',
    currencyCode: 'KES',
    currencySymbol: 'KSh',
    features: {MarketFeature.fuelPrices},
  ),
  SupportedCountry(
    name: 'United States',
    isoCode: 'US',
    dialCode: '+1',
    minDigits: 10,
    maxDigits: 10,
    sampleNumber: '2015551234',
    currencyCode: 'USD',
    currencySymbol: '\$',
    features: {},
  ),
];

SupportedCountry get defaultCountry => kSupportedCountries.first;

/// Strips everything but digits, then drops the trunk '0' that people habitually
/// type in front of a local number ('0803...' -> '803...').
String nationalDigits(String raw) {
  var digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  while (digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  return digits;
}

/// Matches a pasted international number against the supported dial codes,
/// longest code first so '+234' never loses to a shorter prefix.
///
/// Accepts '+234...' and '00234...'. Returns null when nothing matches, which
/// includes every country we have not launched in yet.
SupportedCountry? countryFromDialCode(String raw) {
  var input = raw.trim().replaceAll(RegExp(r'[\s\-()]'), '');
  if (input.startsWith('00')) {
    input = '+${input.substring(2)}';
  }
  if (!input.startsWith('+')) return null;

  final byLongestCode = [...kSupportedCountries]
    ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

  for (final country in byLongestCode) {
    if (input.startsWith(country.dialCode)) return country;
  }
  return null;
}

/// Removes a leading dial code from [raw] if one of ours is present.
String stripDialCode(String raw, SupportedCountry country) {
  var input = raw.trim().replaceAll(RegExp(r'[\s\-()]'), '');
  if (input.startsWith('00')) {
    input = '+${input.substring(2)}';
  }
  if (input.startsWith(country.dialCode)) {
    return input.substring(country.dialCode.length);
  }
  return raw;
}

/// Validates the national part of a number against the selected country.
/// Returns null when valid, otherwise the message to show under the field.
String? validatePhoneNumber(String? raw, SupportedCountry country) {
  final digits = nationalDigits(raw ?? '');
  if (digits.isEmpty) return 'Enter your phone number';
  if (digits.length < country.minDigits || digits.length > country.maxDigits) {
    return country.minDigits == country.maxDigits
        ? 'A ${country.name} number has ${country.minDigits} digits'
        : 'Enter a valid ${country.name} number';
  }
  return null;
}

/// Looks a country up by the name stored on the user's profile.
///
/// Falls back to the default rather than returning null: an account created
/// before a country was recorded, or one whose country we no longer support,
/// still has to render a currency and a feature set somewhere.
SupportedCountry countryByName(String? name) {
  if (name == null || name.isEmpty) return defaultCountry;

  final wanted = name.trim().toLowerCase();
  for (final country in kSupportedCountries) {
    if (country.name.toLowerCase() == wanted ||
        country.isoCode.toLowerCase() == wanted) {
      return country;
    }
  }

  // 'USA' and 'United States of America' are both common in older records.
  if (wanted.contains('united states') || wanted == 'usa' || wanted == 'us') {
    return kSupportedCountries.firstWhere((c) => c.isoCode == 'US');
  }

  return defaultCountry;
}
