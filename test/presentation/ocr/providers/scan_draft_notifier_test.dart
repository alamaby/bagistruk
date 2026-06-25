import 'package:bagistruk/data/providers.dart';
import 'package:bagistruk/data/services/image_picker_wrapper.dart';
import 'package:bagistruk/presentation/ocr/providers/scan_draft_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  group('ScanDraftNotifier', () {
    test('initial state has empty images', () {
      final container = _createContainer([]);
      final state = container.read(scanDraftProvider);
      expect(state.images, isEmpty);
    });

    group('pickFromGallery', () {
      test('empty result does not change state', () async {
        final container = _createContainer([]);
        final notifier = container.read(scanDraftProvider.notifier);
        await notifier.pickFromGallery();
        expect(container.read(scanDraftProvider).images, isEmpty);
      });

      test('appends images on non-empty result', () async {
        final container = _createContainer([
          XFile('/tmp/a.jpg'),
          XFile('/tmp/b.jpg'),
        ]);
        final notifier = container.read(scanDraftProvider.notifier);
        await notifier.pickFromGallery();
        final images = container.read(scanDraftProvider).images;
        expect(images.length, 2);
        expect(images[0].path, '/tmp/a.jpg');
        expect(images[1].path, '/tmp/b.jpg');
      });

      test('multiple picks accumulate images', () async {
        final fake = FakeImagePicker(multiImageResult: [XFile('/tmp/a.jpg')]);
        final container = ProviderContainer(
          overrides: [imagePickerProvider.overrideWithValue(fake)],
        );
        final notifier = container.read(scanDraftProvider.notifier);

        await notifier.pickFromGallery();
        await notifier.pickFromGallery();

        expect(container.read(scanDraftProvider).images.length, 2);
      });
    });

    group('pickFromCamera', () {
      test('null result does not change state', () async {
        final fake = FakeImagePicker(singleImageResult: null);
        final container = _createContainerWithFake(fake);
        final notifier = container.read(scanDraftProvider.notifier);
        final result = await notifier.pickFromCamera();
        expect(result, isNull);
        expect(container.read(scanDraftProvider).images, isEmpty);
      });

      test('appends shot and returns it', () async {
        final shot = XFile('/tmp/shot.jpg');
        final fake = FakeImagePicker(singleImageResult: shot);
        final container = _createContainerWithFake(fake);
        final notifier = container.read(scanDraftProvider.notifier);
        final result = await notifier.pickFromCamera();
        expect(result?.path, '/tmp/shot.jpg');
        expect(
          container.read(scanDraftProvider).images.single.path,
          '/tmp/shot.jpg',
        );
      });
    });

    group('removeAt', () {
      test('invalid negative index no-op', () async {
        final container = _createContainer([XFile('/tmp/a.jpg')]);
        final notifier = container.read(scanDraftProvider.notifier);
        notifier.removeAt(-1);
        expect(container.read(scanDraftProvider).images.length, 1);
      });

      test('out-of-range index no-op', () async {
        final container = _createContainer([XFile('/tmp/a.jpg')]);
        final notifier = container.read(scanDraftProvider.notifier);
        notifier.removeAt(10);
        expect(container.read(scanDraftProvider).images.length, 1);
      });

      test('removes correct item at index', () async {
        final container = _createContainer([
          XFile('/tmp/a.jpg'),
          XFile('/tmp/b.jpg'),
          XFile('/tmp/c.jpg'),
        ]);
        final notifier = container.read(scanDraftProvider.notifier);
        notifier.removeAt(1);
        final images = container.read(scanDraftProvider).images;
        expect(images.length, 2);
        expect(images[0].path, '/tmp/a.jpg');
        expect(images[1].path, '/tmp/c.jpg');
      });
    });

    group('clear', () {
      test('empty state no-op', () async {
        final container = _createContainer([]);
        final notifier = container.read(scanDraftProvider.notifier);
        notifier.clear();
        expect(container.read(scanDraftProvider).images, isEmpty);
      });

      test('clears all images', () async {
        final container = _createContainer([XFile('/tmp/a.jpg')]);
        final notifier = container.read(scanDraftProvider.notifier);
        notifier.clear();
        expect(container.read(scanDraftProvider).images, isEmpty);
      });
    });

    group('image quality forwarding', () {
      test('pickFromGallery uses quality 90', () async {
        final fake = FakeImagePicker(multiImageResult: []);
        final container = _createContainerWithFake(fake);
        final notifier = container.read(scanDraftProvider.notifier);
        await notifier.pickFromGallery();
        expect(fake.lastQuality, 90);
      });

      test('pickFromCamera uses quality 90 and source camera', () async {
        final fake = FakeImagePicker(singleImageResult: null);
        final container = _createContainerWithFake(fake);
        final notifier = container.read(scanDraftProvider.notifier);
        await notifier.pickFromCamera();
        expect(fake.lastQuality, 90);
        expect(fake.lastSource, ImageSource.camera);
      });
    });
  });
}

ProviderContainer _createContainer(List<XFile> galleryResult) {
  final fake = FakeImagePicker(multiImageResult: galleryResult);
  return ProviderContainer(
    overrides: [imagePickerProvider.overrideWithValue(fake)],
  );
}

ProviderContainer _createContainerWithFake(FakeImagePicker fake) =>
    ProviderContainer(overrides: [imagePickerProvider.overrideWithValue(fake)]);

class FakeImagePicker implements IImagePicker {
  FakeImagePicker({this.multiImageResult = const [], this.singleImageResult});

  final List<XFile> multiImageResult;
  final XFile? singleImageResult;
  int? lastQuality;
  ImageSource? lastSource;

  @override
  Future<List<XFile>> pickMultiImage({int? imageQuality}) async {
    lastQuality = imageQuality;
    return multiImageResult;
  }

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    int? imageQuality,
  }) async {
    lastQuality = imageQuality;
    lastSource = source;
    return singleImageResult;
  }
}
