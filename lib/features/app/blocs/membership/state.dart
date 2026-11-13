part of 'bloc.dart';

enum MemberOptions { BASIC, BRONZE, SILVER, PREMIUM }

class MembershipState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;

  final List<MembershipOptions> options;
  final Map<MemberOptions, MembershipOptions> data;
  final MemberOptions currentOption;

  const MembershipState(
      {this.status = ServiceStatus.initial,
      this.message,
      this.options = const [],
      this.data = const {},
      this.currentOption = MemberOptions.BASIC});

  MembershipState copyWith(
      {ServiceStatus? status,
      ApplicationMessage? message,
      List<MembershipOptions>? options,
      Map<MemberOptions, MembershipOptions>? data,
      MemberOptions? currentOption}) {
    return MembershipState(
        status: status ?? this.status,
        message: message,
        options: options ?? this.options,
        data: data ?? this.data,
        currentOption: currentOption ?? this.currentOption);
  }

  @override
  List<Object?> get props => [status, message, options, data, currentOption];
}
