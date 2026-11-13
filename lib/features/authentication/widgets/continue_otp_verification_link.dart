import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/account/bloc.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/services/route_service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Shown on login/register when a registration OTP is still pending.
class ContinueOtpVerificationLink extends StatefulWidget {
  const ContinueOtpVerificationLink({super.key});

  @override
  State<ContinueOtpVerificationLink> createState() =>
      _ContinueOtpVerificationLinkState();
}

class _ContinueOtpVerificationLinkState
    extends State<ContinueOtpVerificationLink> {
  ({String email, String phone, String? name})? _pending;

  @override
  void initState() {
    super.initState();
    _loadPending();
  }

  Future<void> _loadPending() async {
    final pending =
        await service<AppPreferences>().getPendingOtpVerification();
    if (!mounted) return;
    setState(() => _pending = pending);
  }

  Future<void> _continueVerification() async {
    final pending = _pending ??
        await service<AppPreferences>().getPendingOtpVerification();
    if (pending == null || !mounted) return;

    context.read<AccountBloc>().add(
          RestorePendingOtpUser(
            email: pending.email,
            phone: pending.phone,
            name: pending.name,
          ),
        );
    context.goNamed(Routes.otpVerify);
  }

  @override
  Widget build(BuildContext context) {
    if (_pending == null) return const SizedBox.shrink();

    final theme = Theme.of(context).textTheme;
    return TextButton(
      onPressed: _continueVerification,
      child: Text(
        'Continue email verification',
        textAlign: TextAlign.center,
        style: theme.bodyMedium?.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
