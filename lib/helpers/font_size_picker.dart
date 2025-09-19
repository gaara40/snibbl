import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storygram/widgets/text_editing_helper_divider.dart';

Future<double?> showFontSizePicker(
  BuildContext context, {
  required double currentFontSize,
  required String currentFontStyle,
  double min = 12,
  double max = 30,
}) {
  return showModalBottomSheet<double>(
    context: context,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      // local temp state that only lives inside the sheet
      double temp = currentFontSize.clamp(min, max);
      final presets = <double>[12, 14, 16, 18, 20, 24, 28, 30];

      return StatefulBuilder(
        builder: (ctx, setSheet) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              15,
              30,
              15,
              kBottomNavigationBarHeight + 5,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(Icons.format_size),
                    const SizedBox(width: 8),
                    const Text(
                      'Font Size',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      temp.toStringAsFixed(0),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                // Divider
                TextEditingHelperDivider(),

                // Live preview
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Preview Aa',
                    style: GoogleFonts.getFont(
                      currentFontStyle,
                      fontSize: temp,
                    ),
                  ),
                ),

                // Slider
                Slider(
                  value: temp,
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  onChanged: (v) => setSheet(() => temp = v),
                ),

                // Quick presets
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      presets
                          .map(
                            (p) => ChoiceChip(
                              label: Text(p.toStringAsFixed(0)),
                              selected: temp.round() == p.round(),
                              onSelected: (_) => setSheet(() => temp = p),
                            ),
                          )
                          .toList(),
                ),

                const SizedBox(height: 12),

                // Actions
                Row(
                  children: [
                    TextButton(
                      onPressed:
                          () => Navigator.pop(ctx, null), // cancel -> null
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed:
                          () => Navigator.pop(ctx, temp), // return the size
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
