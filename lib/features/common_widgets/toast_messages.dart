import 'package:fedha/theme/theme_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

showMessage({required String message, bgColor}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor ?? AppColors.whiteColor);
}
