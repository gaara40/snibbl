import 'package:flutter/material.dart';
import 'package:storygram/widgets/text_editing_helper_divider.dart';

Future<TextAlign?> showAlignmentPicker(
  BuildContext context, {
  required TextAlign currentTextAlignment,
  required Function(TextAlign) onSelected,
}) async {
  final alignments = <Map<String, dynamic>>[
    {'icon': Icons.format_align_left, 'value': TextAlign.left},
    {'icon': Icons.format_align_center, 'value': TextAlign.center},
    {'icon': Icons.format_align_right, 'value': TextAlign.right},
    {'icon': Icons.format_align_justify, 'value': TextAlign.justify},
  ];

  return showModalBottomSheet<TextAlign>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (ctx, setSheet) {
          return Padding(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Header
                Row(
                  children: [
                    const Icon(Icons.format_align_center),
                    const SizedBox(width: 8),
                    const Text(
                      'Align Text',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // Divider
                TextEditingHelperDivider(),

                // Alignment Options
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 5,
                  children: [
                    for (var item in alignments)
                      ChoiceChip(
                        avatar: Icon(item['icon']),
                        label: Text(
                          item['value'].toString().replaceAll('TextAlign.', ''),
                        ),
                        selected: currentTextAlignment == item['value'],
                        onSelected: (_) {
                          onSelected(item['value']);
                          Navigator.pop(context, item['value']);
                        },
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
