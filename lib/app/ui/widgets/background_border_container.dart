import 'package:flutter/material.dart';
import 'package:voyzi/app/utils/constants/app_edge_insets.dart';

import '../../utils/themes/app_theme.dart';

Widget borderContainer(
        {required Widget child,
        required AppColors appColors,
        required List<Color> colors,
        bool givepadding = true,
        List<BoxShadow>? boxShadow,
        Color? borderColor,
        double? radius,
        EdgeInsetsGeometry? padding = const AppEdgeInsets.all18()}) =>
    Container(
      padding: padding,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        border:
            Border.all(color: borderColor ?? appColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(radius ?? 40),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
