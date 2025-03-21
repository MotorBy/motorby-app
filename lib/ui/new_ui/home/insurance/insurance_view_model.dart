import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class InsuranceViewModel extends BaseViewModel {

String selectedVehicle='';
String selectedModel='';
String selectedEngine='';
int selectedVehicleIndex =-1;
int selectedModelIndex =-1;
int selectedEngineIndex=-1;



void updateSelectedVehicle(String vehicle,int index){
  selectedVehicle =vehicle;
  selectedVehicleIndex=index;
  notifyListeners();
}
void updateSelectedModel(String model,int index){
  selectedModel =model;
  selectedModelIndex= index;
  notifyListeners();
}
void updateSelectedEngine(String engine,int index){
  selectedEngine =engine;
  selectedEngineIndex =index;
  notifyListeners();
}
final  manufacture =TextEditingController();
final vehicleType =TextEditingController();
final registrationNumber =TextEditingController();


  List<String> vehicle = [
    "BMW 3 series",
    "Toyota Corolla",
    "Honda Accord",
    "Toyota RAV4 ",
    "Tesla Model Y",
    "Ford F-150",
    "Chevrolet Silverado 1500",
    "Tesla Model 3",
    "Nissan Leaf",
    "Hyundai Loniq 5",
    "Chevrolet Corvette",
    "Porsche 911",
    "Ford Mustang",
    "Harley-Davidson Street Glide",
    "Kawasaki Ninja ZX-10R",
    "Audi e-Tron",
  ];
  List<String> model = [
    "330e (Plug-in-Hybrid)",
    "XLE",
    "EX-L",
    "Limited",
    "Touring",
    "ong Range",
    "Platinum",
    "High Country",
    "WT",
    "XLT",
    "Standard Range Plus",
    "Long Range",
    "Stingyray",
    "Turbo S",
    "EcoBoost",
    "Mach 1"
  ];
  List<String> engineType = [
"Gasoline - 2.0L Turbo 4-Cylinder",
"Gasoline - 1.8L 4-Cylinder",
"Hybride - 1.8L 4-Cylinder",
"Electric - Dual Motor All-Wheel Drive",
"Electric - RAV4 Prime (Plug-in-Hybrid)",
"Gasoline - 2.5L 4-Cylinder",
"Hybrid - 2.0L 4-Cylinder + Electric Motor",
"Electric - Rear-Wheel Drive",
"Electric - 40 kWh and 62 kWh Battery Options",
"Electric -  58 kWh and 72.6 kWh Battery Options",
"Gasoline - 6.2L V8",
"Gasoline - 3.0L Twin-Turbo Flat-6",
"Gasoline - 2.3L Turbo 4-Cylinder, 5.0L V8",
"Harley-Davidson Street Glide",
"Hybrid - 3.5L PowerBoost V6 + Electric Motor",
"Gasoline - 1.5L Turbo 4-Cylinder",

  ];
  final List<String> viewDetails=[
    'Provider Name:',
"Policy Number:",
"Coverage Period:",
"Renewal Date:",
"Coverage Type:"
  ];
    final List<String> viewDetailsValue=[
    'Comprehensive Party Insurance',
"123456789",
"Valid from Dec 1-31, 2024",
"Renew by Dec 29, 2024",
"Comprehensive /Third party"
  ];
}
