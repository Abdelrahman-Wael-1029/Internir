import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:internir/components/custom_button.dart';
import 'package:internir/screens/profile/widgets/my_pdf_card.dart';
import 'package:internir/utils/size_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../utils/app_color.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  List<File> uploadedFiles = [];
  bool _isFileUploaded = false;

  //----UPLOAD FILE----\\
  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        uploadedFiles.add(file);
        _isFileUploaded = true;
      });
    }
  }
  // Remove file from the list
  void removeFile(File file) {
    setState(() {
      uploadedFiles.remove(file);
    });
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
                      onDelete: () => removeFile(file),
                    );
                }
              ),
            ),

            //----UPLOAD BUTTON----\\
            CustomButton(
                text: 'Upload Resume',
                fontSize: 25,
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                backgroundColor: AppColor.indigo,
                textColor: AppColor.lightGrey ,
                onPressed: () async {
                  await uploadFile();
                }
            )
          ],
        ),
      ),
    );
  }
}


