import 'package:flutter/material.dart';

class FocusBG extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String?> onChanged;

  const FocusBG({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // The items always stay "Image 1" and "Image 2" now
    final List<String> dropdownItems = ['Image 1', 'Image 2'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        height: 60,
        child: Center(
          child: DropdownButtonFormField<String>(
            value: selectedType,
            hint: const Text("Image"),
            items: dropdownItems.map((String type) {
              return DropdownMenuItem<String>(value: type, child: Text(type));
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
