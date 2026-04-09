import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageScreen extends StatelessWidget {
  final String imagePath;

  const FullScreenImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Tap to close
        },
        child: InteractiveViewer(
          panEnabled: true, // Allow panning
          minScale: 1.0,
          maxScale: 4.0, // Set a max zoom level
          child: Center(
            child: Hero(
              tag: imagePath, // Use the image path as a unique tag for the animation
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain, // Ensure the whole image is visible
              ),
            ),
          ),
        ),
      ),
    );
  }
}
