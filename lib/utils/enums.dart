enum InfoType {
  fueling,
  servicing,
  repairing,
  mileage,
  breakdown,
  fuelUpdate,
  weatherView,
  locationSetup,
  budgeting,
  empty,
  reminder;

  static InfoType fromString(String value) {
    switch (value) {
      case 'fueling':
        return InfoType.fueling;
      case 'servicing':
        return InfoType.servicing;
      case 'repairing':
        return InfoType.repairing;
      case 'mileage':
        return InfoType.mileage;
      case 'breakdown':
        return InfoType.breakdown;
      case 'fuel_update':
        return InfoType.fuelUpdate;
      case 'weather_view':
        return InfoType.weatherView;
      case 'location_setup':
        return InfoType.locationSetup;
      case 'budgeting':
        return InfoType.budgeting;
      case 'reminder':
        return InfoType.reminder;
      default:
        return InfoType.empty;
    }
  }

  String toValue() {
    switch (this) {
      case InfoType.fueling:
        return 'fueling';
      case InfoType.servicing:
        return 'servicing';
      case InfoType.repairing:
        return 'repairing';
      case InfoType.mileage:
        return 'mileage';
      case InfoType.breakdown:
        return 'breakdown';
      case InfoType.fuelUpdate:
        return 'fuel_update';
      case InfoType.weatherView:
        return 'weather_view';
      case InfoType.locationSetup:
        return 'location_setup';
      case InfoType.budgeting:
        return 'budgeting';
      case InfoType.reminder:
        return 'reminder';
      case InfoType.empty:
        return '';
    }
  }
}