import 'package:fedha/common/category_logo.dart';
import 'package:flutter/material.dart';
import 'package:fedha/data/models/categories/categories.dart' as category;

class SubcategorySelectionWidget extends StatefulWidget {
  final List<category.SubCategory> subcategories;
  final Function(category.SubCategory?) onSubcategorySelected;

  const SubcategorySelectionWidget({
    Key? key,
    required this.subcategories,
    required this.onSubcategorySelected,
  }) : super(key: key);

  @override
  _SubcategorySelectionWidgetState createState() => _SubcategorySelectionWidgetState();
}

class _SubcategorySelectionWidgetState extends State<SubcategorySelectionWidget> {
  category.SubCategory? selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    return _buildSubcategoryList();
  }

  Widget _buildSubcategoryList() {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: widget.subcategories.map((e) => _buildSubcategoryItem(e)).toList(),
        ),
      ),
    );
  }

  Widget _buildSubcategoryItem(category.SubCategory subcategory) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubCategory = subcategory;
          widget.onSubcategorySelected(subcategory);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CategoryLogoImage(
                  imageUrl: subcategory.image,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 8),
              Text(subcategory.name),
              const Spacer(),
              Radio<int>(
                value: subcategory.id,
                groupValue: selectedSubCategory?.id,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}