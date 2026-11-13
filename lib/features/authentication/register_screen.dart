import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/helpers/privacy_policy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:go_router/go_router.dart';

import 'package:fedha/data/models/auth/register/register_request.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/authentication/widgets/continue_otp_verification_link.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/features/common_widgets/sign_in_google_button.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool hidePassword = true;
  bool termsAndConditions = false;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? phoneNumber;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.verifyOtp) {
          context.goNamed(Routes.otpVerify);
        }
      },
      listenWhen: (previous, current) =>
          !previous.verifyOtp && current.verifyOtp,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.h,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: AppBar().preferredSize.height),
                    Image.asset(
                      "assets/Images/ic_launcher.png",
                      height: 100.h,
                      width: 100.w,
                    ),
                    Text(
                      "Welcome",
                      style: theme.titleLarge?.copyWith(
                        color: AppColors.darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Stay signed in with your account to make work easier",
                          style: theme.bodySmall?.copyWith(
                            color: AppColors.darkBlueColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextInputField(
                        controller: _nameController,
                        title: 'Name',
                        hintText: "John Doe",
                        prefixIcon: Icons.person,
                        inputType: TextInputType.name,
                        validator: (value) => value!.isEmpty
                            ? "Please fill in your full names"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text("Phone Number", style: theme.labelMedium),
                      const SizedBox(height: 10),
                      _buildPhoneInputField(),
                      const SizedBox(height: 16),
                      _buildTextInputField(
                        controller: _emailController,
                        title: 'Email Address',
                        hintText: "johndoe@gmail.com",
                        prefixIcon: Icons.email_sharp,
                        inputType: TextInputType.emailAddress,
                        validator: (value) => !RegExp(
                          r"^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$",
                        ).hasMatch(value ?? "")
                            ? "Invalid E-mail"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordInputField(),
                      const SizedBox(height: 10),
                      _buildTermsAndConditionsCheckbox(),
                      const SizedBox(height: 10),
                      _buildSignUpButton(),
                      const ContinueOtpVerificationLink(),
                      const SizedBox(height: 20),
                      _buildDivider(),
                      const SizedBox(height: 10),
                      SignInWithGoogleButton(
                        action: () {
                          context
                              .read<AccountBloc>()
                              .add(GoogleAuthentication());
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildLoginPrompt(theme),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputField({
    required TextEditingController controller,
    required String title,
    required String hintText,
    required IconData prefixIcon,
    required TextInputType inputType,
    required FormFieldValidator<String> validator,
  }) {
    return DefaultInputField(
      textEditingController: controller,
      inputtype: inputType,
      title: title,
      hide: false,
      validator: validator,
      borderRadius: BorderRadius.circular(20.r),
      hintText: hintText,
      prefix: _buildPrefixIcon(prefixIcon),
    );
  }

  Widget _buildPhoneInputField() {
    return IntlPhoneField(
      initialCountryCode: "KE",
      disableLengthCheck: true,
      showCountryFlag: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _phoneController,
      dropdownIconPosition: IconPosition.trailing,
      keyboardType: TextInputType.phone,
      dropdownDecoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      dropdownTextStyle: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 16.sp,
      ),
      flagsButtonPadding: const EdgeInsets.only(left: 16, right: 16),
      validator: (value) {
        if (value == null || value.number.isEmpty) {
          return "Phone number is required";
        }
        if (value.number.length < 9) {
          return "Phone number is too short";
        }
        return null;
      },
      dropdownIcon: Icon(
        CupertinoIcons.chevron_down,
        color: AppColors.primaryColor,
        size: 16.sp,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: AppColors.whiteColor,
        countryCodeStyle: TextStyle(color: AppColors.primaryColor),
      ),
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 6.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
        hintText: "799000000",
        hintStyle: Theme.of(context)
            .textTheme
            .displayMedium
            ?.copyWith(color: Colors.black26),
        fillColor: Colors.white,
        filled: false,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: AppColors.greyColor),
        ),
      ),
      onChanged: (newPhone) {
        setState(() {
          phoneNumber = newPhone.completeNumber;
        });
      },
      onCountryChanged: (country) {
        debugPrint('Country changed to: ${country.name}');
      },
    );
  }

  Widget _buildPasswordInputField() {
    return DefaultInputField(
      textEditingController: _passwordController,
      inputtype: TextInputType.visiblePassword,
      inputAction: TextInputAction.done,
      title: 'Password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password required";
        }
        if (value.length < 6) {
          return "Enter a strong password";
        }
        return null;
      },
      hintText: "************",
      password: true,
      hide: hidePassword,
      borderRadius: BorderRadius.circular(20.r),
      prefix: _buildPrefixIcon(Icons.lock),
      suffix: GestureDetector(
        onTap: () {
          setState(() {
            hidePassword = !hidePassword;
          });
        },
        child: Icon(
          hidePassword ? Icons.visibility_off : Icons.visibility,
          size: 25.h,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildPrefixIcon(IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Icon(
        icon,
        size: 16.h,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildTermsAndConditionsCheckbox() {
    return FormField(
      validator: (value) {
        if (value == false) {
          return "Please agree to the terms and conditions";
        }
        return null;
      },
      builder: (FormFieldState<bool> state) {
        return GestureDetector(
          onTap: () => setState(() => termsAndConditions = !termsAndConditions),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                value: termsAndConditions,
                onChanged: (val) {
                  setState(() {
                    termsAndConditions = val ?? false;
                  });
                },
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: "I agree to the ",
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      // Terms and Conditions link
                      TextSpan(
                        text: "Terms & Conditions",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Terms & Conditions page
                            // context.pushNamed(Routes.termsAndConditions);
                          },
                      ),
                      TextSpan(
                        text: " and ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      // Privacy Policy link
                      TextSpan(
                        text: "Privacy Policy",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Privacy Policy page
                            launchPrivacyAndPolicy();
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return FullWidthButton(
      color: AppColors.primaryColor,
      text: "Sign Up",
      action: _signUp,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            height: 1,
            color: AppColors.greyColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "OR",
            style: TextStyle(color: AppColors.greyColor),
          ),
        ),
        Expanded(
          child: Divider(
            height: 1,
            color: AppColors.greyColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt(TextTheme theme) {
    return GestureDetector(
      onTap: () => context.goNamed(Routes.login),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: "Already have an account?",
            style: theme.bodySmall,
            children: [
              TextSpan(
                text: " Log In",
                style: theme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (termsAndConditions) {
        context.read<AccountBloc>().add(
              RegisterEvent(
                data: RegisterRequest(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                  phoneNumber: phoneNumber ?? _phoneController.text.trim(),
                ),
              ),
            );
      } else {
        _showToastMessage("Please agree to the terms and conditions");
      }
    } else {
      _showToastMessage("Please fill in all required fields");
    }
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message); // Assuming you have Fluttertoast installed
  }
}
