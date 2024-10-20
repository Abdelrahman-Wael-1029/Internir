import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';
import 'package:internir/screens/authentication/login_screen.dart';
import 'package:internir/screens/home/home_screen.dart';
import 'package:internir/screens/layout/home_layout.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../providers/jobs_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  static const String routeName = '/create-account';

  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  String? selectedCategory;
  String? selectedGender;
  String? selectedCvFile;
  File? selectedImage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final List<String> genderOptions = [
    'Male',
    'Female',
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
        return;
      }

      try {
        setState(() {
          _isLoading = true;
        });

        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userId = userCredential.user!.uid;

        await _firestore.collection('users').doc(userId).set({
          'image': selectedImage?.path,
          'username': _usernameController.text,
          'email': email,
          'phone': _phoneController.text,
          'dob': _dobController.text,
          'category': selectedCategory,
          'gender': selectedGender,
          'cvFile': selectedCvFile,
          'appliedJobs': [],
          'savedJobs': [],
        });

        setState(() {
          _isLoading = false;
        });

        var jobProvider = context.read<JobsProvider>();
        await jobProvider.fetchJobs();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeLayout(),
            
          ),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else {
          errorMessage = e.message ?? 'Error occurred during sign up';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-"
            "${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Create ",
                      style: TextStyle(
                        fontFamily: 'Greta Arabic',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "Account",
                      style: TextStyle(
                        fontFamily: 'Greta Arabic',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Create an account so you can explore all the existing jobs",
                style: TextStyle(
                  fontFamily: 'Greta Arabic',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Gallery'),
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Camera'),
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : const AssetImage('assets/images/profile.png')
                          as ImageProvider,
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                decoration: InputDecoration(
                  labelText: "Username",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A valid username is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  // regix for email validation
                  var reg = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (!reg.hasMatch(value)) {
                    return 'Invalid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                ],
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'A valid phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month),
                  labelText: "Date Of Birth",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Date of birth is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Confirm your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Categories',
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedCategory,
                items: listCategories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedGender,
                items: genderOptions
                    .map(
                      (gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );

                  if (result != null) {
                    setState(() {
                      selectedCvFile = result.files.single.name;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCvFile ?? 'Upload CV',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const Icon(Icons.upload_file, color: Colors.indigo),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.indigo,
                  ),
                  child: (_isLoading)
                      ? const CircularProgressIndicator(color: Colors.white,)
                      : const Text(
                          'Register',
                          style: TextStyle(
                            fontFamily: 'Greta Arabic',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.routeName,
                    (route) => false,
                  );
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
