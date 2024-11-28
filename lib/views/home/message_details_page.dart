
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app_config.dart';
import '../../core/utils/utils.dart';
import '../../models/messages_response.dart';
import '../global_widgets/widget_helper.dart';

class MessageDetailsPage extends StatelessWidget {
  const MessageDetailsPage({super.key, required this.message});
  final Message? message;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.redAccent,
        ),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text('Details', style: textTheme.titleLarge?.copyWith(fontSize: 22.sp)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: favouriteAsset(isFavourite: message?.isFavourite),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            getSpace(20.h, 0),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500.r), // Set the border radius
                child: Image.network(
                  Utils.nullOrEmpty(message?.author
                      ?.photoUrl)
                      ? 'https://picsum.photos/200'
                      : '${AppConfig.shared.scheme}://${AppConfig.shared.host}/${message?.author?.photoUrl}',
                  height: 250.h,
                  width: 250.h,
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ),
            ),
            getSpace(20.h, 0),
            Text(message?.author?.name ?? '', textAlign: TextAlign.center, style: textTheme.titleLarge?.copyWith(fontSize: 22.sp)),
            getSpace(20.h, 0),
            Text(message?.content ?? '', textAlign: TextAlign.center, style: textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
