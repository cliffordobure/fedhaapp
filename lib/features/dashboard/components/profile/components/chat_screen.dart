import 'package:fedha/common/animate_in_effect.dart';
import 'package:fedha/data/models/chats/chat.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/chat/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({super.key});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late ScrollController _scrollController;
  final TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
    // fetch messages
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatBloc>().add(ChatOpened());

      Future.delayed(const Duration(seconds: 2), () {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<ChatBloc>().state.status == ServiceStatus.initial) {
      context.read<ChatBloc>().add(ChatOpened());
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
        title: Text(
          "Help desk",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
              color: AppColors.darkBlueColor,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state.status == ServiceStatus.loading) {
                    return Container(
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state.status == ServiceStatus.loadingFailure) {
                    return Container(
                      child: Center(
                        child: TextButton(
                            onPressed: () {
                              context.read<ChatBloc>().add(ChatOpened());
                            },
                            child: const Text("Retry")),
                      ),
                    );
                  }
                  return GroupedListView<Message, DateTime>(
                    padding: const EdgeInsets.all(8),
                    elements: state.messages,
                    reverse: false,
                    order: GroupedListOrder.DESC,
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    groupBy: (message) => DateTime(message.created.year,
                        message.created.month, message.created.day),
                    groupHeaderBuilder: (Message message) => SizedBox(
                      height: 40,
                      child: Center(
                        child: Card(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat.yMMMd().format(message.created),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    indexedItemBuilder: (context, Message message, index) =>
                        AnimateInEffect(
                      intervalStart: index / state.messages.length,
                      child: Column(
                        children: [
                          Bubble(
                            text: state.messages[index].message,
                            isCurrentUser: !state.messages[index].isResponse,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SendMsg(
              messageController: messageController,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  const Bubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ChatBubble(
            elevation: 0,
            clipper: ChatBubbleClipper4(
                type: isCurrentUser
                    ? BubbleType.sendBubble
                    : BubbleType.receiverBubble),
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 20),
            backGroundColor: isCurrentUser
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(.2),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: !isCurrentUser
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SendMsg extends StatelessWidget {
  const SendMsg({super.key, required this.messageController});

  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 80),
      width: double.infinity,
      child: Form(
        // key: _msgForm,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  fillColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey.shade500),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey.shade500),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter message to send";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return IconButton.filled(
                  style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(Size(50, 50)),
                      shape: const WidgetStatePropertyAll(StadiumBorder()),
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).primaryColor)),
                  padding: const EdgeInsets.all(8),
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      context.read<ChatBloc>().add(
                            MessageSend(messageController.text),
                          );
                      messageController.clear();
                      FocusScope.of(context).unfocus();
                    } else {
                      showToast("Cannot send empty message");
                    }
                  },
                  icon: state.status == ServiceStatus.submissionInProgress
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
