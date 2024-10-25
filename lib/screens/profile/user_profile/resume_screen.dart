import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internir/components/custom_button.dart';
import 'package:internir/screens/profile/widgets/my_pdf_card.dart';
import '../../../utils/app_color.dart';
import '../../../utils/size_config.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  List<Map<String, dynamic>> uploadedFiles = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchUploadedFiles();
  }

  Future<void> fetchUploadedFiles() async {
    if (currentUser != null) {
      final userFolder = 'resumes/${currentUser!.uid}/';
      final ListResult result = await FirebaseStorage.instance.ref(userFolder).listAll();

      List<Map<String, dynamic>> fileList = [];
      for (var item in result.items) {
        final fileMetadata = await item.getMetadata();
        fileList.add({
          'name': item.name,
          'lastModified': fileMetadata.updated,
        });
      }

      setState(() {
        uploadedFiles = fileList;
      });
    }
  }


  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      await uploadPdf(file);
    }
  }


  Future<void> uploadPdf(File file) async {
    try {
      final userFolder = 'resumes/${currentUser!.uid}/';
      Reference ref = FirebaseStorage.instance.ref('$userFolder${file.path.split('/').last}');
      await ref.putFile(file);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF uploaded successfully!')));
      fetchUploadedFiles();
    } catch (e) {
      print("Error uploading PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to upload PDF.')));
    }
  }


  Future<void> deleteFile(String fileName) async {
    try {
      final userFolder = 'resumes/${currentUser!.uid}/';
      Reference ref = FirebaseStorage.instance.ref('$userFolder$fileName');
      await ref.delete();
      fetchUploadedFiles();
    } catch (e) {
      print("Error deleting file: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete PDF.')));
    }
  }


  Future<void> _showDeleteConfirmation(String fileName) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this PDF?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await deleteFile(fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resume',
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: AppColor.background,
        centerTitle: true,
        iconTheme: const IconThemeData(size: 30, color: AppColor.black),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        color: AppColor.background,
        child: ListView(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.8,
              child: ListView.builder(
                itemCount: uploadedFiles.length,
                itemBuilder: (context, index) {
                  final file = uploadedFiles[index];
                  return MyPdf(
                    fileName: file['name'],
                    lastModified: file['lastModified'],
                    onDelete: () => _showDeleteConfirmation(file['name']),
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Upload Resume',
              fontSize: 25,
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              backgroundColor: AppColor.indigo,
              textColor: AppColor.lightGrey,
              onPressed: uploadFile,
            ),
          ],
        ),
      ),
    );
  }
}
