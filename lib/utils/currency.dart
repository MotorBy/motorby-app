import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';

/// Formats an amount in the user's own currency.
///
/// Prices used to be printed with a hardcoded naira sign, which was wrong
/// everywhere outside Nigeria. Pass the country the amount belongs to and the
/// symbol follows from it.
String formatMoney(num? amount, SupportedCountry country) {
  final value = (amount ?? 0).toDouble();
  return '${country.currencySymbol}${numberFormat(number: value)}';
}

/// The same, for a user whose country is stored as a plain name.
String formatMoneyFor(num? amount, String? countryName) =>
    formatMoney(amount, countryByName(countryName));

/// Formats an amount in the signed-in user's currency.
///
/// Most call sites are deep in widget trees that have no country to hand, and
/// prices were previously printed with a hardcoded naira sign. This reads the
/// market off the current user, the same way [isBusiness] does.
String money(num? amount) => formatMoneyFor(
    amount, serviceLocator<UserService>().userModel?.payload?.user?.country);
