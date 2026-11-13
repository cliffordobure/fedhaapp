import 'dart:io';

import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/features/app/blocs/profile_image/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildProfileImage(BuildContext context) {
  return Center(
    child: Container(
      height: 95,
      width: 95,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darkBlueColor),
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: BlocBuilder<ProfileImageBloc, File?>(
          builder: (context, state) {
            return ClipOval(
              child: state != null
                  ? Image.file(state, fit: BoxFit.cover)
                  : Image.asset("assets/Images/ic_launcher.png",
                      fit: BoxFit.cover),
            );
          },
        ),
      ),
    ),
  );
}

Widget buildProfileName(BuildContext context) {
  final user = AuthenticationRepository.instance.user;
  return Center(
    child: Text(capitalize(user!.name),
        style: Theme.of(context).textTheme.titleLarge),
  );
}
