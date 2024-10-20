import 'package:flutter/material.dart';
import 'package:internir/screens/apply/apply_screen.dart';
import 'custom_button.dart';
import '../models/job_model.dart';
import '../utils/app_color.dart';
import '../utils/size_config.dart';

Widget savedJobCard(JobModel job, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 16 * SizeConfig.horizontalBlock,
      vertical: 16 * SizeConfig.verticalBlock,
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 6,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.title,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16 * SizeConfig.textRatio,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 3 * SizeConfig.verticalBlock),
        Text(
          job.company,
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12 * SizeConfig.textRatio,
            fontWeight: FontWeight.w500,
            color: AppColor.grey3,
          ),
        ),
        SizedBox(height: 4 * SizeConfig.verticalBlock),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location: ${job.location}${(job.jobType != null) ? " (${job.jobType})" : ""}",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12 * SizeConfig.textRatio,
                      fontWeight: FontWeight.w500,
                      color: AppColor.grey1,
                    ),
                  ),
                  if (job.salary != null)
                    Text(
                      "Salary: ${job.salary}",
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12 * SizeConfig.textRatio,
                        fontWeight: FontWeight.w500,
                        color: AppColor.grey1,
                      ),
                    ),
                  SizedBox(height: 4 * SizeConfig.verticalBlock),
                  Text(
                    "Posted ${DateTime.now().difference(job.createdAt).inDays < 1 ? '${DateTime.now().difference(job.createdAt).inHours} Hours Ago' : '${DateTime.now().difference(job.createdAt).inDays} Days Ago'}",
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12 * SizeConfig.textRatio,
                      fontWeight: FontWeight.w500,
                      color: AppColor.grey1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16 * SizeConfig.horizontalBlock),
            CustomButton(
              text: "Apply",
              width: 100 * SizeConfig.horizontalBlock,
              height: 40 * SizeConfig.verticalBlock,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ApplyScreen.routeName,
                  arguments: job,
                );
              },
              backgroundColor: AppColor.lightBlue,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 16 * SizeConfig.horizontalBlock,
                vertical: 8 * SizeConfig.verticalBlock,
              ),
              fontSize: 14 * SizeConfig.textRatio,
            ),
          ],
        ),
      ],
    ),
  );
}
