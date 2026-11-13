part of 'bloc.dart';

class FaqsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;

  final List<FaQ> faqs;
  final List<FaQ> filtered;
  final FaQ? selected;

  const FaqsState(
      {this.status = ServiceStatus.initial,
      this.message,
      this.faqs = const [],
      this.filtered = const [],
      this.selected});

  FaqsState copyWith({
    ServiceStatus? status,
    ApplicationMessage? message,
    List<FaQ>? faqs,
    List<FaQ>? filtered,
    FaQ? selected,
  }) {
    return FaqsState(
      status: status ?? this.status,
      message: message,
      faqs: faqs ?? this.faqs,
      filtered: filtered ?? this.filtered,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [status, message, faqs, selected, filtered];
}
