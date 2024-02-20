import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadFileToStorage({String? filePath, String? storagePath, Function(String url)? onCallBack}) async {
    final Reference ref = storage.ref(storagePath);

    final File imageFile = File(filePath!);
    final UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.then((TaskSnapshot snapshot) {
      snapshot.ref.getDownloadURL().then((url) {
        print('Image uploaded: $url');
        onCallBack!(url);
      });
    }, onError: (e) {

    });

  }


}