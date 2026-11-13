// import 'package:another_telephony/telephony.dart';
// import 'package:equatable/equatable.dart';
// import 'package:fedha/data/models/application_message.dart';
// import 'package:fedha/data/repository/sms_repository.dart';
// import 'package:fedha/data/services/service.dart' as it;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';

// part 'event.dart';
// part 'state.dart';

// class SmsBloc extends Bloc<SmsEvent, SmsState> {
//   // Instantiate telephony
//   final Telephony telephony = Telephony.instance;
//   SmsBloc() : super(const SmsState()) {
//     telephony.listenIncomingSms(
//         onNewMessage: (SmsMessage message) {
//           // Handle message
//           add(NewMessageEvent(message));
//         },
//         listenInBackground: false);

//     // Start message listening
//     on<StartListeningEvent>((event, emit) async {
//       bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
//       if (permissionsGranted != null && permissionsGranted) {
//         emit(state.copyWith(permission: ServiceStatus.enabled));
//         // Get all sms
//         List<SmsMessage> messages = await telephony.getInboxSms(
//             columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
//             filter: SmsFilter.where(SmsColumn.ADDRESS).equals("KCB"),
//             sortOrder: [
//               OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC),
//               OrderBy(SmsColumn.BODY)
//             ]);
//         // Save to state
//         emit(state.copyWith(messages: messages));
//       }
//     });

//     // Handle new message event
//     on<NewMessageEvent>((event, emit) async {
//       // Add to list of messages
//       emit(
//         state.copyWith(
//             message: ApplicationMessage.success(
//                 "New message from ${event.message.address}"),
//             messages: [event.message, ...state.messages]),
//       );
//       final res = await it.service<SmsTransformer>().handle(event.message);
//       res.when(onError: (error) {
//         debugPrint(error.description);
//       }, onSuccess: (data) {
//         // Sms transmissions success
//         debugPrint("Sms submission success");
//       });
//     });
//   }
// }
