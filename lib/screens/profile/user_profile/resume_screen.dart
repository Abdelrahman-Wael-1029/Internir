import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/components/custom_button.dart';
import 'package:internir/screens/profile/widgets/my_pdf_card.dart';
import 'package:internir/utils/size_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../utils/app_color.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  List<String> uploadedFileUrls = [];
  List<File> uploadedFiles = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchUploadedFiles();
  }

  Future<void> fetchUploadedFiles() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('uploadedFiles')) {
          setState(() {
            uploadedFileUrls = List<String>.from(data['uploadedFiles']);
            uploadedFiles = uploadedFileUrls.map((url) {
              String fileName = url.split('/').last;
              return File(fileName);
            }).toList();
          });
        }
      }
    }
  }

  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String downloadUrl = await uploadPdf(file);
        if (downloadUrl.isEmpty) return;

        String fileName = file.path.split('/').last;

        setState(() {
          uploadedFileUrls.add(downloadUrl);
          uploadedFiles.add(File(fileName));
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$fileName uploaded successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file selected.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file: $e'),
        ),
      );
    }
  }

  Future<String> uploadPdf(File file) async {
    try {
      Reference ref =
      FirebaseStorage.instance.ref('resumes/${file.path.split('/').last}');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .update({
          'uploadedFiles': FieldValue.arrayUnion([downloadUrl]),
        });
      }

      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There was an error uploading your PDF.'),
        ),
      );
      return '';
    }
  }


  //----REMOVE FILE----\\
  void removeFile(String fileUrl) async {
    try {
      setState(() {
        int index = uploadedFileUrls.indexOf(fileUrl);
        if (index != -1) {
          uploadedFileUrls.removeAt(index);
          uploadedFiles.removeAt(index);
        }
      });

      Reference ref = FirebaseStorage.instance.refFromURL(fileUrl);
      await ref.delete();

      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .update({
          'uploadedFiles': FieldValue.arrayRemove([fileUrl]),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove the file.')),
      );
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
                      file: file,
                      onDelete: () => removeFile(uploadedFileUrls[index]),
                    );
                  }),
            ),

            //----UPLOAD BUTTON----\\
            CustomButton(
                text: 'Upload Resume',
                fontSize: 25,
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                backgroundColor: AppColor.indigo,
                textColor: AppColor.lightGrey,
                onPressed: () async {
                  await uploadFile();
                })
          ],
        ),
      ),
    );
  }
}
