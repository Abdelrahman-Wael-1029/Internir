import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/models/job_model.dart';

class ApplyToJob extends StatefulWidget {
  const ApplyToJob({super.key, required this.job});

  final JobModel job;
  static const String routeName = 'applyToJob';

  @override
  _ApplyToJobState createState() => _ApplyToJobState();
}

class _ApplyToJobState extends State<ApplyToJob> {
  final _formKey = GlobalKey<FormState>();
  String? _pickedFileName;
  bool _isFilePicked = false;
  String? _userImagePath;
  String? _username;
  String? _category;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          _userImagePath = doc['image'] as String?;
          _username = doc['username'] as String?;
          _category = doc['category'] as String?;
        });
      }
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _pickedFileName = result.files.single.name;
        _isFilePicked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected: $_pickedFileName')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  void _uploadResume(BuildContext context) {
    if (_isFilePicked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume uploaded!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a file first!')),
      );
    }
  }

  void _sendApplication(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application sent!')),
      );
      setState(() {
        _pickedFileName = null;
        _isFilePicked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Apply to ${widget.job.title}',
          overflow: TextOverflow.visible,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: _userImagePath != null
                        ? FileImage(
                            File(_userImagePath!),
                          )
                        : null,
                    child: _userImagePath == null
                        ? const Icon(Icons.person, size: 32)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _username ?? 'No name',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(_category ?? 'No category'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Resume',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Be sure to include an updated resume',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickFile,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: Text(
                      _pickedFileName ?? 'Choose Resume',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _uploadResume(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Upload Resume'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.lightBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _sendApplication(context),
                child: const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
