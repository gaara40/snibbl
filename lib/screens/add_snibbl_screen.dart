import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storygram/constants/assets.dart';
import 'package:storygram/helpers/alignment_picker.dart';
import 'package:storygram/helpers/font_style_picker.dart';
import 'package:storygram/helpers/snibbl_hints.dart';
import 'package:storygram/helpers/font_size_picker.dart';
import 'package:storygram/main.dart';
import 'package:storygram/services/upload_post_service.dart';
import 'package:storygram/themes/app_theme.dart';

class AddSnibblScreen extends ConsumerStatefulWidget {
  const AddSnibblScreen({super.key});

  @override
  ConsumerState<AddSnibblScreen> createState() => _AddSnibblScreenState();
}

class _AddSnibblScreenState extends ConsumerState<AddSnibblScreen> {
  double currentFontSize = 18;
  String currentFontStyle = 'Poppins';
  TextAlign currentTextAlignment = TextAlign.left;
  bool isBold = false;
  late String username;

  final _postTextontroller = TextEditingController();

  @override
  void dispose() {
    _postTextontroller.dispose();
    super.dispose();
  }

  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> onPost() async {
    final user = _firebaseAuth.currentUser;

    final postText = _postTextontroller.text.trim();

    //validate text
    if (postText.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter you snibbl',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else if (postText.length < 15) {
      Fluttertoast.showToast(
        msg: 'A Snibbl should contain atleast 15 characters',
      );
      return;
    } else if (postText.length > 1000) {
      Fluttertoast.showToast(msg: 'A Snibble shoul not exceed 1000 characters');
      return;
    }

    if (user == null) return;

    if (user.isAnonymous) {
      username = user.displayName.toString();
    } else {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userDoc.exists) {
        username = userDoc.data()?['username'] ?? 'undefined';
      } else {
        username = user.displayName ?? 'undefined_user';
      }
    }

    try {
      final postId = await UploadPostService().uploadPost(
        userId: user.uid,
        email: user.email ?? '',
        username: username,
        fontSize: currentFontSize,
        fontStyle: currentFontStyle,
        textAlignment: currentTextAlignment,
        isBold: isBold,
        text: postText,
        likes: [],
      );

      debugPrint('Posted successfully with postId: $postId');

      if (!mounted) return;

      Fluttertoast.showToast(msg: 'Post uploaded successfully');
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/mainScreen',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Error uploading post: $e');
    }
  }

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
                              onPost();
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

                            //TEXTFIELD
                            child: TextField(
                              controller: _postTextontroller,
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
                                hintStyle: GoogleFonts.getFont(
                                  currentFontStyle,
                                  color: AppTheme.onSecondaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  fontWeight:
                                      isBold
                                          ? FontWeight.w300
                                          : FontWeight.w300,
                                ),
                                contentPadding: EdgeInsets.all(12),
                              ),
                              style: GoogleFonts.getFont(
                                currentFontStyle,
                                fontSize: currentFontSize,
                                fontWeight:
                                    isBold ? FontWeight.bold : FontWeight.w300,
                                color: AppTheme.onSecondaryColor,
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
