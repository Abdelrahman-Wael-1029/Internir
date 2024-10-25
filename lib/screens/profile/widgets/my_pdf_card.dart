import 'package:flutter/material.dart';
import 'package:internir/utils/size_config.dart';
import 'package:intl/intl.dart';
import '../../../utils/app_color.dart';

class MyPdf extends StatelessWidget {
  const MyPdf({
    super.key,
    required this.fileName,
    required this.lastModified,
    required this.onDelete,
  });

  final String fileName;
  final DateTime lastModified;
  final VoidCallback onDelete;

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
                fileName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Last Modified: ${DateFormat('yyyy-MM-dd').format(lastModified)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: AppColor.red,
              size: 30,
            ),
            onPressed: onDelete,
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
        ],
      ),
    );
  }
}
