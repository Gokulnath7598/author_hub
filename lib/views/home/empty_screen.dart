import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_assets.dart';
import '../global_widgets/widget_helper.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 120.h),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext ctx, int index) => Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[100]!),
                borderRadius: BorderRadius.circular(20.r)),
            margin: EdgeInsets.symmetric(
                horizontal: 10.w, vertical: 5.h),
            padding: EdgeInsets.symmetric(
                horizontal: 15.w, vertical: 10.h),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(500.r),
                  child: Image.asset(AppAssets.logo, height: 50.h),
                ),
                getSpace(0, 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(color: Colors.grey[100], height: 15.h),
                      getSpace(5.h, 0),
                      Container(color: Colors.grey[100], height: 10.h)
                    ],
                  ),
                )
              ],
            )));
  }
}
