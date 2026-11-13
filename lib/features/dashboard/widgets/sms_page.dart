// import 'package:fedha/features/app/blocs/sms/bloc.dart';
// import 'package:fedha/features/common_widgets/toast_messages.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';

// class SmsPage extends StatefulWidget {
//   const SmsPage({super.key});

//   @override
//   State<SmsPage> createState() => _SmsPageState();
// }

// class _SmsPageState extends State<SmsPage> {
//   @override
//   Widget build(BuildContext context) {
//     // Start sms reading
//     if (context.read<SmsBloc>().state.permission ==
//             ServiceStatus.notApplicable ||
//         context.read<SmsBloc>().state.permission ==
//             ServiceStatus.notApplicable) {
//       context.read<SmsBloc>().add(StartListeningEvent());
//     }
//     return BlocListener<SmsBloc, SmsState>(
//       listener: (context, state) {
//         // TODO: implement listener
//         if (state.message != null) {
//           showMessage(message: state.message!.message);
//         }
//       },
//       listenWhen: (previous, current) => previous.message != current.message,
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Messages")),
//         body: BlocBuilder<SmsBloc, SmsState>(
//           builder: (context, state) {
//             if (state.permission == ServiceStatus.enabled) {
//               return state.messages.isEmpty
//                   ? const Center(
//                       child: Card(
//                         child: Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Text("Empty Messages"),
//                         ),
//                       ),
//                     )
//                   : ListView.separated(
//                       itemBuilder: (context, index) => ListTile(
//                             title: Text(
//                               "${state.messages[index].address}",
//                               style: Theme.of(context).textTheme.titleSmall,
//                             ),
//                             subtitle: Text(
//                               "${state.messages[index].body}",
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             ),
//                             trailing: Text(
//                               "${state.messages[index].date}",
//                               style: Theme.of(context).textTheme.bodySmall,
//                             ),
//                           ),
//                       separatorBuilder: (context, index) => const Divider(),
//                       itemCount: state.messages.length);
//             }
//             if (state.permission == ServiceStatus.disabled) {
//               return Column(
//                 children: [
//                   const Text(
//                     'Please enable SMS permissions to receive messages.',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Dispatch an event to request SMS permission
//                       context.read<SmsBloc>().add(StartListeningEvent());
//                     },
//                     child: const Text('Enable Permissions'),
//                   ),
//                 ],
//               );
//             }
//             return Column(
//               children: [
//                 const Text(
//                   'SMS permissions is undetermined: ',
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Dispatch an event to request SMS permission
//                     context.read<SmsBloc>().add(StartListeningEvent());
//                   },
//                   child: const Text('Enable Permissions'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
