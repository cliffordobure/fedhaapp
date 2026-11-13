import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/auth/Delete/delete_account_request.dart';
import 'package:fedha/data/models/auth/login/login_request.dart';
import 'package:fedha/data/models/auth/login/login_response.dart';
import 'package:fedha/data/models/auth/otp/otp_verify_request.dart';
import 'package:fedha/data/models/auth/password.dart';
import 'package:fedha/data/models/auth/register/register_request.dart';
import 'package:fedha/data/models/auth/social_sign_in.dart';
import 'package:fedha/data/models/profile/changepassword.dart';
import 'package:fedha/data/models/profile/profile_update_data.dart';
import 'package:fedha/data/repository/authentication.dart';
import 'package:fedha/data/services/remote/is_internet_connected_provider.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part "state.dart";
part 'event.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AuthenticationRepository repository;
  late ProfileService profileService;
  late AppPreferences appPreferences;
  late GoogleAuthService googleAuthService;
  AccountBloc(this.repository) : super(const AccountState()) {
    profileService = service<ProfileService>();
    googleAuthService = service<GoogleAuthService>();
    appPreferences = service<AppPreferences>();

    on<ResetAccount>(
      (event, emit) => emit(
        const AccountState(),
      ),
    );

    // utility method
    on<AccountStarted>(_accountStarted);
    on<AccountUpdated>(_updateProfile);
    on<RefreshProfile>(_refreshProfile);
    on<DeleteAccount>(_deleteAccount);
    on<GoogleAuthentication>(_signInByGoogle);
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<VerifyEmailOtp>(_verifyEmailOtp);
    on<ResetVerifyEmailOtp>(_resetVerifyEmailOtp);
    on<VerifyOtp>(_verifyOtp);
    on<RequestOtp>(_requestOtp);
    on<RestorePendingOtpUser>((event, emit) {
      emit(state.copyWith(
        user: User(
          id: state.user?.id ?? 0,
          name: event.name ?? state.user?.name ?? '',
          email: event.email,
          phoneNumber: event.phone,
        ),
      ));
    });
    on<ForgotPasswordEvent>(_forgotPassword);
    on<PasswordResetEvent>(_newPasswords);
    on<ChangePasswordEvent>(_changePassword);
    on<ResetPassword>((event, emit) => null);
    on<GoogleSigneOut>(_signOutByGoogle);
  }

  FutureOr<void> _changePassword(ChangePasswordEvent event, emit) async {
    final connection = await isInternetConnectedProvider.isNetConnected();

    if (connection) {
      showLoading("Please waait...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));
      final response =
          await service<AuthService>().changePassword(event.request);

      response.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
            message: ApplicationMessage.fromFailure(error),
            status: ServiceStatus.submissionFailure,
          ),
        );
      }, onSuccess: (data) {
        showSuccess(data.toString());
      });
    } else {
      showError("Ensure You have an active internet connection");
      emit(state.copyWith(
          message: ApplicationMessage.error(
              "Ensure You have an active internet connection")));
    }
  }

  FutureOr<void> _login(event, emit) async {
    //login user
    // final connection = await isInternetConnectedProvider.isNetConnected();
    // if (connection) {
    showLoading("Please wait...");
    emit(state.copyWith(status: ServiceStatus.submissionInProgress));

    final response = await service<AuthService>().login(event.data);

    final data = response.when(onError: (error) {
      showError(error.error);
      emit(
        state.copyWith(
          message: ApplicationMessage.fromFailure(error),
          status: ServiceStatus.submissionFailure,
        ),
      );
      appPreferences.removeUser();
      return null;
    }, onSuccess: (data) => data);

    if (data == null) return;

    // Drop the loader before auth flips the route. Leaving EasyLoading's
    // overlay up across that redirect hits `_elements.contains(element)`.
    await EasyLoading.dismiss();
    emit(
      state.copyWith(
          user: data.user,
          message: ApplicationMessage.success("Login success"),
          status: ServiceStatus.submissionSuccess,
          accessToken: data.accessToken),
    );
    await AuthenticationRepository.instance.login(data);
    await appPreferences.storeAuthData(data);
    _showSuccessAfterNavigation("Welcome back ${data.user.name}");
    // } else {
    //   emit(state.copyWith(
    //       message: ApplicationMessage.error(
    //           "Ensure You have an active internet connection")));
    // }
  }

  Future<void> _deleteAccount(
      DeleteAccount event, Emitter<AccountState> emit) async {
    print("DeleteAccount event received");
    final connection = await isInternetConnectedProvider.isNetConnected();

    if (!connection) {
      print("No internet connection");
      emit(state.copyWith(
        status: ServiceStatus.submissionFailure,
        message: ApplicationMessage.error(
            "Ensure you have an active internet connection"),
      ));
      return;
    }

    print("Internet connection established");
    emit(state.copyWith(status: ServiceStatus.submissionInProgress));

    final response = await service<AuthService>().deleteAccount(event.password);

    response.when(
      onError: (error) {
        print("Error occurred: ${error.error}");
        emit(state.copyWith(
          status: ServiceStatus.submissionFailure,
          message: ApplicationMessage.fromFailure(error),
        ));
      },
      onSuccess: (data) {
        print("Success: $data");
        emit(state.copyWith(
          status: ServiceStatus.submissionSuccess,
          message: ApplicationMessage.success("Account deleted successfully"),
          user: null, // Clear the user data
        ));
        // Perform any necessary cleanup after account deletion
        AuthenticationRepository.instance.logout();
        appPreferences.removeUser();
      },
    );
  }

  FutureOr<bool> _register(event, emit) async {
    // Check internet connection
    final connection = await isInternetConnectedProvider.isNetConnected();
    if (connection) {
      showLoading("Please wait...");
      // Reset verifyOtp so the register screen listener can react to a
      // fresh false -> true transition after a previous registration.
      emit(state.copyWith(
        status: ServiceStatus.submissionInProgress,
        verifyOtp: false,
      ));

      // Attempt to register the user
      final response = await service<AuthService>().register(event.data);

      final registered = response.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
            message: ApplicationMessage.fromFailure(error),
            status: ServiceStatus.submissionFailure,
            verifyOtp: false,
          ),
        );
        return null;
      }, onSuccess: (data) => data);

      if (registered == null) return false;

      await EasyLoading.dismiss();
      appPreferences.savePendingOtpVerification(
        email: registered.user.email,
        phone: registered.user.phoneNumber,
        name: registered.user.name,
      );
      emit(
        state.copyWith(
          user: registered.user,
          message: ApplicationMessage.success("Registration successful"),
          status: ServiceStatus.submissionSuccess,
          verifyOtp: true,
        ),
      );
      _showSuccessAfterNavigation(registered.message);
      return true;
    } else {
      showError("Ensure you have an active internet connection");
      emit(state.copyWith(
        message: ApplicationMessage.error(
          "Ensure you have an active internet connection",
        ),
        status: ServiceStatus.submissionFailure,
        verifyOtp: false,
      ));
      return false;
    }
  }

  FutureOr<void> _requestOtp(event, emit) async {
    showLoading("Requesting code");
    final response = await service<AuthService>().requestOTP(event.phone);

    response.when(onError: (error) {
      showError(error.error);
    }, onSuccess: (data) {
      showSuccess(data.message);
    });
  }

  FutureOr<void> _verifyEmailOtp(event, emit) async {
    final connection = await isInternetConnectedProvider.isNetConnected();
    if (connection) {
      showLoading("Verifying code...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      final response =
          await service<AuthService>().verifyEmailOTP(event.request);

      response.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
            message: ApplicationMessage.fromFailure(error),
            status: ServiceStatus.submissionFailure,
            verificationSuccess: false,
          ),
        );
      }, onSuccess: (data) {
        showSuccess(data.message ?? "Verification successful");
        appPreferences.clearPendingOtpVerification();
        emit(
          state.copyWith(
              message: ApplicationMessage.success("Verification successful"),
              status: ServiceStatus.submissionSuccess,
              verificationSuccess: true),
        );
      });
    } else {
      showError("Ensure You have an active internet connection");
      emit(state.copyWith(
          message: ApplicationMessage.error(
              "Ensure You have an active internet connection"),
          verificationSuccess: false));
    }
  }

  FutureOr<void> _resetVerifyEmailOtp(event, emit) async {
    final connection = await isInternetConnectedProvider.isNetConnected();
    if (connection) {
      showLoading("Verifying code...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      final response =
          await service<AuthService>().resetVerifyOTP(event.request);

      response.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
            message: ApplicationMessage.fromFailure(error),
            status: ServiceStatus.submissionFailure,
            verificationSuccess: false,
          ),
        );
      }, onSuccess: (data) {
        showSuccess(data.message ?? "Verification successful");
        emit(
          state.copyWith(
              message: ApplicationMessage.success("Verification successful"),
              status: ServiceStatus.submissionSuccess,
              verificationSuccess: true),
        );
      });
    } else {
      showError("Ensure You have an active internet connection");
      emit(state.copyWith(
          message: ApplicationMessage.error(
              "Ensure You have an active internet connection"),
          verificationSuccess: false));
    }
  }

  FutureOr<void> _verifyOtp(event, emit) async {
    final connection = await isInternetConnectedProvider.isNetConnected();
    if (connection) {
      showLoading("Verifying code...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      debugPrint(event.request);

      final response = await service<AuthService>().verifyOTP(event.request);

      response.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
            message: ApplicationMessage.fromFailure(error),
            status: ServiceStatus.submissionFailure,
            verificationSuccess: false,
          ),
        );
      }, onSuccess: (data) {
        showSuccess(data.message ?? "Verification successful");
        emit(
          state.copyWith(
              message: ApplicationMessage.success("Verification successful"),
              status: ServiceStatus.submissionSuccess,
              verificationSuccess: true),
        );
      });
    } else {
      showError("Ensure You have an active internet connection");
      emit(state.copyWith(
          message: ApplicationMessage.error(
              "Ensure You have an active internet connection"),
          verificationSuccess: false));
    }
  }

  FutureOr<void> _newPasswords(event, emit) async {
    final connection = await isInternetConnectedProvider.isNetConnected();
    if (connection) {
      showLoading("Please wait...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      final response = await service<AuthService>().newPassword(event.request);

      response.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
            message: ApplicationMessage.fromFailure(error),
            status: ServiceStatus.submissionFailure,
          ),
        );
      }, onSuccess: (data) {
        showSuccess(data);
        emit(
          state.copyWith(
              status: ServiceStatus.submissionSuccess,
              verificationSuccess: true),
        );
      });
    } else {
      showError("Ensure You have an active internet connection");
      emit(state.copyWith(
          message: ApplicationMessage.error(
              "Ensure You have an active internet connection")));
    }
  }

  FutureOr<void> _forgotPassword(ForgotPasswordEvent event, emit) async {
    final connection = await isInternetConnectedProvider.isNetConnected();
    if (connection) {
      showLoading("Please wait...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      final response = await service<AuthService>().forgotPassword(event.email);

      response.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
            message: ApplicationMessage.fromFailure(error),
            status: ServiceStatus.submissionFailure,
          ),
        );
      }, onSuccess: (data) {
        showSuccess(data);
        emit(
          state.copyWith(
              status: ServiceStatus.submissionSuccess,
              resetRequestSuccess: true),
        );
      });
    } else {
      showError("Ensure You have an active internet connection");
      emit(state.copyWith(
          message: ApplicationMessage.error(
              "Ensure You have an active internet connection")));
    }
  }

  FutureOr<void> _signInByGoogle(event, emit) async {
    showLoading('Please wait');
    final connection = await isInternetConnectedProvider.isNetConnected();
    if (connection) {
      await googleAuthService.signInOutGoogle();
      var res = await googleAuthService.signInWithGoogle();
      debugPrint(res.toString());
      if (res != null) {
        debugPrint("Google response found");
        // Handle resgistration
        final signInData = SocialSignInRequest(
            name: res.displayName ?? "",
            email: res.email ?? "",
            role: "user",
            phone_number: res.phoneNumber ?? "",
            token: res.refreshToken ?? "",
            email_verified: res.emailVerified);

        final signInRes =
            await googleAuthService.registerWithGoogleDetails(signInData);

        final data = signInRes.when(onError: (error) {
          showError(error.error);
          emit(state.copyWith(
            message: ApplicationMessage.fromFailure(error),
            status: ServiceStatus.loadingFailure,
          ));
          return null;
        }, onSuccess: (data) => data);

        if (data != null) {
          await EasyLoading.dismiss();
          emit(state.copyWith(
              message:
                  ApplicationMessage.success("Authenticated successfully"),
              user: data.user,
              status: ServiceStatus.loadingSuccess));
          await AuthenticationRepository.instance.login(data);
          await appPreferences.storeAuthData(data);
          _showSuccessAfterNavigation("Authenticated successfully");
        }
      } else {
        showError("An error was encountered!");
        debugPrint("Google response not found");
        // Do something
        emit(state.copyWith(
            message: ApplicationMessage.error("An error was encountered!")));
      }
    } else {
      showError("Please check your internet connection!");
      emit(
        state.copyWith(
          message: ApplicationMessage.error(
              "Please check your internet connection!"),
        ),
      );
    }
  }

  void _showSuccessAfterNavigation(String message) {
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      showSuccess(message);
    });
  }

  FutureOr<void> _signOutByGoogle(event, emit) async {
    await googleAuthService.signInOutGoogle();
  }

  FutureOr<void> _accountStarted(
      AccountEvent event, Emitter<AccountState> emit) async {
    emit(
      state.copyWith(
        status: ServiceStatus.loading,
      ),
    );
    // fetch user profile
    final data = await appPreferences.getAuthData();

    if (data != null) {
      emit(
        state.copyWith(
          user: data.user,
          accessToken: data.accessToken,
          status: ServiceStatus.loadingSuccess,
        ),
      );
      // Save token to repo
      await AuthenticationRepository.instance.login(data);
    } else {
      emit(
        state.copyWith(
          status: ServiceStatus.loadingFailure,
          message: const ApplicationMessage(
              message: "Failed to retrieve user data",
              type: ApplicationMessageType.error),
        ),
      );
    }
  }

  FutureOr<void> _updateProfile(
      AccountUpdated event, Emitter<AccountState> emit) async {
    showLoading("Please wait");
    emit(
      state.copyWith(status: ServiceStatus.submissionInProgress),
    );

    final res = await profileService.updateProfile(event.data);

    res.when(onError: (error) {
      showError(error.error);
      emit(
        state.copyWith(
          status: ServiceStatus.submissionFailure,
          message: ApplicationMessage.fromFailure(error),
        ),
      );
    }, onSuccess: (data) {
      showSuccess(data);
      emit(
        state.copyWith(
          status: ServiceStatus.submissionSuccess,
          message: ApplicationMessage.success(data),
        ),
      );
    });
  }

  // refresh profile
  FutureOr<void> _refreshProfile(
      AccountEvent event, Emitter<AccountState> emit) async {
    emit(
      state.copyWith(
        status: ServiceStatus.loading,
      ),
    );
    // fetch user profile
    final res = await profileService.fetchProfile();

    res.when(onError: (error) {
      showError(ApplicationMessage.fromFailure(error).message);
    }, onSuccess: (data) async {
      emit(
        state.copyWith(user: data),
      );

      // Update repository
      final repo = AuthenticationRepository.instance;

      final loginRespose =
          LoginResponse(user: data, accessToken: repo.authToken!);

      await AuthenticationRepository.instance.login(loginRespose);
    });
  }
}
