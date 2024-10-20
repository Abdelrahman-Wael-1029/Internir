import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_color.dart';
import '../../../utils/size_config.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key,
  });



  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {

  bool _isProfilePicChanged = false;
  final ImagePicker _picker = ImagePicker();
  String? profileImagePath;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        profileImagePath = image.path;
        _isProfilePicChanged = true;
      });
    }
    Navigator.pop(context);
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.mainBlue,),
                title: const Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColor.mainBlue),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: AppColor.mainBlue),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
          children: [
            CircleAvatar(
              radius: SizeConfig.screenHeight*0.110,
              backgroundImage:profileImagePath != null
                  ? FileImage(File(profileImagePath!))
                  : const AssetImage('assets/images/profile_pic.png')
              as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[400],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.mode_edit_outlined,
                        color: AppColor.white,
                        size: 30,
                      ),
                      onPressed: () {
                        _showImageSourceActionSheet();
                      },
              )
            )
          )
        ]
      ),
    );
  }
}