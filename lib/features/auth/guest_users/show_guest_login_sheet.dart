import 'package:flutter/material.dart';
import 'package:storygram/features/auth/presentation/widgets/guest_auth_sheet.dart';

Future<void> showGuestLoginSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isDismissible: false,
    enableDrag: false,
    builder: (context) => GuestAuthSheet(),
  );
}
