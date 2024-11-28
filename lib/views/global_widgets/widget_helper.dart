import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../app_config.dart';
import '../../core/app_assets.dart';
import '../../core/utils/utils.dart';

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
      color: backgroundColor ?? Colors.grey.withOpacity(0.2),
      child: Center(
        child: Lottie.asset(AppAssets.loader, height: 60.h),
      ),
    ),
  );
}

Widget deleteButton({required void Function() onTap, bool isLarge = false}) {
  return Builder(
    builder: (BuildContext context) {
      final TextTheme textTheme = Theme.of(context).textTheme;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(
                  20.r),
              border: Border.all(
                  color: Colors.redAccent,
                  width: 2.sp)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 4.h,
                horizontal: 10.w),
            child: Text('Delete',
                style: textTheme.headlineSmall
                    ?.copyWith(
                  fontSize: isLarge ? 18.sp:null,
                    color: Colors
                        .redAccent)),
          ),
        ),
      );
    }
  );
}

Widget favouriteAsset({required bool? isFavourite}) {
  return SvgPicture.asset(AppAssets.heart,
      color: (isFavourite ?? false) ? Colors.redAccent:Colors.grey[100], height: 25.h);
}

Widget profilePic({required double size, required String? url}){
  return Center(
    child: ClipRRect(
        borderRadius:
        BorderRadius.circular(500.r),
        child: FadeInImage(
          height: size,
          width: size,
          image: NetworkImage(Utils.nullOrEmpty(url)
              ? 'https://picsum.photos/200'
              : '${AppConfig.shared.scheme}://${AppConfig.shared.host}/$url'),
          placeholder: const AssetImage(AppAssets.logo), // Replace with your asset path
          fit: BoxFit.cover, // Adjust as needed
        )
    ),
  );
}