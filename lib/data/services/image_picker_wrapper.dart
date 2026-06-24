import 'package:image_picker/image_picker.dart';

abstract interface class IImagePicker {
  Future<List<XFile>> pickMultiImage({int? imageQuality});
  Future<XFile?> pickImage({required ImageSource source, int? imageQuality});
}

class ImagePickerAdapter implements IImagePicker {
  const ImagePickerAdapter(this._inner);

  final ImagePicker _inner;

  @override
  Future<List<XFile>> pickMultiImage({int? imageQuality}) =>
      _inner.pickMultiImage(imageQuality: imageQuality);

  @override
  Future<XFile?> pickImage({required ImageSource source, int? imageQuality}) =>
      _inner.pickImage(source: source, imageQuality: imageQuality);
}
