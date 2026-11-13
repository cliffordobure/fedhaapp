import 'package:fedha/data/models/profile/profile_update_data.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/app/blocs/profile_image/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/features/dashboard/components/profile/components/profile_image.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

//TODO: on edit to refresh the state

class _ProfileUpdateState extends State<ProfileUpdate> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = AuthenticationRepository.instance.user;
    _nameController.text = user!.name;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Images/Background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, size: 24.sp),
          ),
          title: Text("Profile Update", style: theme.titleMedium),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        buildProfileImage(context),
                        Positioned(
                          bottom: -10.h,
                          right: 120.w,
                          child: InkWell(
                            onTap: () => _showImageSourceDialog(context),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.darkBlueColor),
                                shape: BoxShape.circle,
                                color: AppColors.whiteColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.w),
                                child: Container(
                                  height: 20.h,
                                  width: 20.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.camera_alt, size: 20.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  buildProfileName(context),
                  SizedBox(height: 30.h),
                  Text("Profile Info", style: theme.titleMedium),
                  SizedBox(height: 25.h),
                  DefaultInputField(
                    textEditingController: _nameController,
                    inputtype: TextInputType.name,
                    inputAction: TextInputAction.next,
                    title: 'Name',
                    hide: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please fill in your full names";
                      }
                      return null;
                    },
                    onSaved: (value) {},
                    onChanged: (value) {},
                    borderRadius: BorderRadius.circular(20.r),
                    hintText: "John Doe",
                    prefix: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.grey.shade400, width: 2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 20.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  DefaultInputField(
                    textEditingController: _phoneController,
                    inputtype: TextInputType.phone,
                    inputAction: TextInputAction.next,
                    title: 'Phone Number',
                    hide: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Phone number required";
                      }
                      // bool phoneNumber =
                      //     RegExp(r"^(\+254|0)(1|7)\d{8}$").hasMatch(value);
                      // if (!phoneNumber) {
                      //   return "Invalid Phone";
                      // }
                      return null;
                    },
                    onSaved: (value) {},
                    onChanged: (value) {},
                    borderRadius: BorderRadius.circular(20.r),
                    hintText: "0700000000",
                    prefix: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.grey.shade400, width: 2),
                      ),
                      child: Icon(
                        Icons.phone,
                        size: 20.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  DefaultInputField(
                    inputAction: TextInputAction.done,
                    textEditingController: _emailController,
                    inputtype: TextInputType.emailAddress,
                    title: 'Email Address',
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
                    onSaved: (value) {},
                    onChanged: (value) {},
                    borderRadius: BorderRadius.circular(20.r),
                    hintText: "johndoe@domain.com",
                    prefix: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.grey.shade400, width: 2),
                      ),
                      child: Icon(
                        Icons.email_sharp,
                        size: 20.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  FullWidthButton(
                    btnheight: 50.h,
                    text: "Update profile",
                    action: () {
                      final form = _formKey.currentState;
                      if (form!.validate()) {
                        context.read<AccountBloc>().add(AccountUpdated(
                              ProfileUpdateData(
                                email: _emailController.text.trim(),
                                name: _nameController.text.trim(),
                                phone: _phoneController.text.trim(),
                              ),
                            ));
                      } else {
                        showError("All fields are required!");
                      }
                    },
                  ),
                  SizedBox(height: 25.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text("Cancel", style: theme.bodyMedium),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Image Source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ProfileImageBloc>().add(
                        const SaveProfileImage(source: ImageSource.camera));
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ProfileImageBloc>().add(
                        const SaveProfileImage(source: ImageSource.gallery));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
