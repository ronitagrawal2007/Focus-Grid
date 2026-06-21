import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_helper_app/Provider/darkModeProvider.dart'; // Adjust path to your provider

class FocusBGImage extends StatelessWidget {
  final String selectedType;

  const FocusBGImage({super.key, required this.selectedType});

  @override
  Widget build(BuildContext context) {
    // Listen to the theme state to determine which assets to point to
    final isDarkMode = Provider.of<DarkModeProvider>(context).isDarkMode;

    String assetPath;

    if (isDarkMode) {
      // Dark Theme Asset Mapping
      switch (selectedType) {
        case 'Image 2':
          assetPath = 'assets/Image/4.jpeg'; // Old Image 4
          break;
        case 'Image 1':
        default:
          assetPath = 'assets/Image/1.jpeg'; // Old Image 2
          break;
      }
    } else {
      // Light Theme Asset Mapping
      switch (selectedType) {
        case 'Image 2':
          assetPath = 'assets/Image/2.jpeg'; // Old Image 3
          break;
        case 'Image 1':
        default:
          assetPath = 'assets/Image/3.jpeg'; // Old Image 1
          break;
      }
    }

    return SizedBox.expand(
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        key: ValueKey(
          assetPath,
        ), // Forces a clean redraw when the path changes dynamically
      ),
    );
  }
}
