import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/screens/authentication/login_screen.dart';
import 'package:internir/utils/app_color.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        iconTheme: const IconThemeData(size: 30, color: AppColor.black),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        color: AppColor.background,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            //---- NOTIFICATION TOGGLE WITH ICON ----\\
            ListTile(
              leading: const Icon(
                Icons.notifications_none,
                size: 30,
                color: AppColor.mainBlue,
              ),
              title: const Text(
                'Enable Notifications',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: AppColor.mainBlue,
                inactiveThumbColor: AppColor.indigo,
              ),
            ),
            const Divider(),

            //---- CHANGE PASSWORD ----\\
            ListTile(
              leading: const Icon(Icons.lock_outline,
                  size: 30, color: AppColor.mainBlue),
              title: const Text(
                'Change Password',
                style: TextStyle(fontSize: 18),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showChangePasswordDialog();
              },
            ),
            const Divider(),

            //---- DELETE ACCOUNT ----\\
            ListTile(
              leading: const Icon(Icons.delete_outline,
                  size: 30, color: AppColor.red),
              title: const Text('Delete Account',
                  style: TextStyle(color: AppColor.red, fontSize: 18)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showDeleteAccountDialog();
              },
            ),
            const Divider(),

            //---- ABOUT APP ----\\
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                size: 30,
                color: AppColor.mainBlue,
              ),
              title: const Text(
                'About App',
                style: TextStyle(fontSize: 18),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showAboutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  //---- SHOW ABOUT DIALOG ----\\
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About Internir'),
          content: const Text(
            'Internir is your gateway to exciting internship opportunities!'
                ' Our app is designed to connect aspiring professionals with valuable hands-on experiences'
                ' in their desired fields. Whether you’re looking to gain skills,'
                ' network with industry leaders, or kickstart your career, '
                'Internir is here to help you every step of the way.\n\n'
                'This app is developed by:\n'
                'Mariam Tarek\n'
                'Omar Ahmed\n'
                'Mohamed Ayman\n'
                'Abdelrahman Wael\n'
                'Shahd Khaled\n'
                'Salam Abdelaziz',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  //---- SHOW CHANGE PASSWORD DIALOG ----\\
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: const Text(
              'A password reset email has been sent to your email address. Follow the instructions to reset your password.'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: user.email!);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset email sent.'),
                      ),
                    );

                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                          (Route<dynamic> route) =>
                      false,
                    );
                  }
                } catch (e) {
                  print('Error sending password reset email: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                      Text('Failed to send reset email. Please try again.'),
                    ),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  //---- SHOW DELETE ACCOUNT CONFIRMATION ----\\
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action is irreversible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('company')
                        .doc(user.uid)
                        .delete();
                    await user.delete();

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Account Deleted Successfully')),
                    );

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }
                } catch (e) {
                  print('Error Deleting Account: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Failed to delete account. Please try again.')),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

