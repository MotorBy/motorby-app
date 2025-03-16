import 'dart:collection';

import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {
      int currentindex = 0;
  ListQueue<int> navigationQueue = ListQueue();


  void changeTabIndex(int index) {
  if (currentindex != index) { // Update only if index changes
    currentindex = index;
    notifyListeners();

    navigationQueue.clear();
    navigationQueue.addLast(index);
    notifyListeners();

    print('the index: $index');
  }
      checkdata();
}


  void checkdata() {
    // ignore: avoid_function_literals_in_foreach_calls
    navigationQueue.forEach((element) {});
  }
}