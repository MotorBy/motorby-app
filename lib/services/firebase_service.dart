import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseService {

  final FirebaseStorage storage = FirebaseStorage.instance;
  ValueNotifier<String> imageUrl = ValueNotifier('');

  Future<String> uploadFileToStorage({String? filePath, String? storagePath, Function(String url)? onCallBack}) async {
    final Reference ref = storage.ref(storagePath);

    final File imageFile = File(filePath!);
    final UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      await ref.getDownloadURL().then((url) {
        imageUrl.value = url;
        onCallBack?.call(imageUrl.value);
        return url;
      });
    });

    return imageUrl.value;

  }


}