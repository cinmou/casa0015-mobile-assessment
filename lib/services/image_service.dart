import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  /// Picks an image from the gallery or takes a new one with the camera.
  /// Returns the local path of the saved image, or null if no image was picked.
  Future<String?> pickAndSaveImage({required ImageSource source}) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile == null) {
      return null; // User cancelled picking
    }

    try {
      // Get the application's documents directory
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String imagesDirectoryPath = '${appDirectory.path}/decision_images';
      final Directory imagesDirectory = Directory(imagesDirectoryPath);

      // Ensure the directory exists
      if (!await imagesDirectory.exists()) {
        await imagesDirectory.create(recursive: true);
      }

      // Generate a unique file name
      final String fileName = '${_uuid.v4()}.jpg'; // Using UUID for unique names
      final String newPath = '${imagesDirectory.path}/$fileName';

      // Copy the picked image to the new local path
      final File newImage = await File(pickedFile.path).copy(newPath);

      return newImage.path;
    } catch (e) {
      print("Error saving image locally: $e");
      return null;
    }
  }

  /// Deletes a locally stored image given its path.
  Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return;
    }
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        print("Image deleted successfully: $imagePath");
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
  }
}
