import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/utils/app_color.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(
          color: AppColor.black,
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        iconTheme: const IconThemeData(
            size: 30,
            color: AppColor.black
        ),
      ),

      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        color: AppColor.background,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            //---- NOTIFICATION TOGGLE WITH ICON ----\\
            ListTile(
              leading: const Icon(Icons.notifications_none, size: 30, color: AppColor.mainBlue,),
              title: const Text('Enable Notifications',
                style: TextStyle(fontSize: 18),),
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
              leading: const Icon(Icons.lock_outline, size: 30, color: AppColor.mainBlue ),
              title: const Text('Change Password', style: TextStyle(fontSize: 18),),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showChangePasswordDialog();
              },
            ),
            const Divider(),

            //---- DELETE ACCOUNT ----\\
            ListTile(
              leading: const Icon(Icons.delete_outline,size: 30 ,color: AppColor.red),
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
              leading: const Icon(Icons.info_outline, size: 30, color: AppColor.mainBlue),
              title: const Text('About App',
                style: TextStyle(fontSize: 18),),
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

  //---- SHOW CHANGE PASSWORD DIALOG ----\\
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: const Text('Password change functionality is not implemented yet.'),
          actions: [
            TextButton(
              onPressed: () async  {
                    Navigator.pop(context);
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: "user@example.com");
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
          content: const Text('Are you sure you want to delete your account? This action is irreversible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var user;
                await user?.delete();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted')),
                );
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Container()));
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  //---- SHOW ABOUT APP DIALOG ----\\
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Internir',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.app_blocking),
      applicationLegalese: '© 2024 Your Company Name',
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('This app is a demonstration of how to implement settings in Flutter.'),
        ),
      ],
    );
  }
}
