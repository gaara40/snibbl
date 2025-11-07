import 'package:fluttertoast/fluttertoast.dart';
import 'package:storygram/core/themes/app_theme.dart';

void showToast(String content) {
  Fluttertoast.showToast(
    msg: content,
    backgroundColor: AppTheme.primaryColor,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_SHORT,
  );
}
