import 'dart:math';

import 'package:flutter/material.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/helpers/snibbl_hints.dart';
import 'package:storygram/helpers/text_editing_helpers.dart';
import 'package:storygram/themes/app_theme.dart';

class AddSnibblScreen extends StatefulWidget {
  const AddSnibblScreen({super.key});

  @override
  State<AddSnibblScreen> createState() => _AddSnibblScreenState();
}

class _AddSnibblScreenState extends State<AddSnibblScreen> {
  @override
  Widget build(BuildContext context) {
    double fontSize = 18;

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
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Post',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w500,
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
                                    currentSize: fontSize,
                                  );

                                  if (newSize != null && mounted) {
                                    setState(() {
                                      fontSize = newSize;
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
                                onPressed: () {},
                              ),

                              // Alignment
                              IconButton(
                                icon: Icon(
                                  Icons.format_align_center,
                                  color: AppTheme.onPrimaryColor,
                                  size: 30,
                                ),
                                onPressed: () {},
                              ),

                              // Font Weight
                              IconButton(
                                icon: Icon(
                                  Icons.format_bold,
                                  color: AppTheme.onPrimaryColor,
                                  size: 35,
                                ),
                                onPressed: () {},
                              ),

                              //Italic
                              IconButton(
                                icon: Icon(
                                  Icons.format_italic,
                                  color: AppTheme.onPrimaryColor,
                                  size: 35,
                                ),
                                onPressed: () {},
                              ),
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
