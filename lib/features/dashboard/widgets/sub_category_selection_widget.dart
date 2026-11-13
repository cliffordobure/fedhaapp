import 'package:fedha/common/category_logo.dart';
import 'package:fedha/data/models/categories/categories.dart' as category;
import 'package:flutter/material.dart';

class SubCategorySelectionWidget extends StatelessWidget {
  final List<category.SubCategory> subCategories;
  final category.SubCategory? selectedSubCategory;
  final void Function(category.SubCategory) onSubCategorySelected;

  const SubCategorySelectionWidget({
    Key? key,
    required this.subCategories,
    required this.selectedSubCategory,
    required this.onSubCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: SingleChildScrollView(
        child: Column(
          children: subCategories
              .map(
                (e) => _getSubCategoryWidget(
                  e,
                  e.id == selectedSubCategory?.id,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _getSubCategoryWidget(
      category.SubCategory subCategory, bool isSelected) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => onSubCategorySelected(subCategory),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey),
              color: isSelected ? Colors.green[200] : Colors.grey[200],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CategoryLogoImage(
                    imageUrl: subCategory.image,
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Text(subCategory.name),
                const Spacer(),
                Radio<int>(
                  value: subCategory.id,
                  groupValue: selectedSubCategory?.id,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
