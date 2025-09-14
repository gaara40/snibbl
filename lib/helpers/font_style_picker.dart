import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storygram/widgets/text_editing_helper_divider.dart';

Future<String?> showFontStylePicker(
  BuildContext context, {
  required String currentFontStyle,
}) async {
  final fontsList = [
    "Nunito",
    "Pacifico",
    "Domine",
    "Allura",
    "Raleway",
    "Tangerine",
    "Spectral",
    "Cookie",
    "Montserrat",
    "Parisienne",
    "Roboto",
    "Quicksand",
    "Overpass",
    "Satisfy",
    "Karla",
    "Sacramento",
    "Yellowtail",
    "Lato",
  ];

  String temp = currentFontStyle;

  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setSheet) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              15,
              30,
              15,
              kBottomNavigationBarHeight + 5,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Header
                  Row(
                    children: [
                      const Icon(Icons.font_download),
                      const SizedBox(width: 8),
                      const Text(
                        'Font Style',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  //Divider
                  TextEditingHelperDivider(),

                  // Live preview
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Preview Aa',
                      style: GoogleFonts.getFont(temp, fontSize: 20),
                    ),
                  ),

                  SizedBox(height: 12),

                  //Quick presets
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var font in fontsList)
                        ChoiceChip(
                          label: Text(font),
                          selected: temp == font,
                          onSelected: (value) => setSheet(() => temp = font),
                        ),
                    ],
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
            ),
          );
        },
      );
    },
  );
}
