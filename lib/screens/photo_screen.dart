import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../widgets/photo/photo_header.dart';
import '../widgets/photo/camera_view.dart';
import '../widgets/photo/photo_instructions.dart';

class PhotoScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const PhotoScreen({super.key, this.onNavigate});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _image = File(photo.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhotoHeader(onNavigate: widget.onNavigate),
              CameraView(image: _image, onTakePhoto: _takePhoto),
              const SizedBox(height: 20),
              const PhotoInstructions(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
