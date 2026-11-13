import 'package:flutter/material.dart';

enum CardType { info, display, alert }

class AnalyticsCard extends StatelessWidget {
  final Widget? cardHeader;
  final Widget? cardBody;
  final Widget? cardFooter;
  final Icon cardIcon;
  final IconData trailingIcon;
  final double? width;
  final double? height;
  final Function? trailingIconAction;
  final CardType type;

  const AnalyticsCard({
    super.key,
    required this.cardIcon,
    this.cardBody,
    this.cardFooter,
    this.cardHeader,
    this.trailingIconAction,
    this.width = 180,
    this.height = 150,
    this.type = CardType.display,
    this.trailingIcon = Icons.arrow_forward_ios,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = width == 180
        ? screenWidth * 0.4
        : width!; // Adjust card width based on screen width

    return SizedBox(
      height: type == CardType.display ? height : null,
      width: type == CardType.display ? cardWidth : double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: type == CardType.display
              ? const EdgeInsets.fromLTRB(8, 8, 2, 8)
              : const EdgeInsets.fromLTRB(8, 0, 2, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 238, 238),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  padding: type == CardType.display
                      ? const EdgeInsets.all(7)
                      : const EdgeInsets.all(0),
                  child: cardIcon,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  flex: 1,
                  child: cardHeader ?? Container(),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      if (trailingIconAction != null) trailingIconAction!();
                    },
                    icon: Icon(
                      size: type == CardType.display ? 16 : 10,
                      color: Colors.grey,
                      trailingIcon,
                    ),
                  ),
                ),
              ]),
              type == CardType.display
                  ? const SizedBox(
                      height: 4,
                    )
                  : const SizedBox(),
              cardBody ?? Container(),
              type == CardType.display
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(),
              cardFooter ?? Container()
            ],
          ),
        ),
      ),
    );
  }
}
