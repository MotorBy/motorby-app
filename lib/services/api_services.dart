import '../utils/env_config.dart';

class APIService {
  static bool isDev = EvnConfig().envConfigType == 'Dev';

  static const String USER = "user";
  static const String BUSINESS = "business";
  static const String SALES = "sales";
  static const String BUDGET = "budget";
  static const String CAR = "car";
  static const String SHOP = "shop";
  static const String COMMUNITY = 'community';
  static const String PLANS = 'plans';
  static const String PAYMENT = 'payment';

  static const String dev = 'https://motorby-dev.onrender.com/api/v1/';
  static const String prod = 'https://api.motorby.co/api/v1/';

  static const String vinUrl = 'https://vin-decoder19.p.rapidapi.com';

  static String root = !isDev ? prod : dev;

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

  static String getCommunities = "$root$COMMUNITY/get-communities";
  static String getDiscussions = "$root$COMMUNITY/get-discussions";
  static String addDiscussions = "$root$COMMUNITY/discuss/";
  static String addComments = "$root$COMMUNITY/comment/";
  static String joinCommunity = "$root$COMMUNITY/join/";

  static String getSales = "$root$SALES/";
  static String makeSales = "$root$SALES/makesales";
  static String addCars = "$root$CAR/add";
  static String updateCars({String? carId}) => "$root$CAR/$carId";
  static String sales({String? saleId}) => "$root$SALES/$saleId";

  static String createShop = "$root$SHOP/createShop";
  static String getShops = "$root$SHOP/shops";
  static String getPlans = "$root$PLANS/";

  static String getBudget({String? userId}) => "$root$BUDGET/?user_id=$userId";
  static String updateBudget({String? budgetId}) => "$root$BUDGET/$budgetId";

  static String vinCheck({String? vinNumber, String? vinType}) => "$vinUrl/$vinType?vin=$vinNumber";


}
