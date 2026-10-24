import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';

void main() {
  final ng = kSupportedCountries.firstWhere((c) => c.isoCode == 'NG');
  final gh = kSupportedCountries.firstWhere((c) => c.isoCode == 'GH');
  final us = kSupportedCountries.firstWhere((c) => c.isoCode == 'US');

  group('supported countries', () {
    test('sign-up is open to exactly the five launch countries', () {
      expect(
        kSupportedCountries.map((c) => c.name),
        ['Nigeria', 'Austria', 'Ghana', 'Kenya', 'United States'],
      );
    });

    test('Nigeria is the default', () {
      expect(defaultCountry.name, 'Nigeria');
      expect(defaultCountry.dialCode, '+234');
    });
  });

  group('countryFromDialCode', () {
    test('recognises every supported dial code', () {
      expect(countryFromDialCode('+2348031234567')?.name, 'Nigeria');
      expect(countryFromDialCode('+436641234567')?.name, 'Austria');
      expect(countryFromDialCode('+233241234567')?.name, 'Ghana');
      expect(countryFromDialCode('+254712345678')?.name, 'Kenya');
      expect(countryFromDialCode('+12015551234')?.name, 'United States');
    });

    test('matches the longest code, so +234 never loses to a shorter prefix', () {
      expect(countryFromDialCode('+234')?.name, 'Nigeria');
      expect(countryFromDialCode('+233')?.name, 'Ghana');
      expect(countryFromDialCode('+254')?.name, 'Kenya');
    });

    test('accepts the 00 international prefix and spaced input', () {
      expect(countryFromDialCode('00234 803 123 4567')?.name, 'Nigeria');
      expect(countryFromDialCode('+233 24 123 4567')?.name, 'Ghana');
    });

    test('returns null for countries we have not launched in', () {
      expect(countryFromDialCode('+44 7700 900000'), isNull);
      expect(countryFromDialCode('+91 9812345678'), isNull);
    });

    test('returns null for a local number with no dial code', () {
      expect(countryFromDialCode('08031234567'), isNull);
    });
  });

  group('nationalDigits', () {
    test('drops the trunk zero people habitually type', () {
      expect(nationalDigits('08031234567'), '8031234567');
    });

    test('strips spaces, dashes and brackets', () {
      expect(nationalDigits('803 123 4567'), '8031234567');
      expect(nationalDigits('(201) 555-1234'), '2015551234');
    });
  });

  group('stripDialCode', () {
    test('removes a code the picker already shows', () {
      expect(stripDialCode('+2348031234567', ng), '8031234567');
      expect(stripDialCode('00233241234567', gh), '241234567');
    });

    test('leaves a plain local number alone', () {
      expect(stripDialCode('8031234567', ng), '8031234567');
    });
  });

  group('e164', () {
    test('builds the number the backend receives', () {
      expect(ng.e164('08031234567'), '+2348031234567');
      expect(us.e164('(201) 555-1234'), '+12015551234');
    });

    test('an empty field never becomes a bare dial code', () {
      expect(ng.e164(''), '');
      expect(ng.e164('   '), '');
    });
  });

  group('validatePhoneNumber', () {
    test('accepts well-formed numbers, with or without the trunk zero', () {
      expect(validatePhoneNumber('08031234567', ng), isNull);
      expect(validatePhoneNumber('8031234567', ng), isNull);
      expect(validatePhoneNumber('241234567', gh), isNull);
      expect(validatePhoneNumber('2015551234', us), isNull);
    });

    test('rejects an empty number', () {
      expect(validatePhoneNumber('', ng), 'Enter your phone number');
    });

    test('names the expected length for fixed-length countries', () {
      expect(validatePhoneNumber('803123456', ng), 'A Nigeria number has 10 digits');
      expect(validatePhoneNumber('80312345678', ng), 'A Nigeria number has 10 digits');
    });

    test('allows the range Austrian numbers actually span', () {
      final at = kSupportedCountries.firstWhere((c) => c.isoCode == 'AT');
      expect(validatePhoneNumber('1234', at), isNull);
      expect(validatePhoneNumber('6641234567890', at), isNull);
      expect(validatePhoneNumber('66412345678901', at), 'Enter a valid Austria number');
    });
  });
}
