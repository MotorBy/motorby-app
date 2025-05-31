import 'dart:collection';

import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {
  int currentIndex = 0;

  void changeTabIndex(int index, {bool isSwipe = false}) {
    if (currentIndex != index) {
      currentIndex = index;
      notifyListeners();
    }
  }

}
