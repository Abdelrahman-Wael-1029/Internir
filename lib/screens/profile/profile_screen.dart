import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/screens/profile/edit_profile_screen.dart';
import 'package:internir/screens/profile/resume_screen.dart';
import 'package:internir/screens/profile/settings_screen.dart';
import 'package:internir/screens/profile/widgets/profile_options.dart';
import 'package:internir/utils/size_config.dart';

import '../../utils/app_color.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
          style: TextStyle(
            color: AppColor.black,
            fontSize: 33,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 24,
      ),
      body: Container(
        color: AppColor.background,
        margin: const EdgeInsets.all(20),
        child: ListView(
          children:  [
            //----PROFILE IMAGE----\\
            SizedBox(
              height: SizeConfig.screenHeight*0.27,
              child:CircleAvatar(
                radius: SizeConfig.screenHeight*0.110,
                // backgroundImage: const AssetImage(''),
                backgroundColor: Colors.grey[200],
              )
            ),

            SizedBox(height: SizeConfig.screenHeight*0.012),

            const Text('data', textAlign: TextAlign.center,
                style: TextStyle(fontSize:25 , fontWeight:  FontWeight.bold)),
            const Text('data', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15)),

            SizedBox(height: SizeConfig.screenHeight*0.032),

            //----PROFILE OPTIONS----\\
            ProfileOptions(icon: Icons.manage_accounts,
                label: 'Edit Profile' ,
                iconTrail: Icons.arrow_forward_ios,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const EditProfilePage()));
                }),
            ProfileOptions(icon: Icons.sticky_note_2_outlined,
                label: 'My Resumes',
                iconTrail: Icons.arrow_forward_ios,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ResumePage()));
                  }
                ),
            ProfileOptions(icon: Icons.settings, 
                label: 'Settings',
                iconTrail: Icons.arrow_forward_ios,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  const SettingsPage()));
                }),
            ProfileOptions(icon: Icons.logout,
              label: 'Log Out',
              iconColor: AppColor.red,
              textColor: AppColor.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Container()));
              }),
          ]
        )
      ),
    );
  }
}
