import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/screens/profile/resume_screen.dart';
import 'package:internir/screens/profile/settings_screen.dart';
import 'package:internir/screens/profile/widgets/profile_options.dart';
import '../../utils/app_color.dart';
import '../../utils/size_config.dart';
import '../authentication/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String? username;
  String? category;
  String? image;
  bool isLoading = true;
  bool dataChanged = true;

  //----GET DATA----\\
  Future<void> getData() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .get();

        setState(() {
          username = userDoc['username'];
          category = userDoc['category'];
          image = userDoc['image'];
          isLoading = false;
        });
      } catch (e) {
        print("Error fetching user data: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 33,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 24,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : Container(
              color: AppColor.background,
              margin: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  //----PROFILE IMAGE----\\
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.27,
                    child: CircleAvatar(
                      radius: SizeConfig.screenHeight * 0.110,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: image != null && image!.isNotEmpty
                          ? NetworkImage(image!)
                          : AssetImage('assets/images/profile_pic.png'),
                    ),
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.012),

                  // Display the username and category
                  Text(
                    username ??
                        "Username not available",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    category ??
                        "Category not available",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.032),

                  //----PROFILE OPTIONS----\\
                  // Inside your ProfileOptions for Edit Profile
                  ProfileOptions(
                    icon: Icons.manage_accounts,
                    label: 'Edit Profile',
                    iconTrail: Icons.arrow_forward_ios,
                    onTap: () async {
                      final updatedData = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfilePage()),
                      );
                      if (updatedData != null) {
                        setState(() {
                          username = updatedData['username'];
                          category = updatedData['category'];
                          image = updatedData['image'];
                          // Optionally update the profile image if you have a way to change it
                        });
                      }
                    },
                  ),
                  ProfileOptions(
                      icon: Icons.sticky_note_2_outlined,
                      label: 'My Resumes',
                      iconTrail: Icons.arrow_forward_ios,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const ResumePage()));
                      }),
                  ProfileOptions(
                      icon: Icons.settings,
                      label: 'Settings',
                      iconTrail: Icons.arrow_forward_ios,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage()));
                      }),
                  ProfileOptions(
                      icon: Icons.logout,
                      label: 'Log Out',
                      iconColor: AppColor.red,
                      textColor: AppColor.red,
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }),
                ],
              ),
            ),
    );
  }
}
