import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_auto_drive/services/payment_gateway.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/utils/currency.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';

void main() {
  SupportedCountry byCode(String code) =>
      kSupportedCountries.firstWhere((c) => c.isoCode == code);

  group('currency per market', () {
    test('each country bills in its own currency', () {
      expect(byCode('NG').currencyCode, 'NGN');
      expect(byCode('AT').currencyCode, 'EUR');
      expect(byCode('GH').currencyCode, 'GHS');
      expect(byCode('KE').currencyCode, 'KES');
      expect(byCode('US').currencyCode, 'USD');
    });

    test('every supported country has a symbol to print', () {
      for (final country in kSupportedCountries) {
        expect(country.currencySymbol, isNotEmpty, reason: country.name);
        expect(country.currencyCode.length, 3, reason: country.name);
      }
    });
  });

  group('countryByName', () {
    test('resolves the name stored on a profile', () {
      expect(countryByName('Ghana').isoCode, 'GH');
      expect(countryByName('ghana').isoCode, 'GH');
      expect(countryByName('  Kenya  ').isoCode, 'KE');
    });

    test('resolves an ISO code', () {
      expect(countryByName('AT').isoCode, 'AT');
    });

    test('handles the ways the United States gets written', () {
      expect(countryByName('United States').isoCode, 'US');
      expect(countryByName('USA').isoCode, 'US');
      expect(countryByName('United States of America').isoCode, 'US');
    });

    test('falls back to the default rather than returning null', () {
      // Accounts predate the country field, and markets can be dropped.
      expect(countryByName(null).isoCode, 'NG');
      expect(countryByName('').isoCode, 'NG');
      expect(countryByName('Atlantis').isoCode, 'NG');
    });
  });

  group('market features', () {
    test('insurance is Nigeria only', () {
      expect(byCode('NG').offers(MarketFeature.insurance), isTrue);
      for (final country in kSupportedCountries.where((c) => c.isoCode != 'NG')) {
        expect(country.offers(MarketFeature.insurance), isFalse,
            reason: country.name);
      }
    });

    test('fuel prices cover the African markets', () {
      expect(byCode('NG').offers(MarketFeature.fuelPrices), isTrue);
      expect(byCode('GH').offers(MarketFeature.fuelPrices), isTrue);
      expect(byCode('KE').offers(MarketFeature.fuelPrices), isTrue);
      expect(byCode('AT').offers(MarketFeature.fuelPrices), isFalse);
      expect(byCode('US').offers(MarketFeature.fuelPrices), isFalse);
    });
  });

  group('payment routing', () {
    test('the African markets and USD go to Paystack', () {
      expect(gatewayForCountry(byCode('NG')), PaymentGateway.paystack);
      expect(gatewayForCountry(byCode('GH')), PaymentGateway.paystack);
      expect(gatewayForCountry(byCode('KE')), PaymentGateway.paystack);
      expect(gatewayForCountry(byCode('US')), PaymentGateway.paystack);
    });

    test('euro goes to Stripe, because Paystack has no EUR', () {
      expect(kPaystackCurrencies.contains('EUR'), isFalse);
      expect(gatewayForCountry(byCode('AT')), PaymentGateway.stripe);
    });

    test('an unroutable currency returns null rather than a wrong gateway', () {
      expect(gatewayForCurrency('JPY'), isNull);
      expect(gatewayForCurrency(''), isNull);
      expect(gatewayForCurrency(null), isNull);
    });

    test('currency codes are matched case-insensitively', () {
      expect(gatewayForCurrency('ngn'), PaymentGateway.paystack);
      expect(gatewayForCurrency('eur'), PaymentGateway.stripe);
    });

    test('every supported market has a gateway', () {
      for (final country in kSupportedCountries) {
        expect(canTakePaymentIn(country), isTrue, reason: country.name);
      }
    });

    test('no currency is claimed by both processors', () {
      expect(kPaystackCurrencies.intersection(kStripeCurrencies), isEmpty);
    });
  });

  group('formatMoney', () {
    test('prints the symbol for that market', () {
      expect(formatMoney(1500, byCode('NG')), '\u20a61,500');
      expect(formatMoney(1500, byCode('AT')), '\u20ac1,500');
      expect(formatMoney(1500, byCode('GH')), 'GH\u20b51,500');
      expect(formatMoney(1500, byCode('KE')), 'KSh1,500');
      expect(formatMoney(1500, byCode('US')), '\$1,500');
    });

    test('handles zero and null without printing a bare symbol', () {
      expect(formatMoney(0, byCode('NG')), '\u20a60');
      expect(formatMoney(null, byCode('NG')), '\u20a60');
    });

    test('groups thousands', () {
      expect(formatMoney(1234567, byCode('NG')), '\u20a61,234,567');
    });

    test('formatMoneyFor resolves the country by name', () {
      expect(formatMoneyFor(100, 'Kenya'), 'KSh100');
      expect(formatMoneyFor(100, 'Atlantis'), '\u20a6100');
    });
  });

  group('paystackCurrencyFor', () {
    test('maps each Paystack-capable market onto the right enum', () {
      expect(paystackCurrencyFor('NGN'), PaystackCurrency.ngn);
      expect(paystackCurrencyFor('GHS'), PaystackCurrency.ghs);
      expect(paystackCurrencyFor('KES'), PaystackCurrency.kes);
      expect(paystackCurrencyFor('USD'), PaystackCurrency.usd);
      expect(paystackCurrencyFor('ZAR'), PaystackCurrency.zar);
    });

    test('every Paystack market resolves to its matching enum value', () {
      for (final country in kSupportedCountries
          .where((c) => gatewayForCountry(c) == PaymentGateway.paystack)) {
        expect(paystackCurrencyFor(country.currencyCode).value,
            country.currencyCode,
            reason: country.name);
      }
    });
  });
}
