import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/size_config.dart';

class MyPdf extends StatefulWidget {
  const MyPdf({
    super.key,
    required this.file,
    required this.onDelete,
  });
  final File file;
  final VoidCallback onDelete;

  @override
  State<MyPdf> createState() => _MyPdfState();
}

class _MyPdfState extends State<MyPdf> {
 DateTime? lastModified;

  @override
  void initState() {
    super.initState();
    _lastModifiedDate(); // Get the file modification date when the widget initializes
  }


  //---- Function to show the confirmation dialog ----\\
  Future<void> _showDeleteConfirmation() async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this PDF?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false (cancel)
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true (confirm)
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    if (result == true) {
      widget.onDelete();
    }
  }

  //----Function to get the last modification date of the file----\\
  Future<void> _lastModifiedDate() async {
    final fileStat = await widget.file.stat(); // Get file metadata
    setState(() {
      lastModified = fileStat.modified; // Set the modification date
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/images/pdf.png'),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.file.path.split('/').last,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(lastModified != null
                  ? 'Last Updated: ${DateFormat('yyyy-MM-dd').format(lastModified!)}'
                  : 'Loading...', // Show date or loading
                style: const TextStyle(fontSize: 14, color: Colors.grey),),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: AppColor.red,
              size: 30,
            ),
            onPressed: _showDeleteConfirmation, // Show dialog when pressed
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1,)
        ],
      ),
    );
  }
}
