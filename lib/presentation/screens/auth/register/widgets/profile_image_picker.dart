import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  final Function(File pickedImage) onImagePicked;
  const ProfileImagePicker({super.key, required this.onImagePicked});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _image;

  Future<void> _pick() async {
    final res = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (res != null) {
      setState(() => _image = File(res.path));
      widget.onImagePicked(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.primaryColor, width: 2),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null 
                ? Icon(Icons.person, size: 50, color: theme.primaryColor.withOpacity(0.3)) 
                : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pick,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}