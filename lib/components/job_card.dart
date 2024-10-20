import 'package:flutter/material.dart';
import 'package:internir/screens/apply/apply_screen.dart';
import 'custom_button.dart';
import '../models/job_model.dart';
import '../utils/app_color.dart';
import '../utils/size_config.dart';

Widget jobCard(JobModel job, BuildContext context, {bool isApplied = false}) {
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                job.title,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16 * SizeConfig.textRatio,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 8 * SizeConfig.horizontalBlock,
            ),
            if (isApplied == true)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8 * SizeConfig.horizontalBlock,
                  vertical: 4 * SizeConfig.verticalBlock,
                ),
                decoration: BoxDecoration(
                  color: AppColor.mainGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_outlined,
                      color: AppColor.white,
                      size: 20 * SizeConfig.textRatio,
                    ),
                    SizedBox(
                      width: 4 * SizeConfig.horizontalBlock,
                    ),
                    Text(
                      "Applied",
                      style: TextStyle(
                        fontSize: 12 * SizeConfig.textRatio,
                        color: AppColor.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(
          height: 3 * SizeConfig.verticalBlock,
        ),
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
        SizedBox(
          height: 4 * SizeConfig.verticalBlock,
        ),
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
                  SizedBox(
                    height: 4 * SizeConfig.verticalBlock,
                  ),
                  if (DateTime.now().difference(job.createdAt).inDays < 2)
                    Text(
                      "Posted ${DateTime.now().difference(job.createdAt).inHours} Hours Ago",
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12 * SizeConfig.textRatio,
                        fontWeight: FontWeight.w500,
                        color: AppColor.grey1,
                      ),
                    ),
                  if (DateTime.now().difference(job.createdAt).inDays >= 2)
                    Text(
                      "Posted ${DateTime.now().difference(job.createdAt).inDays} Days Ago",
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
            SizedBox(
              width: 16 * SizeConfig.horizontalBlock,
            ),
            (isApplied)
                ? CustomButton(
              text: "Know More",
              width: 160 * SizeConfig.horizontalBlock,
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
            )
                : CustomButton(
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