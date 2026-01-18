import 'package:flutter/material.dart';

class TextEditorWidget extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Function(String) onChanged;
  final int? maxLines;
  final bool isRequired;

  const TextEditorWidget({
    super.key,
    required this.label,
    this.initialValue,
    required this.onChanged,
    this.maxLines = 1,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: initialValue ?? '')
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: initialValue?.length ?? 0),
            ),
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      ],
    );
  }
}












