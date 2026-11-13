import 'package:fedha/data/models/auth/otp/otp_verify_request.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetOTPScreen extends StatefulWidget {
  const ResetOTPScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<ResetOTPScreen> createState() => _ResetOTPScreenState();
}

class _ResetOTPScreenState extends State<ResetOTPScreen> {
  final TextEditingController _otpController = TextEditingController(text: "");

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    TextTheme theme = Theme.of(context).textTheme;

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.verificationSuccess) {
          // set new passwords
          context.goNamed(Routes.newPasswords, extra: widget.email);
        }
      },
      listenWhen: (previous, current) =>
          previous.verificationSuccess != current.verificationSuccess,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Image.asset(
                "assets/Images/ic_launcher.png",
                height: 100,
                width: 100,
              ),
              const SizedBox(
                height: 50,
              ),
              Text("Verify OTP",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style:
                      theme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Text(
                    "Verify your account by OTP sent to your email address",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.displayMedium!
                        .copyWith(color: AppColors.darkBlueColor),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: PinCodeTextField(
                        appContext: (context),
                        keyboardType: TextInputType.number,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        enablePinAutofill: true,
                        useHapticFeedback: true,
                        useExternalAutoFillGroup: true,
                        autoDisposeControllers: false,
                        pinTheme: PinTheme.defaults(
                          shape: PinCodeFieldShape.box,
                          borderWidth: 1,
                          borderRadius: BorderRadius.circular(6.r),
                          inactiveColor: Colors.black26,
                          activeColor: Colors.black26,
                          selectedFillColor: const Color(0XFFEEEEFA),
                          selectedColor: AppColors.greyColor,
                          activeFillColor: AppColors.greyColor,
                          inactiveFillColor: const Color(0XFFEEEEFA),
                        ),
                        length: 6,
                        animationDuration: const Duration(milliseconds: 200),
                        errorAnimationController: null,
                        controller: _otpController,
                        onCompleted: (v) {
                          setState(() {});
                          _otpController.text = v;
                        },
                        onChanged: (value) {
                          if (kDebugMode) {
                            print(value);
                          }
                        },
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  return FullWidthButton(
                    btnheight: 50.h,
                    action: () {
                      // Validate otp
                      if (kDebugMode) {
                        print("Verify Otp");
                      }
                      context.read<AccountBloc>().add(
                            ResetVerifyEmailOtp(
                              request: EmailOtpRequest(
                                  otp: _otpController.text.trim(),
                                  email: widget.email),
                            ),
                          );
                    },
                    text: "Verify",
                  );
                },
              ),
              SizedBox(height: 10.h),
              BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: () {
                      context
                          .read<AccountBloc>()
                          .add(ForgotPasswordEvent(email: widget.email));
                    },
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
