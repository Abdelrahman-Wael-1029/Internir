import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internir/services/fire_storage.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _pickedFileName;
  String? _userImageURL;
  String? _username;
  String? _email;
  String? _phone;
  String? _category;
  bool _isFilePicked = false;
  bool _isLoading = false;
  Uint8List? file;

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
          _userImageURL = doc['image'] as String? ?? '';
          _username = doc['username'] as String? ?? 'No name';
          _category = doc['category'] as String? ?? 'No category';
          _email = doc['email'] as String? ?? '';
          _phone = doc['phone'] as String? ?? '';
          _emailController.text = _email ?? '';
          _phoneController.text = _phone ?? '';
        });
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        print(result.xFiles.first.toString() + ' this is result');
        file = await result.xFiles.first.readAsBytes();
        print(file.toString() + ' this is file');
        _pickedFileName = result.files.single.name;
        _isFilePicked = true;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: $_pickedFileName')),
        );
        setState(() {});
        print(file.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> addJobToUserAppliedJobs(String userId, String jobId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'appliedJobs': FieldValue.arrayUnion([jobId]),
      });
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There has been an error!'),
        ),
      );
    }
  }

  Future<void> _sendApplication(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      if (!_isFilePicked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload your resume before applying!'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        String companyId = widget.job.companyID;

        String email = _emailController.text.trim();
        String phone = _phoneController.text.trim();
        String? fileUrl;
        print(_isFilePicked);
        print(file != null);
        if (_isFilePicked && file != null) {
          fileUrl = await FireStorage.uploadFile(
            path:
                'jobs/${widget.job.id}/applications/${FirebaseAuth.instance.currentUser!.uid}',
            fileName: _pickedFileName ?? 'resume.pdf',
            file: file!,
            contentType: 'application/pdf',
          );
        }

        Map<String, dynamic> applicationData = {
          'email': email,
          'phone': phone,
          'jobId': widget.job.id,
          'jobTitle': widget.job.title,
          'appliedAt': FieldValue.serverTimestamp(),
          'status': 'pending',
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'username': _username ?? 'Anonymous', // Added null safety
          'category': _category ?? 'General', // Added null safety
          'resume': fileUrl,
        };

        await FirebaseFirestore.instance
            .collection('company')
            .doc(companyId)
            .collection('jobs')
            .doc(widget.job.id)
            .collection('applications')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(applicationData);

        await FirebaseFirestore.instance
            .collection('jobs')
            .doc(widget.job.id)
            .update({'number of applicants': FieldValue.increment(1)});
        widget.job.numberOfApplicants += 1;

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await addJobToUserAppliedJobs(user.uid, widget.job.id);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application sent successfully!')),
        );

        setState(() {
          _pickedFileName = null;
          _isFilePicked = false;
        });

        Navigator.pop(context);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending application: $e')),
        );
      }
      setState(() {
        _isLoading = false;
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
                    backgroundImage:
                        _userImageURL != null && _userImageURL!.isNotEmpty
                            ? NetworkImage(_userImageURL!)
                            : null,
                    child: _userImageURL == null || _userImageURL!.isEmpty
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  var reg = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (!reg.hasMatch(value)) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone is required';
                    }
                    RegExp reg = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
                    if (!reg.hasMatch(value)) {
                      return 'Invalid phone number';
                    }
                    return null;
                  }),
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
                  height: 120,
                  width: double.infinity,
                  child: _isFilePicked
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.file_present,
                              size: 32,
                              color: AppColor.mainBlue,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _pickedFileName ?? 'No file selected',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 32,
                              color: AppColor.mainBlue,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Upload resume',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _sendApplication(context),
                      child: const Text('Apply Now'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
