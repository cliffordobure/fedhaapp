import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/chats/chat.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part "events.dart";
part 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late ChatService chatService;
  ChatBloc() : super(const ChatState()) {
    chatService = service<ChatService>();

    on<ChatOpened>((event, emit) async {
      // showLoading("Loading");
      emit(
        state.copyWith(status: ServiceStatus.loading, chats: []),
      );
      final messages = await chatService.chat();
      messages.when(
        onError: (error) {
          showError(ApplicationMessage.fromFailure(error).message);
          emit(
            state.copyWith(
              status: ServiceStatus.loadingFailure,
            ),
          );
        },
        onSuccess: (data) {
          EasyLoading.dismiss();
          final List<Message> messages = [];
          for (var e in data) {
            final List<ChatResponse> responses = e.response;
            final msg = Message.fromChat(e);

            messages.add(msg);

            for (var element in responses) {
              messages.add(Message.fromResponse(element));
            }
          }

          messages.sort((a, b) => a.created.compareTo(b.created));
          emit(
            state.copyWith(
                status: ServiceStatus.loadingSuccess,
                chats: data,
                messages: messages),
          );
        },
      );
    });

    // Refresh
    on<RefreshChats>((event, emit) async {
      final messages = await chatService.chat();
      messages.when(
        onError: (error) {
          showError(ApplicationMessage.fromFailure(error).message);
        },
        onSuccess: (data) {
          final List<Message> messages = [];
          for (var e in data) {
            final List<ChatResponse> responses = e.response;
            final msg = Message.fromChat(e);

            messages.add(msg);

            for (var element in responses) {
              messages.add(Message.fromResponse(element));
            }
          }

          messages.sort((a, b) => a.created.compareTo(b.created));
          emit(
            state.copyWith(chats: data, messages: messages),
          );
        },
      );
    });

    on<MessageSend>((event, emit) async {
      emit(
        state.copyWith(
          status: ServiceStatus.submissionInProgress,
        ),
      );
      final message = await chatService.send(message: event.message);
      message.when(
        onError: (error) {
          showError(ApplicationMessage.fromFailure(error).message);
          emit(
            state.copyWith(
              status: ServiceStatus.submissionFailure,
            ),
          );
        },
        onSuccess: (data) {
          showSuccess(data);
          emit(
            state.copyWith(
              status: ServiceStatus.submissionSuccess,
            ),
          );
          add(RefreshChats());
        },
      );
    });
  }
}
