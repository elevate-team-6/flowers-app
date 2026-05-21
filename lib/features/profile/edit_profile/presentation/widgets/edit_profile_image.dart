import 'dart:io';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileImage extends StatelessWidget {
  final String image;
  final File? selectedImage;
  final Function(File image) onImageSelected;

  const EditProfileImage({
    super.key,
    required this.image,
    required this.onImageSelected,
    this.selectedImage,
  });

  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);

      onImageSelected(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          child: ClipOval(
            child: selectedImage != null
                ? Image.file(
                    selectedImage!,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )
                : CustomCachedImage(
                    imageUrl: image,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.pink10,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.white90,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
