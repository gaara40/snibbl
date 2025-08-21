import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/helpers/alignment_picker.dart';
import 'package:storygram/helpers/font_style_picker.dart';
import 'package:storygram/helpers/snibbl_hints.dart';
import 'package:storygram/helpers/font_size_picker.dart';
import 'package:storygram/themes/app_theme.dart';

class AddSnibblScreen extends StatefulWidget {
  const AddSnibblScreen({super.key});

  @override
  State<AddSnibblScreen> createState() => _AddSnibblScreenState();
}

class _AddSnibblScreenState extends State<AddSnibblScreen> {
  double currentFontSize = 18;
  String currentFontStyle = 'Poppins';
  TextAlign currentTextAlignment = TextAlign.left;
  bool isBold = false;

  @override
  Widget build(BuildContext context) {
    final Color boxColor = const Color.fromARGB(255, 247, 225, 192);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //logo
              SizedBox(height: 50, child: Image.asset(AppAssets.appNameLogo)),

              SizedBox(height: 40),

              //headlines
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Add a Snibbl',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                    title: Text('Hang on...'),
                                    content: const Text(
                                      'Post will be available in the next update.\n'
                                      'Just giving it a little polish ✨',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Okay'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Post',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  //textfield
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 500,

                          decoration: BoxDecoration(
                            color: boxColor,
                            border: Border(),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                              autocorrect: true,
                              maxLines: null,
                              textAlign: currentTextAlignment,
                              keyboardType: TextInputType.multiline,
                              expands: true, // fills up the height of parent

                              decoration: InputDecoration(
                                border:
                                    InputBorder
                                        .none, // removes default underline
                                hintText:
                                    snibblHints[Random().nextInt(
                                      snibblHints.length,
                                    )],
                                hintStyle: TextStyle(
                                  color: AppTheme.onSecondaryColor.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(12),
                              ),
                              style: GoogleFonts.getFont(
                                currentFontStyle,
                                fontSize: currentFontSize,
                                fontWeight:
                                    isBold ? FontWeight.bold : FontWeight.w100,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        //text-editing bar
                        Container(
                          decoration: BoxDecoration(
                            color: boxColor,
                            border: Border(),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              // Font Size
                              IconButton(
                                icon: const Icon(Icons.format_size, size: 28),
                                onPressed: () async {
                                  final newSize = await showFontSizePicker(
                                    context,
                                    currentFontSize: currentFontSize,
                                    currentFontStyle: currentFontStyle,
                                  );

                                  if (newSize != null && mounted) {
                                    setState(() {
                                      currentFontSize = newSize;
                                    });
                                  }
                                },
                              ),

                              // Font Style
                              IconButton(
                                icon: Icon(
                                  Icons.font_download,
                                  color: AppTheme.onPrimaryColor,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  final selectedFontStyle =
                                      await showFontStylePicker(
                                        context,
                                        currentFontStyle: currentFontStyle,
                                      );

                                  if (selectedFontStyle != null) {
                                    setState(() {
                                      currentFontStyle = selectedFontStyle;
                                    });
                                  }
                                },
                              ),

                              // Alignment
                              IconButton(
                                icon: Icon(
                                  Icons.format_align_center,
                                  color: AppTheme.onPrimaryColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  showAlignmentPicker(
                                    context,
                                    currentTextAlignment: currentTextAlignment,
                                    onSelected: (value) {
                                      setState(() {
                                        currentTextAlignment = value;
                                      });
                                    },
                                  );
                                },
                              ),

                              // Font Weight
                              IconButton(
                                icon: Icon(
                                  Icons.format_bold,
                                  color:
                                      isBold
                                          ? const Color.fromARGB(
                                            255,
                                            203,
                                            105,
                                            1,
                                          )
                                          : AppTheme.onPrimaryColor,
                                  size: 35,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isBold = !isBold;
                                  });
                                },
                              ),

                              // //Italic
                              // IconButton(
                              //   icon: Icon(
                              //     Icons.format_italic,
                              //     color: AppTheme.onPrimaryColor,
                              //     size: 35,
                              //   ),
                              //   onPressed: () {},
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
