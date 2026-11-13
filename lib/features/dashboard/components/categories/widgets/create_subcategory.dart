// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fedha/data/models/planned_payment/planned_payment.dart';
import 'package:fedha/features/app/blocs/expenses/bloc.dart';
import 'package:fedha/features/app/blocs/incomes/bloc.dart';
import 'package:fedha/features/common_widgets/DefaultInputField.dart';
import 'package:fedha/features/common_widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart'; // for specifying content type of images

enum CategoryTypes { income, expense }

class CreateSubCategory extends StatefulWidget {
  final int categoryType;
  final int category;
  final Subcategory subcategory;
  final bool update;

  const CreateSubCategory({
    super.key,
    required this.category,
    this.subcategory = const Subcategory(
      id: 1,
      name: " ",
      categoryId: 1,
      status: 1,
      createdAt: "createdAt",
      updatedAt: "updatedAt",
    ),
    required this.categoryType,
    this.update = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CreateSubCategoryState createState() => _CreateSubCategoryState();
}

class _CreateSubCategoryState extends State<CreateSubCategory> {
  final TextEditingController newCategoryTypeController =
      TextEditingController();
  final ValueNotifier<XFile?> _selectedImage = ValueNotifier<XFile?>(null);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.update) {
      newCategoryTypeController.text = widget.subcategory.name;
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _selectedImage.value = image;
      }
    } catch (e) {
      _showErrorDialog('Error picking image: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildIconSelector() {
    return ValueListenableBuilder<XFile?>(
      valueListenable: _selectedImage,
      builder: (context, image, child) {
        return GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(50),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.add_photo_alternate,
                    size: 40,
                    color: Colors.grey[600],
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Specify Subcategory",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildIconSelector(),
            const SizedBox(height: 16),
            DefaultInputField(
              textEditingController: newCategoryTypeController,
              inputtype: TextInputType.text,
              title: 'Name',
              inputAction: TextInputAction.done,
              hide: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name is required";
                }
                if (value.length > 255) {
                  return "Name must be less than 255 characters";
                }
                return null;
              },
              borderRadius: BorderRadius.circular(20.r),
              hintText: "Name of Sub-Category",
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  FullWidthButton(
                    action: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final Map<String, dynamic> data = {
                        "name": newCategoryTypeController.text.trim(),
                        "category_id": widget.category,
                      };

                      String? mimeType;

                      if (_selectedImage.value != null) {
                        final fileExtension =
                            _selectedImage.value!.path.split('.').last;

                        switch (fileExtension.toLowerCase()) {
                          case 'jpeg':
                          case 'jpg':
                            mimeType = 'image/jpeg';
                            break;
                          case 'png':
                            mimeType = 'image/png';
                            break;
                          case 'gif':
                            mimeType = 'image/gif';
                            break;
                          default:
                            _showErrorDialog('Invalid image type');
                            return;
                        }
                      }

                      FormData formData = FormData.fromMap(data);

                      if (_selectedImage.value != null) {
                        final file = await MultipartFile.fromFile(
                          _selectedImage.value!.path,
                          filename: _selectedImage.value!.name,
                          contentType: MediaType(
                              'image',
                              mimeType ??
                                  "jpeg"), // jpeg, png, jpg, gif handled
                        );

                        formData.files.add(
                            MapEntry("image", file)); // Add file to FormData
                      }

                      if (!widget.update) {
                        if (widget.categoryType == 0) {
                          context.read<ExpenseBloc>().add(
                                SaveExpenseSubCategory(data: formData),
                              );
                        } else {
                          context.read<IncomeBloc>().add(
                                SaveIncomeSubCategory(data: formData),
                              );
                        }
                      } else {
                        if (widget.categoryType == 0) {
                          context.read<ExpenseBloc>().add(
                                UpdateExpenseSubCategory(
                                  subcategoryId: widget.subcategory.id,
                                  data: formData,
                                ),
                              );
                        } else {
                          context.read<IncomeBloc>().add(
                                UpdateIncomeSubCategory(
                                  subcategoryId: widget.subcategory.id,
                                  data: formData,
                                ),
                              );
                        }
                      }

                      context.pop();
                    },
                    text: !widget.update
                        ? "Create Sub-Category"
                        : "Update Sub-Category",
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text("Dismiss"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
