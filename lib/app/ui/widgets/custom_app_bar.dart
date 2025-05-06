import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:voyzi/app/utils/constants/app_edge_insets.dart';
import 'package:voyzi/app/utils/constants/app_strings.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/themes/app_theme.dart';

Widget customAppBar(
    {required BuildContext context,
    required AppStyles appStyles,
    required AppColors appColors}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Gap(8),
      // Image.asset(
      //   Assets.png.drawer.path,
      //   height: 33,
      // ),
      Gap(10),
      Transform.translate(
        offset: Offset(0, -1),
        child: Text(
          AppStrings.T.voyzi,
          style: appStyles.s26w700White.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
    ],
  );
}
