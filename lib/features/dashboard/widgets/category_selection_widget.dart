import 'package:fedha/common/category_logo.dart';
import 'package:fedha/data/models/categories/categories.dart' as category;
import 'package:flutter/material.dart';

class CategorySelectionWidget extends StatelessWidget {
  final List<category.Category> categories;
  final category.Category? selectedCategory;
  final void Function(category.Category) onCategorySelected;

  const CategorySelectionWidget({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: SingleChildScrollView(
        child: Column(
          children: categories
              .map((e) => DropdownMenuItem<category.Category>(
                    value: e,
                    child: _getCategoryWidget(e, e.id == selectedCategory?.id),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _getCategoryWidget(category.Category category, bool isSelected) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => onCategorySelected(category),
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
                    imageUrl: category.image,
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Text(category.name),
                const Spacer(),
                Radio<int>(
                  value: category.id,
                  groupValue: selectedCategory?.id,
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
