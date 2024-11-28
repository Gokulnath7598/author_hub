import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/app_assets.dart';

SizedBox getSpace(double height, double width) {
  return SizedBox(height: height, width: width);
}

SizedBox emptyBox() {
  return const SizedBox();
}

Widget loaderWidget(BuildContext context, {Color? backgroundColor}) {
  return AbsorbPointer(
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: backgroundColor ?? Colors.grey.withOpacity(0.5),
      child: Center(
        child: Lottie.asset(AppAssets.loader, height: 60),
      ),
    ),
  );
}
