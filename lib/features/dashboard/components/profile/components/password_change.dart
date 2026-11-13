import 'package:fedha/data/models/profile/changepassword.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PasswordChangeBottomSheet extends StatefulWidget {
  const PasswordChangeBottomSheet({super.key});

  @override
  State<PasswordChangeBottomSheet> createState() =>
      _PasswordChangeBottomSheetState();
}

class _PasswordChangeBottomSheetState extends State<PasswordChangeBottomSheet> {
  bool hidePassword = true;

  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String title,
    required String hintText,
    required TextInputAction inputAction,
    required FormFieldValidator<String> validator,
  }) {
    return DefaultInputField(
      textEditingController: controller,
      inputAction: inputAction,
      inputtype: TextInputType.visiblePassword,
      title: title,
      validator: validator,
      hintText: hintText,
      password: true,
      hide: hidePassword,
      borderRadius: BorderRadius.circular(20.r),
      prefix: _buildIcon(Icons.lock),
      suffix: _buildVisibilityToggle(),
      toggleHide: _togglePasswordVisibility,
    );
  }

  Widget _buildIcon(IconData icon) {
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

  Widget _buildVisibilityToggle() {
    return GestureDetector(
      onTap: _togglePasswordVisibility,
      child: Container(
        margin: EdgeInsets.only(right: 5.h),
        child: Icon(
          hidePassword ? Icons.visibility_off : Icons.visibility,
          size: 25.h,
          color: Colors.black54,
        ),
      ),
    );
  }

  void _handleChangePassword(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AccountBloc>().add(
            ChangePasswordEvent(
              request: Changepassword(
                _passwordController.text,
                _newPasswordController.text,
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Change password",
              style: theme.titleLarge?.copyWith(
                color: AppColors.darkBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50.h),
            Column(
              children: [
                _buildPasswordField(
                  controller: _passwordController,
                  title: 'Current Password',
                  hintText: "Your current password",
                  inputAction: TextInputAction.next,
                  validator: (value) => value?.trim().isEmpty ?? true
                      ? "Current password required"
                      : null,
                ),
                SizedBox(height: 8.h),
                _buildPasswordField(
                  controller: _newPasswordController,
                  title: 'New Password',
                  hintText: "Enter new password",
                  inputAction: TextInputAction.next,
                  validator: (value) => value != null && value.length < 6
                      ? "Enter a stronger password"
                      : null,
                ),
                SizedBox(height: 10.h),
                FullWidthButton(
                  btnheight: 50.h,
                  text: "Change Password",
                  action: () => _handleChangePassword(context),
                ),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text("Cancel"),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
