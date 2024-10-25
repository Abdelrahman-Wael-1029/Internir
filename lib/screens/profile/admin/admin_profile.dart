import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/screens/profile/admin/admin_editscreen.dart';
import '../../../utils/app_color.dart';
import '../../../utils/size_config.dart';
import '../../authentication/login_screen.dart';
import '../user_profile/settings_screen.dart';
import '../widgets/profile_options.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String? username;
  String? description;
  String? image;
  bool isLoading = true;
  bool dataChanged = true;

  //----GET DATA----\\
  Future<void> getData() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot companyDoc = await FirebaseFirestore.instance
            .collection("company")
            .doc(currentUser!.uid)
            .get();

        setState(() {
          username = companyDoc['name'];
          description = companyDoc['description'];
          image = companyDoc['image'];
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
          ? const Center(child: CircularProgressIndicator())
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

                  //----DISPLAY USERNAME----\\
                  Text(
                    username ?? "Username not available",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),

                  //----DISPLAY CATEGORY----\\
                  Text(
                    description ?? "Description not available",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.032),

                  //--------PROFILE OPTIONS--------\\

                  //----EDIT PROFILE----\\
                  ProfileOptions(
                    icon: Icons.manage_accounts,
                    label: 'Edit Profile',
                    iconTrail: Icons.arrow_forward_ios,
                    onTap: () async {
                      final updatedData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminEditProfileScreen()),
                      );
                      if (updatedData != null) {
                        setState(() {
                          username = updatedData['name'];
                          description = updatedData['description'];
                          image = updatedData['image'];
                        });
                        getData();
                      }
                    },
                  ),

                  //----SETTINGS----\\
                  ProfileOptions(
                      icon: Icons.settings,
                      label: 'Settings',
                      iconTrail: Icons.arrow_forward_ios,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileSettingsPage()));
                      }),

                  //----LOG OUT----\\
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
