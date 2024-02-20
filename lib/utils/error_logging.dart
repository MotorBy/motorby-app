import 'package:flutter/foundation.dart';

class ErrorLogging {

  Future<StackTrace> showError<T>(Future<T> f) async {
    StackTrace? stackT;

    await f.then((value) {}).onError((error, stackTrace) {
      stackT = stackTrace;
      print(stackTrace.toString());
    });

    return stackT!;
  }

}