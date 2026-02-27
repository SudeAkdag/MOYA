import 'package:flutter/material.dart';

class FocusAreaSelector extends StatelessWidget {
  final List<String> allAreas;
  final List<String> selectedAreas;
  final Function(String, bool) onSelected;

  const FocusAreaSelector({
    super.key,
    required this.allAreas,
    required this.selectedAreas,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allAreas.map((area) {
        final isSelected = selectedAreas.contains(area);
        return FilterChip(
          label: Text(area),
          selected: isSelected,
          onSelected: (val) => onSelected(area, val),
          selectedColor: theme.primaryColor.withOpacity(0.2),
          checkmarkColor: theme.primaryColor,
          backgroundColor: Colors.white.withOpacity(0.5),
          labelStyle: TextStyle(
            color: isSelected ? theme.primaryColor : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? theme.primaryColor : Colors.black12,
            ),
          ),
        );
      }).toList(),
    );
  }
}