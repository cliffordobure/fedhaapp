import 'package:fedha/data/models/auth/login/login_request.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/authentication/widgets/continue_otp_verification_link.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/features/common_widgets/sign_in_google_button.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  bool saveLogins = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isEmailValid = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 100) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    bool isAuthenticated = AuthenticationRepository.instance.status ==
        AuthenticationStatus.authenticated;
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (isAuthenticated) {
          // _handleSuccessfulLogin();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(context),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 30.h),
                          Text(
                            "Welcome Back",
                            style: theme.titleLarge?.copyWith(
                              color: AppColors.darkBlueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "Stay signed in with your account to make work easier",
                            style: theme.displayMedium
                                ?.copyWith(color: AppColors.darkBlueColor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50.h),
                          _buildEmailField(),
                          SizedBox(height: 8.h),
                          _buildPasswordField(),
                          SizedBox(height: 10.h),
                          _buildRememberMeAndForgotPassword(theme),
                          SizedBox(height: 20.h),
                          _buildLoginButton(),
                          SizedBox(height: 12.h),
                          const ContinueOtpVerificationLink(),
                          SizedBox(height: 20.h),
                          _buildOrDivider(),
                          SizedBox(height: 20.h),
                          SignInWithGoogleButton(action: () {
                            context
                                .read<AccountBloc>()
                                .add(GoogleAuthentication());
                          }),
                          SizedBox(height: 20.h),
                          _buildRegisterPrompt(theme),
                          SizedBox(height: 20.h)
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/Images/ic_launcher.png",
        height: 100,
        width: 100,
      ),
    );
  }

  Widget _buildEmailField() {
    return DefaultInputField(
      textEditingController: _emailController,
      title: 'Email Address',
      inputtype: TextInputType.emailAddress,
      hide: false,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email Address required";
        }
        bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(value);
        if (!emailValid) {
          return "Invalid E-mail";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          isEmailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(value);
        });
      },
      borderRadius: BorderRadius.circular(20.r),
      hintText: "johndoe@gmail.com",
      suffix: Padding(
        padding: EdgeInsets.only(right: 5.h),
        child: Icon(
          Icons.check_circle,
          size: 25.h,
          color: isEmailValid ? Colors.green : Colors.transparent,
        ),
      ),
      prefix: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: Icon(
          Icons.email_sharp,
          size: 16.h,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return DefaultInputField(
      textEditingController: _passwordController,
      inputAction: TextInputAction.done,
      inputtype: TextInputType.visiblePassword,
      title: 'Password',
      onSaved: (onSavedVal) {},
      hintText: "************",
      password: true,
      hide: hidePassword,
      borderRadius: BorderRadius.circular(20.r),
      prefix: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: Icon(
          Icons.lock,
          size: 16.h,
          color: Colors.black54,
        ),
      ),
      suffix: GestureDetector(
        onTap: () {
          setState(() {
            hidePassword = !hidePassword;
          });
        },
        child: Container(
          margin: EdgeInsets.only(right: 5.h),
          child: Icon(
            hidePassword ? Icons.visibility_off : Icons.visibility,
            size: 25.h,
            color: Colors.black54,
          ),
        ),
      ),
      toggleHide: () {
        setState(() {
          hidePassword = !hidePassword;
        });
      },
    );
  }

  Widget _buildRememberMeAndForgotPassword(TextTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: AppColors.primaryColor,
                ),
                child: Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    activeColor: AppColors.primaryColor,
                    value: saveLogins,
                    onChanged: (value) {
                      setState(() {
                        saveLogins = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Keep me signed in",
              style: TextStyle(
                color: const Color(0xff646464),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
        GestureDetector(
          child: Text(
            "Forgot Password?",
            style: theme.displaySmall!.copyWith(color: const Color(0XFFFC6D5B)),
          ),
          onTap: () {
            context.goNamed(Routes.forgotPassword);
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return FullWidthButton(
      btnheight: 50,
      text: "Sign In",
      action: () {
        if (_formKey.currentState!.validate()) {
          context.read<AccountBloc>().add(
                LoginEvent(
                  data: LoginRequest(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                  ),
                ),
              );
        }
      },
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: AppColors.greyColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            "Or",
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: AppColors.greyColor)),
      ],
    );
  }

  Widget _buildRegisterPrompt(TextTheme theme) {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style: theme.displayMedium,
        children: [
          TextSpan(
            text: "Register",
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.goNamed(Routes.register),
            style: const TextStyle(color: Color(0XFFFC6D5B)),
          ),
        ],
      ),
    );
  }

  // void _handleSuccessfulLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLoggedIn', true);

  //   String? pendingNavigation = prefs.getString('pendingNavigation');
  //   String? pendingNavigationDataString =
  //       prefs.getString('pendingNavigationData');

  //   if (pendingNavigation != null) {
  //     await prefs.remove('pendingNavigation');
  //     await prefs.remove('pendingNavigationData');

  //     Map<String, dynamic>? pendingNavigationData;
  //     if (pendingNavigationDataString != null) {
  //       pendingNavigationData = jsonDecode(pendingNavigationDataString);
  //     }

  //     context.goNamed(pendingNavigation, extra: pendingNavigationData);
  //   } else {
  //     context.goNamed(Routes.home);
  //   }
  // }
}
