import 'dart:io';

import 'package:fedha/constants/constants.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/features/app/blocs/dashboard/bloc.dart';
import 'package:fedha/features/app/blocs/profile_image/bloc.dart';
import 'package:fedha/features/dashboard/components/home/widgets/home_net_worth_card.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    // Emit profile image read event
    context.read<ProfileImageBloc>().add(LoadProfileImage());

    final user = AuthenticationRepository.instance.user;

    void push(String route) {
      zoomDrawerController.toggle?.call();
      context.pushNamed(route);
    }

    Future<void> signOut() async {
      zoomDrawerController.toggle?.call();
      final bool? confirmLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => const LogoutDialog(),
      );
      if (confirmLogout == true && context.mounted) {
        context.read<AccountBloc>().add(GoogleSigneOut());
        AuthenticationRepository.instance.logout();
        context.goNamed(Routes.login);
      }
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HomeDesign.mint,
            HomeDesign.mintSoft,
            Colors.white,
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 46.h, 16.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(
            name: capitalize(user?.name ?? ''),
            email: user?.email ?? '',
            onTap: () {
              context
                  .read<DashboardControllerBloc>()
                  .add(const PositionEvent(4));
              zoomDrawerController.toggle?.call();
              context.goNamed(Routes.profile);
            },
          ),
          SizedBox(height: 26.h),
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 8),
            child: Text(
              'MENU',
              style: HomeDesign.text(
                size: 11,
                weight: FontWeight.w700,
                color: HomeDesign.muted,
                letterSpacing: 1.4,
              ),
            ),
          ),
          DrawerTiles(
            onTap: () {
              context
                  .read<DashboardControllerBloc>()
                  .add(const PositionEvent(4));
              zoomDrawerController.toggle?.call();
              context.goNamed(Routes.profile);
            },
            text: "Profile",
            icon: _svg("assets/Icons/Icon ionic-md-person.svg"),
          ),
          DrawerTiles(
            onTap: () => push(Routes.transactions),
            text: "Transactions",
            icon: const Icon(Icons.swap_horiz,
                size: 18, color: HomeDesign.greenDeep),
          ),
          DrawerTiles(
            onTap: () => push(Routes.bills),
            text: "Bill Tracker",
            icon: _svg("assets/Icons/Icon material-track-changes.svg"),
          ),
          DrawerTiles(
            onTap: () => push(Routes.articles),
            text: "Articles",
            icon: _svg("assets/Icons/Icon material-business-center.svg"),
          ),
          DrawerTiles(
            onTap: () => push(Routes.categories),
            text: "Categories",
            icon: _svg("assets/Icons/Icon awesome-buromobelexperte.svg"),
          ),
          DrawerTiles(
            onTap: () => push(Routes.calculator),
            text: "Calculator",
            icon: const Icon(Icons.calculate,
                size: 18, color: HomeDesign.greenDeep),
          ),
          DrawerTiles(
            onTap: () => push(Routes.help),
            text: "Help Center",
            icon: _svg("assets/Icons/Group 389.svg"),
          ),
          const Spacer(),
          DrawerTiles(
            onTap: signOut,
            text: "Sign Out",
            destructive: true,
            icon: _svg(
              "assets/Icons/Icon open-account-logout.svg",
              color: HomeDesign.expense,
            ),
          ),
        ],
      ),
    );
  }

  Widget _svg(String asset, {Color color = HomeDesign.greenDeep}) {
    return SvgPicture.asset(
      asset,
      width: 17,
      height: 17,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.onTap,
  });

  final String name;
  final String email;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD5EEDF)),
            boxShadow: [
              BoxShadow(
                color: HomeDesign.greenDeep.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                padding: const EdgeInsets.all(2.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [HomeDesign.green, HomeDesign.greenDeep],
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: BlocBuilder<ProfileImageBloc, File?>(
                    builder: (context, state) => ClipOval(
                      child: state != null
                          ? Image.file(state, fit: BoxFit.cover)
                          : Image.asset(
                              "assets/Images/ic_launcher.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HomeDesign.text(
                        size: 15,
                        weight: FontWeight.w700,
                        color: HomeDesign.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HomeDesign.text(
                        size: 11.5,
                        color: HomeDesign.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTiles extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final String text;
  final bool destructive;
  const DrawerTiles({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.text,
    this.destructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = destructive ? HomeDesign.expense : HomeDesign.greenDeep;
    final chipColor =
        destructive ? const Color(0xFFFDECEC) : const Color(0xFFDDF2E5);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: destructive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: accent.withValues(alpha: 0.08),
          highlightColor: accent.withValues(alpha: 0.06),
          child: Container(
            height: 46.h,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: destructive
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF6D3D3)),
                  )
                : null,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: chipColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: HomeDesign.text(
                      size: 14,
                      weight: FontWeight.w600,
                      color: destructive ? HomeDesign.expense : HomeDesign.ink,
                    ),
                  ),
                ),
                if (!destructive)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: HomeDesign.greenDeep.withValues(alpha: 0.35),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text('Logout Confirmation'),
      content: const Text('Are you sure you want to logout?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false); // Return false if canceled
          },
        ),
        TextButton(
          child: Text(
            'Logout',
            style: TextStyle(color: AppColors.dangerColor),
          ),
          onPressed: () {
            Navigator.of(context).pop(true); // Return true if confirmed
          },
        ),
      ],
    );
  }
}

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text('Account deletion Confirmation'),
      content: const Text('Are you sure you want to delete account?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false); // Return false if canceled
          },
        ),
        TextButton(
          child: Text(
            'Delete Account',
            style: TextStyle(color: AppColors.dangerColor),
          ),
          onPressed: () {
            Navigator.of(context).pop(true); // Return true if confirmed
          },
        ),
      ],
    );
  }
}
