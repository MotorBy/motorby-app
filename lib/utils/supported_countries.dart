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

  String get label => '$name ($dialCode)';

  /// Full E.164 number, e.g. +2348031234567. Empty in, empty out, so a blank
  /// field never reaches the backend as a bare dial code.
  String e164(String nationalNumber) {
    final digits = nationalDigits(nationalNumber);
    return digits.isEmpty ? '' : '$dialCode$digits';
  }
}

const List<SupportedCountry> kSupportedCountries = [
  SupportedCountry(
    name: 'Nigeria',
    isoCode: 'NG',
    dialCode: '+234',
    minDigits: 10,
    maxDigits: 10,
    sampleNumber: '8031234567',
  ),
  SupportedCountry(
    name: 'Austria',
    isoCode: 'AT',
    dialCode: '+43',
    minDigits: 4,
    maxDigits: 13,
    sampleNumber: '6641234567',
  ),
  SupportedCountry(
    name: 'Ghana',
    isoCode: 'GH',
    dialCode: '+233',
    minDigits: 9,
    maxDigits: 9,
    sampleNumber: '241234567',
  ),
  SupportedCountry(
    name: 'Kenya',
    isoCode: 'KE',
    dialCode: '+254',
    minDigits: 9,
    maxDigits: 9,
    sampleNumber: '712345678',
  ),
  SupportedCountry(
    name: 'United States',
    isoCode: 'US',
    dialCode: '+1',
    minDigits: 10,
    maxDigits: 10,
    sampleNumber: '2015551234',
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
