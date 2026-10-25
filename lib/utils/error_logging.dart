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

/// Services throw Exception(json['message']), so the part worth showing a user
/// sits behind a prefix they should never see.
String readableError(Object? error) {
  final text = (error ?? '').toString();
  return text.startsWith('Exception: ')
      ? text.substring('Exception: '.length)
      : text;
}
