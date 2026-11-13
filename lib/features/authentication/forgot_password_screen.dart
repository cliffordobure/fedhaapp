import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = 'forgot_password';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.resetRequestSuccess) {
          context.goNamed(Routes.resetOtp, extra: _emailController.text);
        }
      },
      listenWhen: (previous, current) =>
          previous.resetRequestSuccess != current.resetRequestSuccess,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/Images/Background.png',
              ),
              fit: BoxFit.cover),
        ),
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
                Text("Forgot Password",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text(
                      "Select contact details to use for password resetting",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: theme.displayMedium!
                          .copyWith(color: AppColors.darkBlueColor),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DefaultInputField(
                        inputAction: TextInputAction.done,
                        textEditingController: _emailController,
                        title: 'Email',
                        hide: false,
                        validator: (onValidateVal) {
                          if (onValidateVal.isEmpty) {
                            return "Email Address required";
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(onValidateVal);
                          if (!emailValid) {
                            return "Invalid E-mail";
                          }
                          return null;
                        },
                        onSaved: (onSavedVal) {
                          // email = onSavedVal.toString().trim();
                        },
                        hintText: "******doe@gmail.com",
                        suffix: Padding(
                          padding: EdgeInsets.only(right: 5.h),
                          child: Icon(
                            Icons.check_circle,
                            size: 25.h,
                            color: Colors.green,
                          ),
                        ),
                        prefix: Padding(
                          padding: EdgeInsets.only(left: 5.h),
                          child: Icon(
                            Icons.email_sharp,
                            size: 25.h,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                FullWidthButton(
                  action: () {
                    final form = _formKey.currentState;

                    if (form!.validate()) {
                      context.read<AccountBloc>().add(ForgotPasswordEvent(
                          email: _emailController.text.trim()));
                    } else {
                      showToast("Please enter a valid email address");
                    }
                  },
                  text: "Recover Password",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
