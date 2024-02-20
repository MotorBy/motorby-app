import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future pickImage({Function(String? pickedImage)? onCallBack, bool? allowCropping = false}) async {

  final _image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 780,
    maxHeight: 780,);

  if(allowCropping!) {

    ImageCropper().cropImage(
        sourcePath: _image!.path,
        maxWidth: 780,
        maxHeight: 780,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
    ).then((value) {
      if(value != null) {
        onCallBack!(value.path);
      }
    });

  } else {
    onCallBack!(_image!.path);
  }

}