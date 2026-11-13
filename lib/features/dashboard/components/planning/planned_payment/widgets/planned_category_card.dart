import 'package:fedha/common/category_logo.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlannedPaymentCategoryCard extends StatelessWidget {
  const PlannedPaymentCategoryCard({
    super.key,
    required this.text,
    required this.icon,
    required this.bgColor,
    required this.onPressed,
    required this.description,
    required this.price,
  });
  final String text, description, price;
  final dynamic icon;
  final Color bgColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    int maxLength = 26; // Set your desired maximum length

    return GestureDetector(
      onTap: () {
        onPressed();
        print("Clicked");
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: icon is IconData
                  ? Icon(
                      icon,
                      color: Colors.white,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CategoryLogoImage(
                        imageUrl: icon is String ? icon : null,
                        width: 30,
                        height: 30,
                      ),
                    ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    text.length > maxLength
                        ? "${text.substring(0, maxLength)}..."
                        : text,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          onPressed();
                        },
                        icon: Icon(CupertinoIcons.forward,
                            color: AppColors.greyColor),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
