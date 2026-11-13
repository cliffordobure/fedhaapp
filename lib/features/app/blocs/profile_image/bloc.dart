import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:fedha/localization/profile_image_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// Events
abstract class ProfileImageEvent extends Equatable {
  const ProfileImageEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileImage extends ProfileImageEvent {}

class SaveProfileImage extends ProfileImageEvent {
  final ImageSource source;

  const SaveProfileImage({required this.source});

  @override
  List<Object?> get props => [source];
}

class DeleteProfileImage extends ProfileImageEvent {}

// BLoC
class ProfileImageBloc extends Bloc<ProfileImageEvent, File?> {
  final ProfileImagePickerService _imageService = ProfileImagePickerService();

  ProfileImageBloc() : super(null) {
    on<LoadProfileImage>(_onLoadProfileImage);
    on<SaveProfileImage>(_onSaveProfileImage);
    on<DeleteProfileImage>(_onDeleteProfileImage);
  }

  Future<void> _onLoadProfileImage(
      LoadProfileImage event, Emitter<File?> emit) async {
    try {
      final file = await _imageService.getSavedImage();
      emit(file);
    } catch (e) {
      // Handle error if needed
      emit(null);
    }
  }

  Future<void> _onSaveProfileImage(
      SaveProfileImage event, Emitter<File?> emit) async {
    try {
      final file = await _imageService.pickImage(source: event.source);
      if (file != null) {
        emit(file);
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> _onDeleteProfileImage(
      DeleteProfileImage event, Emitter<File?> emit) async {
    try {
      await _imageService.removeSavedImage();
      emit(null);
    } catch (e) {
      // Handle error if needed
    }
  }
}
