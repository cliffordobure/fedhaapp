import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInWithGoogleButton extends StatelessWidget {
  final action;

  const SignInWithGoogleButton({Key? key, required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(color: Colors.grey, width: 0.7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 8.w,
            ),
            Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Image.asset(
                "assets/Images/google_g.png",
                height: 30,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                "Sign in with Google",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
