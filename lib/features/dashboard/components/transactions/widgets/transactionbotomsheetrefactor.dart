// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:fedha/theme/theme_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class StepperBottomSheet extends StatefulWidget {
//   const StepperBottomSheet({
//     Key? key,
//     required this.title,
//     required this.steps,
//     required this.stepContents,
//     this.onSave,
//     this.onNext,
//   }) : super(key: key);

//   final String title;
//   final List<EasyStep> steps;
//   final List<Widget> stepContents;
//   final VoidCallback? onSave;
//   final VoidCallback? onNext;

//   @override
//   State<StepperBottomSheet> createState() => _StepperBottomSheetState();
// }

// class _StepperBottomSheetState extends State<StepperBottomSheet> {
//   int _currentStep = 0;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.9, // Adjust as needed
//       minChildSize: 0.5,
//       maxChildSize: 1,
//       builder: (_, controller) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             image: DecorationImage(
//               image: AssetImage('assets/Images/Background.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             children: [
//               _buildStickyHeader(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: controller,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                               height: 20), // Add some space at the top
//                           widget.stepContents[_currentStep],
//                           const SizedBox(height: 10),
//                           _buildNavigationButtons(),
//                           const SizedBox(height: 5),
//                           _buildDiscardButton(context),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildStickyHeader() {
//     return Container(
//       color: Colors.white.withOpacity(0.9),
//       child: Column(
//         children: [
//           _buildTitle(),
//           _buildStepper(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTitle() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//       child: Center(
//         child: Text(
//           widget.title,
//           style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 fontSize: 18,
//                 color: AppColors.darkBlueColor,
//                 fontWeight: FontWeight.w700,
//               ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStepper() {
//     return EasyStepper(
//       activeStep: _currentStep,
//       steps: widget.steps,
//       onStepReached: (index) {
//         setState(() {
//           _currentStep = index;
//         });
//       },
//     );
//   }

//   Widget _buildNavigationButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         if (_currentStep > 0)
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _currentStep--;
//               });
//             },
//             child: const Text(
//               'Previous',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         if (_currentStep < widget.steps.length - 1)
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _currentStep++;
//               });
//               if (widget.onNext != null) {
//                 widget.onNext!.call();
//               }
//             },
//             child: const Text(
//               'Next',
//               style: TextStyle(color: Colors.white),
//             ),
//           )
//         else
//           ElevatedButton(
//             onPressed: () {
//               // final form = Form.of(context);
//               widget.onSave!();
//               // if (form != null && form.validate() && widget.onSave != null) {
//               //   widget.onSave!();
//               // }
//             },
//             child: const Text(
//               'Save',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildDiscardButton(BuildContext context) {
//     return Center(
//       child: TextButton(
//         onPressed: () {
//           context.pop();
//         },
//         child: const Text("Discard"),
//       ),
//     );
//   }
// }
