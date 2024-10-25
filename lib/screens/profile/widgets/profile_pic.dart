import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_color.dart';
import '../../../utils/size_config.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final ImagePicker _picker = ImagePicker();
  String? image; // Store the current image URL
  bool isLoading = true;

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  //----LOAD PROFILE PICTURE FROM FIREBASE----\\
  Future<void> _loadProfileImage() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        setState(() {
          image =
              userDoc['image']; // Ensure 'image' is the field name in Firestore
          isLoading = false;
        });
      } catch (e) {
        print("Error fetching profile image: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //----UPLOAD PROFILE PICTURE TO FIREBASE STORAGE----\\
  Future<void> _uploadImageToFirebase(File imageFile) async {
    if (currentUser != null) {
      try {
        // Upload the file to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${currentUser!.uid}.jpg');

        await ref.putFile(imageFile);

        // Get the download URL
        String downloadUrl = await ref.getDownloadURL();

        // Update Firestore with the new profile image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .update({
          'image': downloadUrl, // 'image' is the Firestore field name
        });

        setState(() {
          image = downloadUrl; // Update local image URL immediately
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile picture updated successfully!')),
        );
      } catch (e) {
        print("Error uploading profile picture: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile picture.')),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File imageFile = File(image.path);
      // Upload image to Firebase
      await _uploadImageToFirebase(imageFile);
    }
    Navigator.pop(context); // Close the image source action sheet
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.mainBlue),
                title: const Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppColor.mainBlue),
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
      child: isLoading
          ? const CircularProgressIndicator()
          : Stack(
              children: [
                CircleAvatar(
                  radius: SizeConfig.screenHeight * 0.110,
                  backgroundImage: image != null
                      ? NetworkImage(image!)
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
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
