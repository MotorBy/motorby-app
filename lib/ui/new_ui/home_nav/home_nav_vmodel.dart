import 'dart:collection';

import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {
  int currentIndex = 0;
  ListQueue<int> navigationQueue = ListQueue();

  void changeTabIndex(int index) {
    if (currentIndex != index) {
      // Update only if index changes
      currentIndex = index;
      notifyListeners();

      navigationQueue.clear();
      navigationQueue.addLast(index);
      notifyListeners();

      print('the index: $index');
    }
    checkdata();
  }

  void checkdata() {
    for (var element in navigationQueue) {}
  }
}
