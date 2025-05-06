import 'package:flutter/material.dart';
import 'package:voyzi/app/utils/constants/app_edge_insets.dart';
import 'package:voyzi/app/utils/constants/app_strings.dart';

import '../../utils/constants/app_border_radius.dart';
import '../../utils/themes/app_theme.dart';
import 'custom_image_view.dart';

Widget replyTile({
  required String imagePath,
  required String name,
  required String minute,
  required AppStyles appStyles,
  required AppColors appColors,
}) {
  return ListTile(
    contentPadding: AppEdgeInsets.h10() - EdgeInsets.symmetric(vertical: 5),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: appStyles.s22w700Black
              .copyWith(fontWeight: FontWeight.w500, height: 1),
        ),
        Text(
          AppStrings.T.replied,
          style: appStyles.s20w700Black.copyWith(
              color: Color(0xff2A5483),
              fontWeight: FontWeight.w400,
              fontSize: 19),
        ),
      ],
    ),
    // subtitle: Text(
    //   AppStrings.T.replied,
    //   style: appStyles.s20w700Black
    //       .copyWith(color: Color(0xff2A5483), fontWeight: FontWeight.w400),
    // ),
    leading: Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.all16(),
        shape: BoxShape.rectangle,
      ),
      child: ImageView(
        imagePath: imagePath,
        fit: BoxFit.cover,
        radius: AppBorderRadius.all16(),
      ),
    ),
    trailing: Transform.translate(
      offset: Offset(0, -12),
      child: Text(
        '${minute}m ago',
        style: appStyles.s20w700Black.copyWith(
          color: Color(0xff48759E),
          fontSize: 19,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
