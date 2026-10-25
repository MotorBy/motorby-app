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

  /// Best-effort cleanup of the files behind a set of download URLs.
  ///
  /// Each file is deleted independently: a URL that is already gone, or that
  /// points somewhere other than our bucket, must not stop the rest. Returns
  /// the URLs that could not be removed so the caller can log them.
  Future<List<String>> deleteFilesFromStorage(Iterable<String> urls) async {
    final failed = <String>[];

    for (final url in urls) {
      if (!isFirebaseStorageUrl(url)) continue;

      try {
        await storage.refFromURL(url).delete();
      } on FirebaseException catch (e) {
        // The file is already gone, which is the state we wanted anyway.
        if (e.code == 'object-not-found') continue;
        failed.add(url);
      } catch (_) {
        failed.add(url);
      }
    }

    return failed;
  }

}

/// Whether [url] points at a file in Firebase Storage that we can delete.
///
/// Car photos are uploaded to our bucket and come back as download URLs, but a
/// car record can also carry a URL typed in by hand or served from elsewhere.
/// refFromURL throws on those, so they are filtered out rather than attempted.
bool isFirebaseStorageUrl(String? url) {
  if (url == null || url.isEmpty) return false;

  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return false;

  return uri.host == 'firebasestorage.googleapis.com' ||
      uri.host.endsWith('.firebasestorage.app') ||
      uri.host == 'storage.googleapis.com' ||
      uri.scheme == 'gs';
}