import 'package:fedha/data/models/subscriptions/subscriptions.dart';
import 'package:fedha/data/models/wallet/wallet.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/subscriptions/bloc.dart';
import 'package:fedha/features/app/blocs/wallets/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NewSubscriptionScreen extends StatefulWidget {
  const NewSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<NewSubscriptionScreen> createState() => _NewSubscriptionScreenState();
}

class _NewSubscriptionScreenState extends State<NewSubscriptionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _newSubscriptionTypeController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FormSubscription? selectedSubscription;
  FormSubscriptionSpans? subscriptionSpan;
  Wallet? selectedWallet;

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    if (context.read<SubscriptionsBloc>().state.formStatus ==
        ServiceStatus.initial) {
      context.read<SubscriptionsBloc>().add(StartSubscriptionForm());
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'assets/Images/Background.png',
            ),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(
              child: Text("New Subscription",
                  style: theme.titleMedium!.copyWith(
                      fontSize: 18,
                      color: AppColors.darkBlueColor,
                      fontWeight: FontWeight.w700))),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Subscription name",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: const Color(0XFF555555),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                    builder: (context, state) {
                      if (state.status == ServiceStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      if (state.status == ServiceStatus.loadingFailure) {
                        return const Center(
                          child: Text("Failed to load subscriptions"),
                        );
                      }

                      final formSubscriptions = state.formSubscriptions;

                      if (formSubscriptions.isEmpty) {
                        return const Text("No subscription service listed");
                      }

                      // Ensure selectedSubscription is a valid value
                      if (!formSubscriptions.contains(selectedSubscription)) {
                        selectedSubscription = formSubscriptions
                            .first; // or any other default value
                      }

                      return DropdownButtonFormField<FormSubscription>(
                          value: selectedSubscription,
                          items: [
                            ...formSubscriptions,
                            const FormSubscription(
                                id: -1, name: "Other (Add New)")
                          ]
                              .map(
                                (e) => DropdownMenuItem<FormSubscription>(
                                  value: e, // Set the value to the item
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            // Create a new budget type field
                            if (value!.name.toLowerCase().contains("other")) {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        insetPadding: const EdgeInsets.all(16),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Specify service name",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              DefaultInputField(
                                                textEditingController:
                                                    _newSubscriptionTypeController,
                                                inputtype: TextInputType.text,
                                                title: 'Name',
                                                inputAction:
                                                    TextInputAction.done,
                                                hide: false,
                                                validator: (onValidateVal) {
                                                  if (onValidateVal.isEmpty) {
                                                    return "Name";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String? onSavedVal) {
                                                  if (kDebugMode) {
                                                    print("on saved calles");
                                                  }
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                hintText:
                                                    "Name of subscription service",
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Column(
                                                  children: [
                                                    FullWidthButton(
                                                      action: () {
                                                        context
                                                            .read<
                                                                SubscriptionsBloc>()
                                                            .add(
                                                              NewSubscriptionType(
                                                                  name: _newSubscriptionTypeController
                                                                      .text
                                                                      .trim()),
                                                            );
                                                        // close dialog
                                                        context.pop();
                                                      },
                                                      text:
                                                          "Add Subscription Type",
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        child: const Text(
                                                            "Dismiss"))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            } else {
                              setState(() {
                                selectedSubscription = value;
                              });
                            }
                          },
                          validator: (value) {
                            if (selectedSubscription == null || value == null) {
                              return "Please select a subscription";
                            }
                            return null;
                          },
                          decoration: getDropDownDecoration(
                              context, true, "Select subscription"));
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Subscription Type",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: const Color(0XFF555555),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                    builder: (context, state) {
                      if (state.status == ServiceStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      if (state.status == ServiceStatus.loadingFailure) {
                        return const Center(
                          child: Text("Failed to load spans"),
                        );
                      }

                      final formSubscriptionSpans = state.formSubscriptionSpans;

                      if (formSubscriptionSpans.isEmpty) {
                        return const Text("No categories listed");
                      }

                      // Ensure subscriptionSpan is a valid value
                      if (!formSubscriptionSpans.contains(subscriptionSpan)) {
                        subscriptionSpan = formSubscriptionSpans
                            .first; // or any other default value
                      }

                      return DropdownButtonFormField<FormSubscriptionSpans>(
                          value: subscriptionSpan,
                          items: formSubscriptionSpans
                              .map((e) =>
                                  DropdownMenuItem<FormSubscriptionSpans>(
                                    value: e, // Set the value to the item
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              subscriptionSpan = value;
                            });
                          },
                          validator: (value) {
                            if (subscriptionSpan == null || value == null) {
                              return "Please select a category";
                            }
                            return null;
                          },
                          decoration: getDropDownDecoration(
                              context, true, "Select category"));
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  DefaultInputField(
                    textEditingController: _amountController,
                    inputtype: TextInputType.number,
                    title: 'Amount',
                    hide: false,
                    validator: (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return "Amount is required";
                      }
                      return null;
                    },
                    onSaved: (String? onSavedVal) {
                      if (kDebugMode) {
                        print("on saved calles");
                      }
                    },
                    borderRadius: BorderRadius.circular(20.r),
                    hintText: "Amount in Ksh.",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Associated wallet",
                        style: theme.displayMedium!.copyWith(
                            color: const Color(0XFF555555),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<WalletsBloc, WalletsState>(
                        builder: (context, state) {
                          if (state.status == ServiceStatus.loading) {
                            return const CircularProgressIndicator();
                          }
                          if (state.status == ServiceStatus.loadingFailure) {
                            return const Center(
                              child: Text("Failed to load wallets"),
                            );
                          }

                          final wallets = state.wallets;

                          if (wallets.isEmpty) {
                            return const Text(
                                "You don't have any saved wallet");
                          }

                          // Ensure selectedWallet is a valid value
                          if (!wallets.contains(selectedWallet)) {
                            selectedWallet =
                                wallets.first; // or any other default value
                          }

                          return DropdownButtonFormField<Wallet>(
                              value: selectedWallet,
                              items: wallets
                                  .map((e) => DropdownMenuItem<Wallet>(
                                        value: e, // Set the value to the item
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          AppColors.greyColor,
                                                      width: 1),
                                                  shape: BoxShape.circle),
                                              child: Image.network(
                                                e.img,
                                                height: 35,
                                                width: 35,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Text(
                                              e.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                      color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedWallet = value;
                                });
                              },
                              validator: (value) {
                                if (selectedWallet == null || value == null) {
                                  return "Please select a wallet";
                                }
                                return null;
                              },
                              decoration: getDropDownDecoration(
                                  context, true, "Select wallet"));
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        FullWidthButton(
                          action: () {
                            final form = _formKey.currentState;

                            if (form!.validate()) {
                              context.read<SubscriptionsBloc>().add(
                                    NewSubscription({
                                      "subscription_type": subscriptionSpan?.id,
                                      "subscription_id":
                                          selectedSubscription?.id,
                                      "wallet_id": selectedWallet?.id,
                                      "amount": _amountController.text.trim()
                                    }),
                                  );
                            }
                          },
                          text: "Save subscription",
                        ),
                        // TextButton(
                        //     onPressed: () {
                        //       context.pop();
                        //     },
                        //     child: const Text("Cancel"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
