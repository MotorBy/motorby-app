import 'package:mobile_auto_drive/utils/api_keys.dart';

class APIService {

  static const String USER = "user";
  static const String BUSINESS = "business";
  static const String SALES = "sales";
  static const String BUDGET = "budget";
  static const String CAR = "car";
  static const String SHOP = "shop";
  static const String COMMUNITY = 'community';
  static const String PLANS = 'plans';
  static const String PAYMENT = 'payment';
  static const String FUEL = 'fuel';
  static const String CHECKLIST = 'car/checklist';

  static const String dev = 'https://motorby-dev.onrender.com/api/v1/';
  static const String prod = 'https://motorbyweb.exceptos.com/api/v1/';

  static const String vinUrl = 'https://vin-decoder19.p.rapidapi.com';

  static String root = !APIKey.isDev! ? prod : dev;

  static const String paystackAPI = "https://api.paystack.co/transaction";
  static const String paystackRefund = "https://api.paystack.co/refund";

  static const String googleLatLngAddress = "https://maps.googleapis.com/maps/api/geocode/json?";
  static const String googleDirections = "https://maps.googleapis.com/maps/api/directions/json?";
  static const String googleDirectionsMatrix = "https://maps.googleapis.com/maps/api/distancematrix/json?";
  static const String googlePlacesNearBy = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

  static const String payVerify = "$paystackAPI/verify";
  static const String payAuthCharge = "$paystackAPI/charge_authorization";
  static const String payInit = "$paystackAPI/initialize";

  static String authUser = "$root$USER/create";
  static String loginUser = "$root$USER/login";
  static String getUser({String? id}) => "$root$USER/$id";
  static String makePayment = "$root$PAYMENT/create-payment";
  /// Backend-created Stripe PaymentIntent. Must exist before euro payments
  /// can work; the secret key stays server-side.
  static String createStripeIntent = "$root$PAYMENT/stripe/create-intent";

  static String getWeather({String? lng, String? lat, String? country}) => "$root$USER/weather/?lng=$lng&lat=$lat&country=$country";

  static String getCommunities = "$root$COMMUNITY/get-communities";
  static String getDiscussions = "$root$COMMUNITY/get-discussions";
  static String addDiscussions = "$root$COMMUNITY/discuss/";
  static String addComments = "$root$COMMUNITY/comment/";
  static String joinCommunity = "$root$COMMUNITY/join/";

  static String getSales = "$root$SALES/";
  static String makeSales = "$root$SALES/makesales";
  static String addCars = "$root$CAR/add";
  static String updateCars({String? carId}) => "$root$CAR/$carId";
  static String deleteCar({String? carId}) => "$root$CAR/$carId";
  static String sales({String? saleId}) => "$root$SALES/$saleId";
  static String uploadDocuments({String? carId}) => "$root$CAR/documents/$carId";

  static String createShop = "$root$SHOP/createShop";
  static String getShops = "$root$SHOP/shops";
  static String getPlans = "$root$PLANS/";
  static String getCurrentPlans = "$root$PLANS/current";

  static String getInsuranceProducts = '$root/car/insurance/products';
  static String getBoughtInsuranceProducts = '$root/car/insurance/purchased';
  static String getBuyInsuranceProducts = '$root/car/insurance/buy';
  static String getInsuranceProductsDetails ='$root$CAR/insurance/products-details?product_id=';
  static String getCarMakers = '$root/car/makers';

  static String addFuelUpdate = "$root/$FUEL/add-price";
  static String getFuelUpdate({String? state, String? country, String? city}) => "$root/$FUEL/location?state=$state&country=$country&city=$city";

  static String getBudget({String? userId}) => "$root$BUDGET/?user_id=$userId";
  static String updateBudget({String? budgetId}) => "$root$BUDGET/$budgetId";

  static String vinCheck({String? vinNumber, String? vinType}) => "$vinUrl/$vinType?vin=$vinNumber";

  static String getChecklist({String? carId}) => "$root$CHECKLIST/$carId";
  static String updateChecklist({String? id}) => "$root$CHECKLIST/$id";
  static String updateChecklistFrequency({String? carId}) => "$root$CHECKLIST/$carId/frequency";

}
