import 'package:fedha/data/models/membership/membership.dart';
import 'package:fedha/features/app/blocs/membership/bloc.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembershipCard extends StatefulWidget {
  const MembershipCard(
      {super.key,
      required this.primary,
      required this.background,
      required this.option,
      required this.memberOption,
      this.isOutlined = false,
      this.isCurrent = false});
  final Color primary;
  final Color background;
  final MembershipOptions option;
  final bool isOutlined;
  final MemberOptions memberOption;
  final bool isCurrent;

  @override
  State<MembershipCard> createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard> {
  int defaultTake = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          widget.isCurrent
              ? const Positioned(
                  top: 4,
                  right: 4,
                  child: CircleAvatar(
                    child: Icon(Icons.check),
                  ))
              : const SizedBox.shrink(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.option.name,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold, color: widget.primary),
              ),
              Text(
                "Ksh ${widget.option.price}",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlueColor),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: widget.isOutlined
                        ? OutlinedButton(
                            onPressed: () {
                              context
                                  .read<MemberShipBloc>()
                                  .add(Subscribe(plan: widget.option.id));
                            },
                            child: Text(
                                widget.memberOption == MemberOptions.BASIC
                                    ? "Already Here"
                                    : "Choose Plan"),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(widget.primary)),
                            onPressed: () {
                              context
                                  .read<MemberShipBloc>()
                                  .add(Subscribe(plan: widget.option.id));
                              // context
                              //     .read<MemberShipBloc>()
                              //     .add(SubscriptionSelected(option: widget.option));
                            },
                            child: Text(
                              "Choose Plan",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                itemCount: widget.option.features.take(defaultTake).length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FeatureWidget(
                        feature: widget.option.features
                            .take(defaultTake)
                            .toList()[index],
                        iconColor: widget.primary),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              widget.option.features.length > 3
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          if (defaultTake != 3) {
                            defaultTake = 3;
                          } else {
                            defaultTake = widget.option.features.length;
                          }
                        });
                      },
                      child: Text(defaultTake > 3 ? 'View Less' : 'View All'),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureWidget extends StatelessWidget {
  const FeatureWidget(
      {super.key, required this.feature, required this.iconColor});
  final MembershipFeature feature;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check, color: iconColor),
        const SizedBox(
          width: 16,
        ),
        Expanded(child: Text(feature.feature))
      ],
    );
  }
}
